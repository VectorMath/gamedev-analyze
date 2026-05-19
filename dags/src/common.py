"""
The python file with common function that using in DAGs.
"""
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.providers.postgres.operators.postgres import PostgresOperator
import src.constants as const


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
