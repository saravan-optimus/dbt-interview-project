
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select case_id
from "dbt"."staging"."stg_salesforce__case"
where case_id is null



  
  
      
    ) dbt_internal_test