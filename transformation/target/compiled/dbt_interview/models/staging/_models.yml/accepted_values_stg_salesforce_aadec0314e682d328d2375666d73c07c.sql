
    
    

with all_values as (

    select
        priority as value_field,
        count(*) as n_records

    from "dbt"."staging"."stg_salesforce__case"
    group by priority

)

select *
from all_values
where value_field not in (
    'Low','Medium','High','Urgent'
)


