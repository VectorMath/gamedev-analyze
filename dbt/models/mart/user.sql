{{
    config(
        materialized='incremental',
        unique_key='id',
        schema='mart',
        tags=['mart', 'user'],
        on_schema_change='sync_all_columns',
        incremental_strategy='merge'
    )
}}
WITH user_feature AS (
	SELECT
		*,
		DATE_PART(
		'year',
		AGE(CURRENT_DATE, birth_date)
	) AS years_old,
	(
		DATE_PART('year', AGE(CURRENT_DATE, registration_date)) * 12
		+
		DATE_PART('month', AGE(CURRENT_DATE, registration_date))
	)::INT AS months_in_game
	FROM
		{{ ref('dim_user') }}
)
SELECT
	us.id,
	CONCAT(us.first_name, ' ', us.last_name) AS user_name,
	re."name" AS region,
	cntr."name" AS country,
	us.gender,
	us.birth_date,
	us.years_old,
	CASE
		WHEN us.years_old < 14
			THEN 'Kid'
		WHEN us.years_old BETWEEN 14 AND 20
			THEN 'Teenager'
		WHEN us.years_old BETWEEN 21 AND 29
			THEN 'Young'
		WHEN us.years_old BETWEEN 30 AND 50
			THEN 'Adult'
		ELSE
			'Pensioner'
	END AS age_group,
	us.registration_date,
	us.months_in_game,
	us.created_at,
	us.updated_at
FROM
	user_feature AS us
LEFT JOIN
	{{ ref('dim_country') }} AS cntr
		ON us.country_id = cntr.id
LEFT JOIN
	{{ ref('dim_region') }} AS re
		ON cntr.region_id = re.id

{% if is_incremental() %}
    WHERE us.updated_at > (
        SELECT
            updated_at
        FROM
            {{ source('mart', 'high_watermark') }}
        WHERE
            table_name = 'user'
            and schema_name = 'mart'
    )
{% endif %}