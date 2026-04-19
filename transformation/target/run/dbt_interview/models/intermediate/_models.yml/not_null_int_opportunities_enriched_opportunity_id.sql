
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select opportunity_id
from "dbt"."intermediate"."int_opportunities_enriched"
where opportunity_id is null



  
  
      
    ) dbt_internal_test