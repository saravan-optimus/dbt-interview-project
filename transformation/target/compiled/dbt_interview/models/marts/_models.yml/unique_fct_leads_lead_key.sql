
    
    

select
    lead_key as unique_field,
    count(*) as n_records

from "dbt"."marts"."fct_leads"
where lead_key is not null
group by lead_key
having count(*) > 1


