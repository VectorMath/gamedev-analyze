from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
from airflow.utils.task_group import TaskGroup

import src.constants as const
from src.common import update_hwm, get_params_for_update_hwm, generate_dbt_command

"""
The DAG has second pipeline:

 - Running dbt models to upsert data from core layer to mart layer;

 - Update rows in high_watermark table for each mart table;
 
 - Trigger DAG DAG_MV_ID.
"""
with DAG(
        dag_id=const.DAG_MART_ID,
        schedule=None,
        catchup=False,
) as dag:
    dbt_run = BashOperator(
        task_id=const.UPSERT_DATA_TASK_ID,
        bash_command=generate_dbt_command(const.MART_LAYER_NAME)
    )

    with TaskGroup(group_id=const.UPDATE_HWM_GROUP_ID) as update_hwm_group:
        for schema_name, table_name in get_params_for_update_hwm(const.MART_LAYER_NAME):
            update_hwm(
                table_name=table_name,
                schema_name=schema_name
            )

    trigger_mv_dag = TriggerDagRunOperator(
        task_id=const.TRIGGER_MV_DAG_TASK_ID,
        trigger_dag_id=const.DAG_MV_ID,
        wait_for_completion=False
    )

    dbt_run >> update_hwm_group >> trigger_mv_dag
