{{
    config(
        materialized='incremental',
        unique_key='opportunity_id',
        on_schema_change='sync_all_columns'
    )
}}

with opportunities as (

    select * from {{ ref('int_opportunities_enriched') }}

    {% if is_incremental() %}
        where lastmodifieddate > (select max(last_modified_date) from {{ this }})
    {% endif %}

),

opportunity_stages as (

    select * from {{ ref('opportunity_stages') }}

),

final as (

    select
        {{ dbt_utils.generate_surrogate_key(['opp.opportunity_id']) }} as opportunity_key,
        opp.opportunity_id,
        opp.account_id,
        opp.owner_id,
        opp.campaign_id,
        opp.contact_id,
        opp.opportunity_name,
        opp.opportunity_type,
        opp.stagename               as stage_name,
        opp.amount,
        opp.probability,
        opp.expectedrevenue         as expected_revenue,
        opp.closedate               as close_date,
        stg.is_closed,
        stg.is_won,
        stg.stage_sequence,
        opp.leadsource              as lead_source,
        opp.forecastcategory        as forecast_category,
        opp.forecastcategoryname    as forecast_category_name,
        opp.fiscalyear              as fiscal_year,
        opp.fiscalquarter           as fiscal_quarter,
        opp.opportunity_status,
        opp.deal_size_band,
        opp.probability_band,
        opp.days_to_close,
        opp.opportunity_age_days,
        opp.account_name,
        opp.account_industry,
        opp.account_country,
        opp.owner_full_name,
        opp.owner_department,
        opp.campaign_name,
        opp.campaign_type,
        opp.createddate             as created_date,
        opp.lastmodifieddate        as last_modified_date,
        opp.laststagechangedate     as last_stage_change_date,
        opp.isdeleted               as is_deleted
    from opportunities opp
    left join opportunity_stages stg
        on upper(trim(opp.stagename)) = upper(trim(stg.stage_name))

)

select * from final