
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select line_item_key
from "dbt"."marts"."fct_opportunity_line_items"
where line_item_key is null



  
  
      
    ) dbt_internal_test