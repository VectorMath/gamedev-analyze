
      -- back compat for old kwarg name
  
  
        
            
	    
	    
            
        
    

    

    merge into "gamedev"."mart"."event" as DBT_INTERNAL_DEST
        using "event__dbt_tmp113308428691" as DBT_INTERNAL_SOURCE
        on ((DBT_INTERNAL_SOURCE.id = DBT_INTERNAL_DEST.id))

    
    when matched then update set
        "id" = DBT_INTERNAL_SOURCE."id","user_id" = DBT_INTERNAL_SOURCE."user_id","date" = DBT_INTERNAL_SOURCE."date","type" = DBT_INTERNAL_SOURCE."type","platform" = DBT_INTERNAL_SOURCE."platform","game_event_title" = DBT_INTERNAL_SOURCE."game_event_title","is_game_event_time" = DBT_INTERNAL_SOURCE."is_game_event_time","created_at" = DBT_INTERNAL_SOURCE."created_at","updated_at" = DBT_INTERNAL_SOURCE."updated_at"
    

    when not matched then insert
        ("id", "user_id", "date", "type", "platform", "game_event_title", "is_game_event_time", "created_at", "updated_at")
    values
        ("id", "user_id", "date", "type", "platform", "game_event_title", "is_game_event_time", "created_at", "updated_at")


  