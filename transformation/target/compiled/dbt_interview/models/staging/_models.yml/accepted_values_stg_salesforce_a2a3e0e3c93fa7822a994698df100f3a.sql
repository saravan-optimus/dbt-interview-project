
    
    

with all_values as (

    select
        status as value_field,
        count(*) as n_records

    from "dbt"."staging"."stg_salesforce__case"
    group by status

)

select *
from all_values
where value_field not in (
    'New','In Progress','Escalated','Closed','On Hold'
)


