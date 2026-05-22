
      -- back compat for old kwarg name
  
  
        
            
	    
	    
            
        
    

    

    merge into "gamedev"."mart"."user" as DBT_INTERNAL_DEST
        using "user__dbt_tmp100901176571" as DBT_INTERNAL_SOURCE
        on ((DBT_INTERNAL_SOURCE.id = DBT_INTERNAL_DEST.id))

    
    when matched then update set
        "id" = DBT_INTERNAL_SOURCE."id","user_name" = DBT_INTERNAL_SOURCE."user_name","region" = DBT_INTERNAL_SOURCE."region","country" = DBT_INTERNAL_SOURCE."country","gender" = DBT_INTERNAL_SOURCE."gender","birth_date" = DBT_INTERNAL_SOURCE."birth_date","years_old" = DBT_INTERNAL_SOURCE."years_old","age_group" = DBT_INTERNAL_SOURCE."age_group","registration_date" = DBT_INTERNAL_SOURCE."registration_date","months_in_game" = DBT_INTERNAL_SOURCE."months_in_game","created_at" = DBT_INTERNAL_SOURCE."created_at","updated_at" = DBT_INTERNAL_SOURCE."updated_at"
    

    when not matched then insert
        ("id", "user_name", "region", "country", "gender", "birth_date", "years_old", "age_group", "registration_date", "months_in_game", "created_at", "updated_at")
    values
        ("id", "user_name", "region", "country", "gender", "birth_date", "years_old", "age_group", "registration_date", "months_in_game", "created_at", "updated_at")


  