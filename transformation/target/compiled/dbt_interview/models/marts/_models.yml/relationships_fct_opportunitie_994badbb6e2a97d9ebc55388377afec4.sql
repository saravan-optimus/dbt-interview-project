
    
    

with child as (
    select owner_id as from_field
    from "dbt"."marts"."fct_opportunities"
    where owner_id is not null
),

parent as (
    select user_id as to_field
    from "dbt"."marts"."dim_users"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


