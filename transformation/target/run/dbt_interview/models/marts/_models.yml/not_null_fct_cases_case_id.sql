
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select case_id
from "dbt"."marts"."fct_cases"
where case_id is null



  
  
      
    ) dbt_internal_test