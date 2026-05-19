{{
    config(
        materialized='incremental',
        unique_key='id',
        schema='core',
        tags=['core', 'transaction'],
        on_schema_change='sync_all_columns',
        incremental_strategy='merge'
    )
}}
SELECT
    *
FROM
    {{ source('raw_data', 'transactions') }}
{% if is_incremental() %}
    WHERE updated_at > (
        SELECT
            updated_at
        FROM
            {{ source('mart', 'high_watermark') }}
        WHERE
            table_name = 'fact_transaction'
            and schema_name = 'core'
    )
{% endif %}