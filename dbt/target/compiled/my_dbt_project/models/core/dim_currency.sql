
SELECT
    *
FROM
    "gamedev"."stage"."currency"


    WHERE updated_at > (
        SELECT
            updated_at
        FROM
            "gamedev"."mart"."high_watermark"
        WHERE
            table_name = 'dim_currency'
            and schema_name = 'core'
    )
