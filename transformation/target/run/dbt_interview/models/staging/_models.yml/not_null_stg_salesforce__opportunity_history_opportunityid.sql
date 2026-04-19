
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select opportunityid
from "dbt"."staging"."stg_salesforce__opportunity_history"
where opportunityid is null



  
  
      
    ) dbt_internal_test