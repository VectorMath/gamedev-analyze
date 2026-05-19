
  
    

  create  table "gamedev"."core"."dim_country__dbt_tmp"
  
  
    as
  
  (
    
SELECT
    *
FROM
    "gamedev"."stage"."country"
  );
  