
      -- back compat for old kwarg name
  
  
        
            
	    
	    
            
        
    

    

    merge into "gamedev"."mart"."retention" as DBT_INTERNAL_DEST
        using "retention__dbt_tmp100901123448" as DBT_INTERNAL_SOURCE
        on ((DBT_INTERNAL_SOURCE.user_id = DBT_INTERNAL_DEST.user_id))

    
    when matched then update set
        "user_id" = DBT_INTERNAL_SOURCE."user_id","registration_date" = DBT_INTERNAL_SOURCE."registration_date","retention_d1" = DBT_INTERNAL_SOURCE."retention_d1","retention_d7" = DBT_INTERNAL_SOURCE."retention_d7","retention_d14" = DBT_INTERNAL_SOURCE."retention_d14","retention_d30" = DBT_INTERNAL_SOURCE."retention_d30","created_at" = DBT_INTERNAL_SOURCE."created_at","updated_at" = DBT_INTERNAL_SOURCE."updated_at"
    

    when not matched then insert
        ("user_id", "registration_date", "retention_d1", "retention_d7", "retention_d14", "retention_d30", "created_at", "updated_at")
    values
        ("user_id", "registration_date", "retention_d1", "retention_d7", "retention_d14", "retention_d30", "created_at", "updated_at")


  