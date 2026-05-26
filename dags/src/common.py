"""
The python file with common function that using in DAGs.
"""
from datetime import datetime

from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.utils.email import send_email
import src.constants as const
import pandas as pd
import requests


def generate_dbt_command(tag_name: str) -> str:
    """
    The function generates bash_command for Bash Operator in task.

    :param tag_name: the name of tag that models have
    :return: dbt command for running
    """
    return f"""
        docker exec dbt_core dbt run --profiles-dir /usr/app/dbt --select tag:{tag_name}
    """


def update_hwm(table_name: str, schema_name: str) -> PostgresOperator:
    """
    The function updates rows in the table high_watermark for specific table

    :param table_name: the name of table in DWH that should be updated
    :param schema_name: the name of schema in DWH the table belongs to
    :return: Postgres operator that using for DAG's tasks
    """
    return PostgresOperator(
        task_id=f"{const.UPDATE_HWM_TASK_ID}__{schema_name}__{table_name}",
        postgres_conn_id=const.DB_CONNECTION_ID,
        sql=f"""
            UPDATE 
                mart.high_watermark
            SET 
                created_at = (
                    SELECT MAX(created_at)
                    FROM {schema_name}.{table_name}
                ),
                updated_at = (
                    SELECT MAX(updated_at)
                    FROM {schema_name}.{table_name}
                )
            WHERE 
                schema_name = '{schema_name}'
                AND table_name = '{table_name}'
        """
    )


def get_params_for_update_hwm(schema_name: str) -> list[tuple[str, str]]:
    """
    The function that returns list of tuple
    for all existing tables for the schema_name in parameter

    :param schema_name: The name of schema in DWH.
    :return: list of tuple like ('schema_name', 'table_name')
    """
    hook = PostgresHook(postgres_conn_id=const.DB_CONNECTION_ID)

    records = hook.get_records(f"""
        SELECT
            schema_name,
            table_name
        FROM 
            mart.high_watermark
        WHERE 
            schema_name = '{schema_name}'
    """
                               )

    return [(schema, table) for schema, table in records]

def is_first_day_of_month():
    """
    The function checks is today first day of month or not.
    :return: boolean value (True if today is first day of month)
    """
    return datetime.now().day == 1

def generate_csv_by_sql(sql_query: str, path: str) -> None:
    """
    The function generates CSV-file with transaction for monthly report by Europe clients.
    :param path: the path where CSV-file should be saved.
    :param sql_query: the query that will prepare table for CSV.
    """
    hook = PostgresHook(postgres_conn_id=const.DB_CONNECTION_ID)
    df: pd.DataFrame = hook.get_pandas_df(sql_query)

    df.to_csv(path, index=False)


def send_telegram_report(path_to_file: str):

    with open(path_to_file, 'rb') as f:
        requests.post(
            f'https://api.telegram.org/bot{const.TG_BOT_TOKEN}/sendDocument',
            data={'chat_id': const.CHAT_ID},
            files={'document': f}
        )
