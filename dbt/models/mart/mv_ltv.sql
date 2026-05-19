{{
    config(materialized='materialized_view')
}}
WITH cte_amount AS (
	SELECT
		tr.user_id,
		tr."date",
		tr.price_value * cr.rate_to_usd AS amount_usd
	FROM
	    {{ ref('fact_transaction') }} AS tr
	JOIN
	    {{ ref('dim_currency') }} AS cr
		    ON tr.currency_id = cr.code_id
		    AND tr."date" >= cr.start_date
		    AND tr."date" < cr.end_date
	WHERE
	    tr."date" >= CURRENT_DATE - INTERVAL '120 days'
)
SELECT
	us.id AS user_id,
	COALESCE(
		SUM(cte_amount.amount_usd)
		    FILTER (WHERE cte_amount."date" >= CURRENT_DATE - INTERVAL '90 days'),
		0
	) AS ltv_90d,
	COALESCE(
		SUM(cte_amount.amount_usd)
		    FILTER (WHERE cte_amount."date" >= CURRENT_DATE - INTERVAL '60 days'),
		0
	) AS ltv_60d,
	COALESCE(
		SUM(cte_amount.amount_usd)
		    FILTER (WHERE cte_amount."date" >= CURRENT_DATE - INTERVAL '30 days'),
		0
	) AS ltv_30d,
	COALESCE(
		SUM(cte_amount.amount_usd)
		    FILTER (WHERE cte_amount."date" >= CURRENT_DATE - INTERVAL '14 days'),
		0
	) AS ltv_14d
FROM
    {{ ref('dim_user') }} AS us
LEFT JOIN
	cte_amount
        ON us.id = cte_amount.user_id
GROUP BY
	us.id;