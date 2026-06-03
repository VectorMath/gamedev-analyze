from airflow import DAG
from airflow.operators.python import PythonOperator, ShortCircuitOperator

import src.constants as const
from src.common import generate_csv_by_sql, send_telegram_report, is_first_day_of_month

"""
The DAG has second pipeline:

 - Check for first day of current month
 
 - In case it's not first day it will skip next tasks;
 
 - In case it's first day, it will generate CSV file with date by using SQL query below;
 
 - Sends CSV file in Telegram by using bot.
"""
with DAG(
        dag_id=const.DAG_MONTHLY_REPORT_ID,
        schedule=None,
        catchup=False,
) as dag:
    check_first_day = ShortCircuitOperator(
        task_id="check_first_day",
        python_callable=is_first_day_of_month
    )

    sql_query: str = """
        WITH active_europe_users AS (
            SELECT 
                us.id,
                us.age_group,
                us.gender
            FROM 
                mart."user" AS us
            JOIN 
                mart.mv_user_active_flag AS mv_act
                ON us.id = mv_act.user_id 
            WHERE  
                mv_act.is_active_30d IS TRUE
                AND us.region = 'Europe'
        )
        ,user_transactions AS (
            SELECT 
                tr."date",
                tr.user_id,
                tr.price_usd,
                act_us.age_group,
                act_us.gender,
                ROW_NUMBER() OVER(
                    PARTITION BY 
                        tr.user_id 
                    ORDER BY 
                        tr."date"
                ) AS transaction_number
            FROM 
                mart.mv_transaction_365d AS tr
            JOIN
                active_europe_users AS act_us
                ON tr.user_id = act_us.id 
            WHERE 
                "date" >= CURRENT_DATE - INTERVAL '30 days'
        )
        SELECT
            "date",
            user_id,
            age_group,
            gender,
            price_usd AS transaction_amount,
            SUM(price_usd) OVER(
                PARTITION BY
                    user_id
                ORDER BY 
                    "date"
            ) AS cumm_transaction_sum
        FROM  
            user_transactions
        WHERE
            transaction_number <= 5
        ORDER BY 
            user_id,
            "date"
    """

    generate_csv_file = PythonOperator(
        task_id=const.GENERATE_MONTHLY_CSV_FILE,
        python_callable=generate_csv_by_sql,
        op_kwargs={
            "sql_query": sql_query,
            "path": const.PATH_TO_MONTHLY_CSV_EURO_TRANSACTIONS
        }
    )

    send_csv_to_email = PythonOperator(
        task_id=const.SEND_CSV_TO_EMAIL,
        python_callable=send_telegram_report,
        op_kwargs={
            "path_to_file": const.PATH_TO_MONTHLY_CSV_EURO_TRANSACTIONS,
        }
    )

    check_first_day >> generate_csv_file >> send_csv_to_email
