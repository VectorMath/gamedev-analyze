
      -- back compat for old kwarg name
  
  
        
            
	    
	    
            
        
    

    

    merge into "gamedev"."core"."fact_event" as DBT_INTERNAL_DEST
        using "fact_event__dbt_tmp113256466716" as DBT_INTERNAL_SOURCE
        on ((DBT_INTERNAL_SOURCE.id = DBT_INTERNAL_DEST.id))

    
    when matched then update set
        "id" = DBT_INTERNAL_SOURCE."id","user_id" = DBT_INTERNAL_SOURCE."user_id","date" = DBT_INTERNAL_SOURCE."date","event_type" = DBT_INTERNAL_SOURCE."event_type","platform_id" = DBT_INTERNAL_SOURCE."platform_id","created_at" = DBT_INTERNAL_SOURCE."created_at","updated_at" = DBT_INTERNAL_SOURCE."updated_at"
    

    when not matched then insert
        ("id", "user_id", "date", "event_type", "platform_id", "created_at", "updated_at")
    values
        ("id", "user_id", "date", "event_type", "platform_id", "created_at", "updated_at")


  