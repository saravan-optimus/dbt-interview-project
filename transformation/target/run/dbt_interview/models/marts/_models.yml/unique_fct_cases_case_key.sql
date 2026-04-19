
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    case_key as unique_field,
    count(*) as n_records

from "dbt"."marts"."fct_cases"
where case_key is not null
group by case_key
having count(*) > 1



  
  
      
    ) dbt_internal_test