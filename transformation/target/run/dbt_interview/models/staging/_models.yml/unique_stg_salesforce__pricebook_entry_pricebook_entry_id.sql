
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    pricebook_entry_id as unique_field,
    count(*) as n_records

from "dbt"."staging"."stg_salesforce__pricebook_entry"
where pricebook_entry_id is not null
group by pricebook_entry_id
having count(*) > 1



  
  
      
    ) dbt_internal_test