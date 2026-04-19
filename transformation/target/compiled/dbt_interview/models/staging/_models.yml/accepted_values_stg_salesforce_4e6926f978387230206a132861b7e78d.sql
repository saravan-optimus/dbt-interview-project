
    
    

with all_values as (

    select
        status as value_field,
        count(*) as n_records

    from "dbt"."staging"."stg_salesforce__campaign"
    group by status

)

select *
from all_values
where value_field not in (
    'Planned','In Progress','Completed','Aborted'
)


