{{
    config(
    materialized='materialized_view',
    schema='mart',
    tags=['mv']
    )
}}
SELECT
    *
FROM
    {{ ref('event') }}
WHERE
    "date" >= CURRENT_DATE - INTERVAL '365 days'