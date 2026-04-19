
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select lead_key
from "dbt"."marts"."fct_leads"
where lead_key is null



  
  
      
    ) dbt_internal_test