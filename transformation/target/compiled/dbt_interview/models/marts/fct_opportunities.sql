

with opportunities as (

    select * from "dbt"."intermediate"."int_opportunities_enriched"

    
        where lastmodifieddate > (select max(last_modified_date) from "dbt"."marts"."fct_opportunities")
    

),

final as (

    select
        md5(cast(coalesce(cast(opportunity_id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as opportunity_key,
        opportunity_id,
        account_id,
        owner_id,
        campaign_id,
        contact_id,
        opportunity_name,
        opportunity_type,
        stagename               as stage_name,
        amount,
        probability,
        expectedrevenue         as expected_revenue,
        closedate               as close_date,
        isclosed                as is_closed,
        iswon                   as is_won,
        leadsource              as lead_source,
        forecastcategory        as forecast_category,
        forecastcategoryname    as forecast_category_name,
        fiscalyear              as fiscal_year,
        fiscalquarter           as fiscal_quarter,
        opportunity_status,
        deal_size_band,
        probability_band,
        days_to_close,
        opportunity_age_days,
        account_name,
        account_industry,
        account_country,
        owner_full_name,
        owner_department,
        campaign_name,
        campaign_type,
        createddate             as created_date,
        lastmodifieddate        as last_modified_date,
        laststagechangedate     as last_stage_change_date,
        isdeleted               as is_deleted
    from opportunities

)

select * from final