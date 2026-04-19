
    
    

with child as (
    select contact_id as from_field
    from "dbt"."marts"."fct_cases"
    where contact_id is not null
),

parent as (
    select contact_id as to_field
    from "dbt"."marts"."dim_contacts"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


