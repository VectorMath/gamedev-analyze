{{
    config(materialized='materialized_view')
}}
SELECT
    *
FROM
    {{ ref('transaction') }}
WHERE
    "date" >= CURRENT_DATE - INTERVAL '365 days';