
    
    

select
    solution_id as unique_field,
    count(*) as n_records

from "dbt"."staging"."stg_salesforce__solution"
where solution_id is not null
group by solution_id
having count(*) > 1


