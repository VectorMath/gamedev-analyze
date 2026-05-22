from airflow import DAG
from airflow.operators.bash import BashOperator

import src.constants as const
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
