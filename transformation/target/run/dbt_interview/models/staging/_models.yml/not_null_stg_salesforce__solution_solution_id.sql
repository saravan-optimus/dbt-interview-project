
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select solution_id
from "dbt"."staging"."stg_salesforce__solution"
where solution_id is null



  
  
      
    ) dbt_internal_test