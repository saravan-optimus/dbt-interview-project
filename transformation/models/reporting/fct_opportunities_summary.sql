{{
    config(
        materialized='view',
        tags=['reporting', 'daily']
    )
}}

with opportunities as (

    select * from {{ ref('fct_opportunities') }}

),

final as (

    select
        owner_id,
        owner_full_name,
        fiscal_year,
        fiscal_quarter,
        count(*)                                            as total_opportunities,
        sum(amount)                                         as total_pipeline_value,
        sum(amount * probability / 100)                     as weighted_pipeline_value,
        avg(probability)                                    as avg_probability,
        count(case when is_won then 1 end)                  as won_count,
        sum(case when is_won then amount else 0 end)        as won_revenue,
        count(case when is_closed and not is_won then 1 end) as lost_count,
        count(case when not is_closed then 1 end)            as open_count
    from opportunities
    group by owner_id, owner_full_name, fiscal_year, fiscal_quarter

)

select * from final