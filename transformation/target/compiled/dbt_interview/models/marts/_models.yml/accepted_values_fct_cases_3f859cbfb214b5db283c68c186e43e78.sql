
    
    

with all_values as (

    select
        case_status as value_field,
        count(*) as n_records

    from "dbt"."marts"."fct_cases"
    group by case_status

)

select *
from all_values
where value_field not in (
    'New','In Progress','Escalated','Closed'
)


