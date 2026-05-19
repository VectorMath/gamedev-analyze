"""
The python file with constants for DAGs and common function
"""

DB_CONNECTION_ID: str = "postgres_db" # The ID of postgres connection for Airflow

UPSERT_DATA_TO_CORE_TASK_ID: str = "upsert_data_to_core" # The task ID for upsert data to core layer.
UPDATE_HWM_TASK_ID: str = "update_high_watermark" # The task ID for update high_watermark table.
