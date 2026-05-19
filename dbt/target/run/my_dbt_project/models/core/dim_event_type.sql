
  
    

  create  table "gamedev"."core"."dim_event_type__dbt_tmp"
  
  
    as
  
  (
    
SELECT
    *
FROM
    "gamedev"."stage"."event_type"
  );
  