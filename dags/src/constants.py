"""
The python file with constants for DAGs and common function
"""
CORE_LAYER_NAME: str = "core" # The schema name that belongs to core layer.
MART_LAYER_NAME: str = "mart" # The schema name that belongs to mart layer.

DB_CONNECTION_ID: str = "postgres_db" # The ID of postgres connection for Airflow.

DAG_CORE_ID: str = "core_layer_upsert_data" # The DAG ID for upsert data in core layer.
DAG_MART_ID: str = "mart_layer_upsert_data" # The DAG ID for upsert data in mart layer.

UPSERT_DATA_TASK_ID: str = "upsert_data" # The task ID for upsert data.
UPDATE_HWM_TASK_ID: str = "update_high_watermark" # The task ID for update high_watermark table.
TRIGGER_MART_DAG_TASK_ID: str = "trigger_mart_dag" # The task ID that triggers DAG for mart layer.

UPDATE_HWM_GROUP_ID: str = "update_hwm" # The group ID for tasks updating tables in HWM.