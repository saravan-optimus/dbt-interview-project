
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select pricebook_entry_id
from "dbt"."staging"."stg_salesforce__pricebook_entry"
where pricebook_entry_id is null



  
  
      
    ) dbt_internal_test