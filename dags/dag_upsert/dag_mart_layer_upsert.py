from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.utils.task_group import TaskGroup
from datetime import datetime

import src.constants as const
from src.common import update_hwm, get_params_for_update_hwm

with DAG(
        dag_id="upsert_data_in_mart_layer",
        schedule=None,
        catchup=False,
) as dag:
    dbt_run = BashOperator(
        task_id=const.UPSERT_DATA_TO_CORE_TASK_ID,
        bash_command="""
        docker exec dbt_core dbt run --profiles-dir /usr/app/dbt --select tag:mart
        """
    )

    with TaskGroup(group_id="update_hwm") as update_hwm_group:
        for schema_name, table_name in get_params_for_update_hwm('mart'):
            update_hwm(
                table_name=table_name,
                schema_name=schema_name
            )

    dbt_run >> update_hwm_group
