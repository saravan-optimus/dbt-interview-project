
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select account_key
from "dbt"."marts"."dim_accounts"
where account_key is null



  
  
      
    ) dbt_internal_test