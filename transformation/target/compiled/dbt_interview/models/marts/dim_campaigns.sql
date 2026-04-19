

with campaigns as (

    select * from "dbt"."staging"."stg_salesforce__campaign"

),

final as (

    select
        md5(cast(coalesce(cast(campaign_id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as campaign_key,
        campaign_id,
        ownerid                         as owner_id,
        parentid                        as parent_campaign_id,
        name                            as campaign_name,
        type                            as campaign_type,
        status                          as campaign_status,
        isactive                        as is_active,
        startdate                       as start_date,
        enddate                         as end_date,
        description,
        budgetedcost                    as budgeted_cost,
        actualcost                      as actual_cost,
        expectedrevenue                 as expected_revenue,
        expectedresponse                as expected_response_rate,
        numbersent                      as number_sent,
        numberofleads                   as number_of_leads,
        numberofconvertedleads          as number_of_converted_leads,
        numberofcontacts                as number_of_contacts,
        numberofresponses               as number_of_responses,
        numberofopportunities           as number_of_opportunities,
        numberofwonopportunities        as number_of_won_opportunities,
        amountallopportunities          as amount_all_opportunities,
        amountwonopportunities          as amount_won_opportunities,

        -- derived
        case
            when budgetedcost > 0
                then round(amountwonopportunities / budgetedcost, 2)
            else null
        end                             as campaign_roi,

        case
            when numberofleads > 0
                then round(numberofconvertedleads * 100.0 / numberofleads, 2)
            else null
        end                             as lead_conversion_rate,

        isdeleted                       as is_deleted,
        createddate                     as created_date,
        lastmodifieddate                as last_modified_date

    from campaigns

)

select * from final