from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
from airflow.utils.task_group import TaskGroup
from datetime import datetime

import src.constants as const
from src.common import update_hwm, get_params_for_update_hwm

with DAG(
        dag_id="upsert_data_in_core_layer",
        start_date=datetime(2025, 1, 1),
        schedule="@daily",
        catchup=False,
) as dag:
    dbt_run = BashOperator(
        task_id=const.UPSERT_DATA_TO_CORE_TASK_ID,
        bash_command="""
        docker exec dbt_core dbt run --profiles-dir /usr/app/dbt --select tag:core
        """
    )

    with TaskGroup(group_id="update_hwm") as update_hwm_group:
        for schema_name, table_name in get_params_for_update_hwm('core'):
            update_hwm(
                table_name=table_name,
                schema_name=schema_name
            )

    trigger_mart_layer = TriggerDagRunOperator(
        task_id="trigger_mart_dag",
        trigger_dag_id="upsert_data_in_mart_layer",
        wait_for_completion=False
    )

    dbt_run >> update_hwm_group >> trigger_mart_layer
