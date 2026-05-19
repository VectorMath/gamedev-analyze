
SELECT
    *
FROM
    "gamedev"."stage"."events"

    WHERE updated_at > (
        SELECT
            updated_at
        FROM
            "gamedev"."mart"."high_watermark"
        WHERE
            table_name = 'fact_event'
            and schema_name = 'core'
    )
