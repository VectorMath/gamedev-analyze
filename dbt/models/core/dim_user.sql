{{
    config(
        materialized='incremental',
        unique_key='id',
        schema='core',
        tags=['core', 'user'],
        on_schema_change='sync_all_columns',
        incremental_strategy='merge'
    )
}}

SELECT
	id,
	first_name,
	last_name,
	CASE
		WHEN gender IN ('Agender', 'Genderfluid', 'Non-binary', 'Bigender', 'Polygender', 'Genderqueer')
			THEN 'Other'
		ELSE
			gender
	END AS gender,
	registration_date,
	birthdate AS birth_date,
	email,
	country_id,
	created_at,
	updated_at
FROM
	{{ source('raw_data', 'users') }}

{% if is_incremental() %}
    WHERE updated_at > (
        SELECT
            updated_at
        FROM
            {{ source('mart', 'high_watermark') }}
        WHERE
            table_name = 'dim_user'
            and schema_name = 'core'
    )
{% endif %}