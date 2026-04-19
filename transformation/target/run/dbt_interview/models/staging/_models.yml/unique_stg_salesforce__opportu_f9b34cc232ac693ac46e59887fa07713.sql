
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    opportunity_history_id as unique_field,
    count(*) as n_records

from "dbt"."staging"."stg_salesforce__opportunity_history"
where opportunity_history_id is not null
group by opportunity_history_id
having count(*) > 1



  
  
      
    ) dbt_internal_test