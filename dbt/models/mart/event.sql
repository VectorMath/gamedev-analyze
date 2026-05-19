{{
    config(
        materialized='incremental',
        unique_key='id',
        schema='mart',
        tags=['mart', 'event'],
        on_schema_change='sync_all_columns',
        incremental_strategy='merge'
    )
}}
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
	{{ ref('fact_event') }} AS ev
JOIN
	{{ ref('dim_event_type') }} AS et
		ON ev.event_type = et.id
JOIN
	{{ ref('dim_platform') }} AS p
		ON ev.platform_id = p.id
LEFT JOIN
	{{ ref('dim_game_event') }} AS ge
		ON ev."date" >= ge.start_date
		AND ev."date" < ge.end_date

{% if is_incremental() %}
    WHERE ev.updated_at > (
        SELECT
            updated_at
        FROM
            {{ source('mart', 'high_watermark') }}
        WHERE
            table_name = 'event'
            and schema_name = 'mart'
    )
{% endif %}