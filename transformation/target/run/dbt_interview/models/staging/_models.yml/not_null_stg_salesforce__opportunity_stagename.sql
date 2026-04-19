
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select stagename
from "dbt"."staging"."stg_salesforce__opportunity"
where stagename is null



  
  
      
    ) dbt_internal_test