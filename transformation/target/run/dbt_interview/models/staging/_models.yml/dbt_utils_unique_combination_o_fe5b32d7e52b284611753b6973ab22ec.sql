
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  





with validation_errors as (

    select
        caseid, lastmodifieddate
    from "dbt"."staging"."stg_salesforce__case_history_2"
    group by caseid, lastmodifieddate
    having count(*) > 1

)

select *
from validation_errors



  
  
      
    ) dbt_internal_test