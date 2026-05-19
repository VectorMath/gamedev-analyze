from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.providers.postgres.operators.postgres import PostgresOperator
import src.constants as const


def update_hwm(table_name: str, schema_name: str) -> PostgresOperator:
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
