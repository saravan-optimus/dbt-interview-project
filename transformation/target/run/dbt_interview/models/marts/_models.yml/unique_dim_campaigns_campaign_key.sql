
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    campaign_key as unique_field,
    count(*) as n_records

from "dbt"."marts"."dim_campaigns"
where campaign_key is not null
group by campaign_key
having count(*) > 1



  
  
      
    ) dbt_internal_test