
    
    

select
    account_id as unique_field,
    count(*) as n_records

from "dbt"."intermediate"."int_accounts_enriched"
where account_id is not null
group by account_id
having count(*) > 1


