

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

