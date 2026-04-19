
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select record_type_id
from "dbt"."staging"."stg_salesforce__record_type"
where record_type_id is null



  
  
      
    ) dbt_internal_test