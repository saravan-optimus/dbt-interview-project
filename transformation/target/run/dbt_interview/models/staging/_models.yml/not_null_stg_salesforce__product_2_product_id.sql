
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select product_id
from "dbt"."staging"."stg_salesforce__product_2"
where product_id is null



  
  
      
    ) dbt_internal_test