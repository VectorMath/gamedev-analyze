
      -- back compat for old kwarg name
  
  
        
            
	    
	    
            
        
    

    

    merge into "gamedev"."core"."dim_user" as DBT_INTERNAL_DEST
        using "dim_user__dbt_tmp035347472401" as DBT_INTERNAL_SOURCE
        on ((DBT_INTERNAL_SOURCE.id = DBT_INTERNAL_DEST.id))

    
    when matched then update set
        "id" = DBT_INTERNAL_SOURCE."id","first_name" = DBT_INTERNAL_SOURCE."first_name","last_name" = DBT_INTERNAL_SOURCE."last_name","gender" = DBT_INTERNAL_SOURCE."gender","registration_date" = DBT_INTERNAL_SOURCE."registration_date","birth_date" = DBT_INTERNAL_SOURCE."birth_date","email" = DBT_INTERNAL_SOURCE."email","country_id" = DBT_INTERNAL_SOURCE."country_id","created_at" = DBT_INTERNAL_SOURCE."created_at","updated_at" = DBT_INTERNAL_SOURCE."updated_at"
    

    when not matched then insert
        ("id", "first_name", "last_name", "gender", "registration_date", "birth_date", "email", "country_id", "created_at", "updated_at")
    values
        ("id", "first_name", "last_name", "gender", "registration_date", "birth_date", "email", "country_id", "created_at", "updated_at")


  