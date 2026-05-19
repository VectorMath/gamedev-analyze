from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.utils.task_group import TaskGroup

import src.constants as const
from src.common import update_hwm, get_params_for_update_hwm

with DAG(
        dag_id=const.DAG_MART_ID,
        schedule=None,
        catchup=False,
) as dag:
    dbt_run = BashOperator(
        task_id=const.UPSERT_DATA_TASK_ID,
        bash_command="""
        docker exec dbt_core dbt run --profiles-dir /usr/app/dbt --select tag:mart
        """
    )

    with TaskGroup(group_id=const.UPDATE_HWM_GROUP_ID) as update_hwm_group:
        for schema_name, table_name in get_params_for_update_hwm(const.MART_LAYER_NAME):
            update_hwm(
                table_name=table_name,
                schema_name=schema_name
            )

    dbt_run >> update_hwm_group
