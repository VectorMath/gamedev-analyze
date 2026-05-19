{{
    config(materialized='materialized_view')
}}
WITH cte AS (
    SELECT
        *
    FROM
        {{ ref('fact_event') }}
    WHERE
        "date" >= CURRENT_DATE - INTERVAL '90 days'
)
SELECT
	us.id AS user_id,
	det."type",
	COUNT(*) FILTER (WHERE cte."date" >= CURRENT_DATE - INTERVAL '30 days') AS cnt_actions_30d,
	COUNT(*) FILTER (WHERE cte."date" >= CURRENT_DATE - INTERVAL '14 days') AS cnt_actions_14d,
	COUNT(*) FILTER (WHERE cte."date" >= CURRENT_DATE - INTERVAL '7 days') AS cnt_actions_7d
FROM
	{{ ref('dim_user') }} AS us
LEFT JOIN cte
	ON us.id = cte.user_id
JOIN
	{{ ref('dim_event_type') }} AS det
		ON cte.event_type = det.id
GROUP BY
	1, 2