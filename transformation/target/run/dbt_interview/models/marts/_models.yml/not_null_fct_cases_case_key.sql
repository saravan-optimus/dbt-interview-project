
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select case_key
from "dbt"."marts"."fct_cases"
where case_key is null



  
  
      
    ) dbt_internal_test