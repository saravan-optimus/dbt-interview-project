
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select caseid
from "dbt"."staging"."stg_salesforce__case_history_2"
where caseid is null



  
  
      
    ) dbt_internal_test