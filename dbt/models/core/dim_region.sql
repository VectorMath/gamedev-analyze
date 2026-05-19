{{
    config(
        materialized='table',
        schema='core',
        tags=['core', 'region'],
    )
}}
SELECT
    *
FROM
    {{ source('raw_data', 'region') }}