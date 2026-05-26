

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
	"gamedev"."stage"."users"


    WHERE updated_at > (
        SELECT
            updated_at
        FROM
            "gamedev"."mart"."high_watermark"
        WHERE
            table_name = 'dim_user'
            and schema_name = 'core'
    )
