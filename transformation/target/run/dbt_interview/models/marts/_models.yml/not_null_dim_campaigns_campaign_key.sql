
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select campaign_key
from "dbt"."marts"."dim_campaigns"
where campaign_key is null



  
  
      
    ) dbt_internal_test