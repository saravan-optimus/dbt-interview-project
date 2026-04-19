
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select lastname
from "dbt"."staging"."stg_salesforce__contact"
where lastname is null



  
  
      
    ) dbt_internal_test