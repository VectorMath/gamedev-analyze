{{
    config(
        materialized='incremental',
        unique_key='user_id',
        schema='mart',
        tags=['mart', 'retention'],
        on_schema_change='sync_all_columns',
        incremental_strategy='merge'
    )
}}

WITH user_registrations AS (
    SELECT
        id AS user_id,
        registration_date::date AS registration_date
    FROM {{ ref('dim_user') }}
    {% if is_incremental() %}
        WHERE registration_date >= CURRENT_DATE - INTERVAL '45 days'
    {% endif %}
),

user_activity AS (
    SELECT DISTINCT
        user_id,
        date::date AS activity_date
    FROM {{ ref('fact_event') }}
    WHERE 1=1
        {% if is_incremental() %}
            AND date >= CURRENT_DATE - INTERVAL '45 days'
        {% else %}
            AND date BETWEEN
                (SELECT MIN(registration_date) FROM {{ ref('dim_user') }})
                AND
                (SELECT MAX(registration_date) + INTERVAL '30 days' FROM {{ ref('dim_user') }})
        {% endif %}
)

SELECT
    r.user_id,
    r.registration_date,
    BOOL_OR(
        CASE
            WHEN a.activity_date = r.registration_date + INTERVAL '1 day'
                THEN TRUE
                ELSE FALSE
        END
    ) AS retention_d1,
    BOOL_OR(
        CASE
            WHEN a.activity_date = r.registration_date + INTERVAL '7 days'
                THEN TRUE
                ELSE FALSE
        END
    ) AS retention_d7,
    BOOL_OR(
        CASE
            WHEN a.activity_date = r.registration_date + INTERVAL '14 days'
                THEN TRUE
                ELSE FALSE
        END
    ) AS retention_d14,
    BOOL_OR(
        CASE
            WHEN a.activity_date = r.registration_date + INTERVAL '30 days'
                THEN TRUE
                ELSE FALSE
        END
    ) AS retention_d30,
    CURRENT_TIMESTAMP AS created_at,
    CURRENT_TIMESTAMP AS updated_at
FROM
    user_registrations AS r
LEFT JOIN
    user_activity AS a
        ON r.user_id = a.user_id
        AND a.activity_date BETWEEN
            r.registration_date
            AND
            r.registration_date + INTERVAL '30 days'
GROUP BY
    r.user_id,
    r.registration_date