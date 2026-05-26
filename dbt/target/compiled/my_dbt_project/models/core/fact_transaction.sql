
SELECT
    *
FROM
    "gamedev"."stage"."transactions"

    WHERE updated_at > (
        SELECT
            updated_at
        FROM
            "gamedev"."mart"."high_watermark"
        WHERE
            table_name = 'fact_transaction'
            and schema_name = 'core'
    )
