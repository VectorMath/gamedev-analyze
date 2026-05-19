
  create view "gamedev"."public"."test_check__dbt_tmp"
    
    
  as (
    select *
from core.fact_transaction
  );