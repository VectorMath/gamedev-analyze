
      -- back compat for old kwarg name
  
  
        
            
	    
	    
            
        
    

    

    merge into "gamedev"."core"."dim_currency" as DBT_INTERNAL_DEST
        using "dim_currency__dbt_tmp035347043314" as DBT_INTERNAL_SOURCE
        on ((DBT_INTERNAL_SOURCE.id = DBT_INTERNAL_DEST.id))

    
    when matched then update set
        "id" = DBT_INTERNAL_SOURCE."id","code_id" = DBT_INTERNAL_SOURCE."code_id","code" = DBT_INTERNAL_SOURCE."code","name" = DBT_INTERNAL_SOURCE."name","rate_to_usd" = DBT_INTERNAL_SOURCE."rate_to_usd","start_date" = DBT_INTERNAL_SOURCE."start_date","end_date" = DBT_INTERNAL_SOURCE."end_date","created_at" = DBT_INTERNAL_SOURCE."created_at","updated_at" = DBT_INTERNAL_SOURCE."updated_at"
    

    when not matched then insert
        ("id", "code_id", "code", "name", "rate_to_usd", "start_date", "end_date", "created_at", "updated_at")
    values
        ("id", "code_id", "code", "name", "rate_to_usd", "start_date", "end_date", "created_at", "updated_at")


  