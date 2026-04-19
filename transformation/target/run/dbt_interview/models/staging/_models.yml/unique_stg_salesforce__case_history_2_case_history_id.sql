
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    case_history_id as unique_field,
    count(*) as n_records

from "dbt"."staging"."stg_salesforce__case_history_2"
where case_history_id is not null
group by case_history_id
having count(*) > 1



  
  
      
    ) dbt_internal_test