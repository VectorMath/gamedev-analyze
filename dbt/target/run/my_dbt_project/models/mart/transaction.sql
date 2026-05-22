
      -- back compat for old kwarg name
  
  
        
            
	    
	    
            
        
    

    

    merge into "gamedev"."mart"."transaction" as DBT_INTERNAL_DEST
        using "transaction__dbt_tmp100901129718" as DBT_INTERNAL_SOURCE
        on ((DBT_INTERNAL_SOURCE.id = DBT_INTERNAL_DEST.id))

    
    when matched then update set
        "id" = DBT_INTERNAL_SOURCE."id","user_id" = DBT_INTERNAL_SOURCE."user_id","date" = DBT_INTERNAL_SOURCE."date","currency_code" = DBT_INTERNAL_SOURCE."currency_code","currency_name" = DBT_INTERNAL_SOURCE."currency_name","price" = DBT_INTERNAL_SOURCE."price","price_usd" = DBT_INTERNAL_SOURCE."price_usd","platform" = DBT_INTERNAL_SOURCE."platform","game_event_title" = DBT_INTERNAL_SOURCE."game_event_title","is_game_event_time" = DBT_INTERNAL_SOURCE."is_game_event_time","created_at" = DBT_INTERNAL_SOURCE."created_at","updated_at" = DBT_INTERNAL_SOURCE."updated_at"
    

    when not matched then insert
        ("id", "user_id", "date", "currency_code", "currency_name", "price", "price_usd", "platform", "game_event_title", "is_game_event_time", "created_at", "updated_at")
    values
        ("id", "user_id", "date", "currency_code", "currency_name", "price", "price_usd", "platform", "game_event_title", "is_game_event_time", "created_at", "updated_at")


  