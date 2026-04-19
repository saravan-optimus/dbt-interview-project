
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select name
from "dbt"."staging"."stg_salesforce__campaign"
where name is null



  
  
      
    ) dbt_internal_test