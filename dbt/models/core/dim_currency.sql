{{
    config(
        materialized='incremental',
        unique_key='id',
        schema='core',
        tags=['core', 'currency'],
        on_schema_change='sync_all_columns',
        incremental_strategy='merge'
    )
}}
SELECT
    *
FROM
    {{ source('raw_data', 'currency') }}

{% if is_incremental() %}
    WHERE updated_at > (
        SELECT
            updated_at
        FROM
            {{ source('mart', 'high_watermark') }}
        WHERE
            table_name = 'dim_currency'
            and schema_name = 'core'
    )
{% endif %}