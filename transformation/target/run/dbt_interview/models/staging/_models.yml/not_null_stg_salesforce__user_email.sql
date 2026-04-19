
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select email
from "dbt"."staging"."stg_salesforce__user"
where email is null



  
  
      
    ) dbt_internal_test