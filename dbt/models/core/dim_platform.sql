{{
    config(
        materialized='table',
        schema='core',
        tags=['core', 'platform'],
    )
}}
SELECT
    *
FROM
    {{ source('raw_data', 'platform') }}