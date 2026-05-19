{{
    config(
        materialized='table',
        schema='core',
        tags=['core', 'game_event'],
    )
}}
SELECT
    *
FROM
    {{ source('raw_data', 'game_event') }}