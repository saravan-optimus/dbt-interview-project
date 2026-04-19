
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select account_id
from "dbt"."intermediate"."int_accounts_enriched"
where account_id is null



  
  
      
    ) dbt_internal_test