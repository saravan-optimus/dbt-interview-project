
    
    

select
    record_type_id as unique_field,
    count(*) as n_records

from "dbt"."staging"."stg_salesforce__record_type"
where record_type_id is not null
group by record_type_id
having count(*) > 1


