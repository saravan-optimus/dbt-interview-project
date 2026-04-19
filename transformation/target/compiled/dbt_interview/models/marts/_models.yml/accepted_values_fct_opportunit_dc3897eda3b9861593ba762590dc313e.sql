
    
    

with all_values as (

    select
        stage_name as value_field,
        count(*) as n_records

    from "dbt"."marts"."fct_opportunities"
    group by stage_name

)

select *
from all_values
where value_field not in (
    'Prospecting','Qualification','Needs Analysis','Value Proposition','Id. Decision Makers','Perception Analysis','Proposal/Price Quote','Negotiation/Review','Closed Won','Closed Lost'
)


