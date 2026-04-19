
    
    

select
    lead_id as unique_field,
    count(*) as n_records

from "dbt"."staging"."stg_salesforce__lead"
where lead_id is not null
group by lead_id
having count(*) > 1


