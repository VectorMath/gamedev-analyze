{{
    config(
        materialized='table',
        schema='core',
        tags=['core', 'event_type'],
    )
}}
SELECT
    *
FROM
    {{ source('raw_data', 'event_type') }}