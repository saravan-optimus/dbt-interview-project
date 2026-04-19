
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select contact_key
from "dbt"."marts"."dim_contacts"
where contact_key is null



  
  
      
    ) dbt_internal_test