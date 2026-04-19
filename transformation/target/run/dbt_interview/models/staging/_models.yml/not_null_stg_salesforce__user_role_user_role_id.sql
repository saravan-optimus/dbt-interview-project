
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select user_role_id
from "dbt"."staging"."stg_salesforce__user_role"
where user_role_id is null



  
  
      
    ) dbt_internal_test