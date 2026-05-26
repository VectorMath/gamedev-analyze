from airflow import DAG
from airflow.operators.bash import BashOperator

import src.constants as const
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
from src.common import generate_dbt_command

"""
The DAG generates materialized views in mart layer 
after upsert data in mart layer
"""
with DAG(
        dag_id=const.DAG_MV_ID,
        schedule=None,
        catchup=False,
) as dag:
    dbt_run = BashOperator(
        task_id=const.UPSERT_DATA_TASK_ID,
        bash_command=generate_dbt_command(const.MATERIAL_VIEW_TAG)
    )

    trigger_monthly_report_dag = TriggerDagRunOperator(
        task_id=const.TRIGGER_MONTHLY_REPORT_DAG_TASK_ID,
        trigger_dag_id=const.DAG_MONTHLY_REPORT_ID,
        wait_for_completion=False
    )

    dbt_run >> trigger_monthly_report_dag
