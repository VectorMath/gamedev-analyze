{{
    config(
    materialized='materialized_view',
    schema='mart',
    tags=['mv']
    )
}}
WITH transactions_range AS (
    SELECT
        user_id,
        MAX("date") AS last_transaction_date,
        CURRENT_DATE - MAX("date") AS days_since_last_transaction
    FROM
        {{ ref('fact_transaction') }}
    WHERE
        "date" >= CURRENT_DATE - INTERVAL '90 days'
    GROUP BY
        user_id
)
SELECT
    us.id,
    COALESCE(tr.days_since_last_transaction <= 60, FALSE) AS is_donated_for_last_60d,
    COALESCE(tr.days_since_last_transaction <= 30, FALSE) AS is_donated_for_last_30d,
    COALESCE(tr.days_since_last_transaction <= 14, FALSE) AS is_donated_for_last_14d,
    COALESCE(tr.days_since_last_transaction <= 7, FALSE)  AS is_donated_for_last_7d
FROM
	{{ ref('dim_user') }} AS us
LEFT JOIN
	transactions_range AS tr
    	ON us.id = tr.user_id