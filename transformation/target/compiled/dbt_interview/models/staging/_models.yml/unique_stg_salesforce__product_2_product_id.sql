
    
    

select
    product_id as unique_field,
    count(*) as n_records

from "dbt"."staging"."stg_salesforce__product_2"
where product_id is not null
group by product_id
having count(*) > 1


