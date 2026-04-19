
    
    

select
    contact_key as unique_field,
    count(*) as n_records

from "dbt"."marts"."dim_contacts"
where contact_key is not null
group by contact_key
having count(*) > 1


