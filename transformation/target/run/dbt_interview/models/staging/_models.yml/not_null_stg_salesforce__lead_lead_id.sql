
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select lead_id
from "dbt"."staging"."stg_salesforce__lead"
where lead_id is null



  
  
      
    ) dbt_internal_test