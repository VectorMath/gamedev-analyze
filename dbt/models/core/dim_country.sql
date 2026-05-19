{{
    config(
        materialized='table',
        tags=['core', 'country']
    )
}}
SELECT
    *
FROM
    {{ source('raw_data', 'country') }}