
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        status as value_field,
        count(*) as n_records

    from "dbt"."staging"."stg_salesforce__case"
    group by status

)

select *
from all_values
where value_field not in (
    'New','In Progress','Escalated','Closed','On Hold'
)



  
  
      
    ) dbt_internal_test