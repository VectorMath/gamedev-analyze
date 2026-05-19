{{
    config(materialized='materialized_view')
}}
WITH cte AS (
	SELECT
		user_id,
		MAX("date") AS last_date
	FROM
		{{ ref('fact_event') }}
	WHERE
	    "date" >= CURRENT_DATE - INTERVAL '31 days'
	GROUP BY
		user_id
)
SELECT
	us.id AS user_id,
	COALESCE(cte.last_date >= CURRENT_DATE - INTERVAL '1 day', FALSE) AS is_active_1d,
	COALESCE(cte.last_date >= CURRENT_DATE - INTERVAL '7 days', FALSE) AS is_active_7d,
	COALESCE(cte.last_date >= CURRENT_DATE - INTERVAL '14 days', FALSE) AS is_active_14d,
	COALESCE(cte.last_date >= CURRENT_DATE - INTERVAL '30 days', FALSE) AS is_active_30d
FROM
	{{ ref('dim_user') }} AS us
LEFT JOIN cte
	ON us.id = cte.user_id;