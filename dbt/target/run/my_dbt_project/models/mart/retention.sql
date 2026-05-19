
      
  
    

  create  table "gamedev"."mart"."retention"
  
  
    as
  
  (
    

WITH user_registrations AS (
    SELECT
        id AS user_id,
        registration_date::date AS registration_date
    FROM "gamedev"."core"."dim_user"
    
),

user_activity AS (
    SELECT DISTINCT
        user_id,
        date::date AS activity_date
    FROM "gamedev"."core"."fact_event"
    WHERE 1=1
        
            AND date BETWEEN
                (SELECT MIN(registration_date) FROM "gamedev"."core"."dim_user")
                AND
                (SELECT MAX(registration_date) + INTERVAL '30 days' FROM "gamedev"."core"."dim_user")
        
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
  );
  
  