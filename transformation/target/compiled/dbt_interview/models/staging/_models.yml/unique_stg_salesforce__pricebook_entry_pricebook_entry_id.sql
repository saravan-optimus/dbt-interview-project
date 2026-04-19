
    
    

select
    pricebook_entry_id as unique_field,
    count(*) as n_records

from "dbt"."staging"."stg_salesforce__pricebook_entry"
where pricebook_entry_id is not null
group by pricebook_entry_id
having count(*) > 1


