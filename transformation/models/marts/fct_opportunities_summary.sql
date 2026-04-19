{{
    config(
        materialized='table',
        tags=['marts', 'daily']
    )
}}

{% set metrics = ['amount', 'probability', 'days_to_close'] %}

with base as (
    select
        opportunity_id,
        account_id,
        owner_id,
        opportunity_status,
        deal_size_band,
        {% for metric in metrics %}
            {{ metric }}{% if not loop.last %},{% endif %}
        {% endfor %}
    from {{ ref('int_opportunities_enriched') }}
)

select * from base
