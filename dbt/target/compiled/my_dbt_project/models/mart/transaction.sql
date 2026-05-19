
SELECT
	tr.id,
	tr.user_id,
	tr."date",
	cr.code AS currency_code,
	cr."name" AS currency_name,
	tr.price_value AS price,
	tr.price_value * cr.rate_to_usd AS price_usd,
	pf."name" AS platform,
	ge."name" AS game_event_title,
	ge."name" IS NOT NULL AS is_game_event_time,
	tr.created_at,
	tr.updated_at
FROM
	"gamedev"."core"."fact_transaction" AS tr
JOIN
	"gamedev"."core"."dim_currency" AS cr
		ON tr.currency_id = cr.code_id
		AND tr."date" >= cr.start_date
		AND tr."date" < cr.end_date
JOIN
	"gamedev"."core"."dim_platform" AS pf
		ON tr.platform_id = pf.id
JOIN
	"gamedev"."core"."dim_user" AS us
		ON tr.user_id = us.id
LEFT JOIN
	"gamedev"."core"."dim_game_event" AS ge
		ON tr."date" >= ge.start_date
		AND tr."date" < ge.end_date

