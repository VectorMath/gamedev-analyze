{{
    config(
        materialized='incremental',
        unique_key='id',
        schema='core',
        tags=['core', 'event'],
        on_schema_change='sync_all_columns',
        incremental_strategy='merge'
    )
}}
SELECT
    *
FROM
    {{ source('raw_data', 'events') }}
{% if is_incremental() %}
    WHERE updated_at > (
        SELECT
            updated_at
        FROM
            {{ source('mart', 'high_watermark') }}
        WHERE
            table_name = 'fact_event'
            and schema_name = 'core'
    )
{% endif %}