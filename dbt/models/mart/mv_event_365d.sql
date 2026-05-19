{{
    config(materialized='materialized_view')
}}
SELECT
    *
FROM
    {{ ref('event') }}
WHERE
    "date" >= CURRENT_DATE - INTERVAL '365 days';