
    
    

select
    lead_id as unique_field,
    count(*) as n_records

from "dbt"."intermediate"."int_leads_converted"
where lead_id is not null
group by lead_id
having count(*) > 1


