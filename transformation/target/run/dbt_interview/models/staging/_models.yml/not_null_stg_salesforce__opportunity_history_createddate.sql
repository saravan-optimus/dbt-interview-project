
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select createddate
from "dbt"."staging"."stg_salesforce__opportunity_history"
where createddate is null



  
  
      
    ) dbt_internal_test