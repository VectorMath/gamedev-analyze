
  
    

  create  table "gamedev"."core"."dim_game_event__dbt_tmp"
  
  
    as
  
  (
    
SELECT
    *
FROM
    "gamedev"."stage"."game_event"
  );
  