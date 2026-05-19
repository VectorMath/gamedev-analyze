
SELECT
	ev.id,
	ev.user_id,
	ev."date",
	et."type",
	p."name" AS platform,
	ge."name" AS game_event_title,
	ge."name" IS NOT NULL AS is_game_event_time,
	ev.created_at,
	ev.updated_at
FROM
	"gamedev"."core"."fact_event" AS ev
JOIN
	"gamedev"."core"."dim_event_type" AS et
		ON ev.event_type = et.id
JOIN
	"gamedev"."core"."dim_platform" AS p
		ON ev.platform_id = p.id
LEFT JOIN
	"gamedev"."core"."dim_game_event" AS ge
		ON ev."date" >= ge.start_date
		AND ev."date" < ge.end_date

