
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select opportunity_key
from "dbt"."marts"."fct_opportunities"
where opportunity_key is null



  
  
      
    ) dbt_internal_test