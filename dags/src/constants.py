"""
The python file with constants for DAGs and common function
"""
CORE_LAYER_NAME: str = "core" # The schema name that belongs to core layer.
MART_LAYER_NAME: str = "mart" # The schema name that belongs to mart layer.

MATERIAL_VIEW_TAG: str = "mv" # The dbt models tag for materialized views.

DB_CONNECTION_ID: str = "postgres_db" # The ID of postgres connection for Airflow.

DAG_CORE_ID: str = "core_layer_upsert_data" # The DAG ID for upsert data in core layer.
DAG_MART_ID: str = "mart_layer_upsert_data" # The DAG ID for upsert data in mart layer.
DAG_MV_ID: str = "generate_mv" # The DAG ID for generation MVs.
DAG_MONTHLY_REPORT_ID: str = "monthly_european_transaction_report" # The DAG ID for regular monthly sending csv file with transactions.

UPSERT_DATA_TASK_ID: str = "upsert_data" # The task ID for upsert data.
UPDATE_HWM_TASK_ID: str = "update_high_watermark" # The task ID for update high_watermark table.
TRIGGER_MART_DAG_TASK_ID: str = "trigger_mart_dag" # The task ID that triggers DAG for mart layer.
TRIGGER_MV_DAG_TASK_ID: str = "trigger_mv_dag" # The task ID that triggers DAG for creating materialized views.
TRIGGER_MONTHLY_REPORT_DAG_TASK_ID: str = "trigger_monthly_report_dag"
GENERATE_MONTHLY_CSV_FILE: str = "generate_csv_file" #
SEND_CSV_TO_EMAIL: str = "send_csv_to_telegram" #

UPDATE_HWM_GROUP_ID: str = "update_hwm" # The group ID for tasks updating tables in HWM.

PATH_TO_MONTHLY_CSV_EURO_TRANSACTIONS: str = '/tmp/monthly_report.csv' # The path to csv-file that contains data for monthly report.

# ToDo: inject this in .env
TG_BOT_TOKEN: str = "8908731568:AAGXT1JtKhgt4ewku4uMR9jyTLSvQG5DskY"
CHAT_ID: list[str] = ["558130708"]