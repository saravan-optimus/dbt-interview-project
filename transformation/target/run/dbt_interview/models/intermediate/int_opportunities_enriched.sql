
  
    
    

    create  table
      "dbt"."intermediate"."int_opportunities_enriched__dbt_tmp"
  
    as (
      with opportunities as (

    select * from "dbt"."staging"."stg_salesforce__opportunity"

),

accounts as (

    select
        account_id,
        name        as account_name,
        industry    as account_industry,
        rating      as account_rating,
        annualrevenue as account_annual_revenue,
        numberofemployees as account_employees,
        billingcountry as account_country,
        ownerid     as account_owner_id
    from "dbt"."staging"."stg_salesforce__account"

),

users as (

    select
        user_id,
        firstname   as owner_first_name,
        lastname    as owner_last_name,
        email       as owner_email,
        department  as owner_department,
        title       as owner_title,
        isactive    as owner_is_active,
        userroleid  as owner_role_id,
        managerid   as owner_manager_id
    from "dbt"."staging"."stg_salesforce__user"

),

campaigns as (

    select
        campaign_id,
        name        as campaign_name,
        type        as campaign_type,
        status      as campaign_status
    from "dbt"."staging"."stg_salesforce__campaign"

),

enriched_with_metrics as (

    select
        -- opportunity keys
        opp.opportunity_id,
        opp.accountid           as account_id,
        opp.ownerid             as owner_id,
        opp.campaignid          as campaign_id,
        opp.contactid           as contact_id,

        -- opportunity core fields
        opp.name                as opportunity_name,
        opp.type                as opportunity_type,
        opp.stagename,
        opp.amount,
        opp.probability,
        opp.expectedrevenue,
        opp.closedate,
        opp.isclosed,
        opp.iswon,
        opp.leadsource,
        opp.forecastcategory,
        opp.forecastcategoryname,
        opp.fiscalyear,
        opp.fiscalquarter,
        opp.createddate,
        opp.lastmodifieddate,
        opp.laststagechangedate,
        opp.isdeleted,

        -- account context
        acc.account_name,
        acc.account_industry,
        acc.account_rating,
        acc.account_annual_revenue,
        acc.account_employees,
        acc.account_country,

        -- owner context
        usr.owner_first_name,
        usr.owner_last_name,
        usr.owner_first_name || ' ' || usr.owner_last_name as owner_full_name,
        usr.owner_email,
        usr.owner_department,
        usr.owner_title,
        usr.owner_is_active,
        usr.owner_role_id,
        usr.owner_manager_id,

        -- campaign context
        cmp.campaign_name,
        cmp.campaign_type,
        cmp.campaign_status,

        -- derived fields
        datediff('day', opp.createddate, opp.closedate)     as days_to_close,
        datediff('day', opp.createddate, current_date)      as opportunity_age_days,

        case
            when opp.iswon = true                           then 'Won'
            when opp.isclosed = true and opp.iswon = false  then 'Lost'
            when opp.closedate < current_date               then 'Overdue'
            else 'Open'
        end                                                 as opportunity_status,

        case
            when opp.amount is null                         then 'Unknown'
            when opp.amount < 10000                         then 'Small'
            when opp.amount < 50000                         then 'Medium'
            when opp.amount < 200000                        then 'Large'
            else 'Enterprise'
        end                                                 as deal_size_band,

        case
            when opp.probability >= 80                      then 'High'
            when opp.probability >= 40                      then 'Medium'
            else 'Low'
        end                                                 as probability_band,

        -- derived metric using custom macro
        
    case 
        when probability = 0 or probability is null
        then null
        else amount / probability
    end
         as expected_value,

        -- window functions for ranking and trending
        row_number() over (partition by opp.ownerid, opp.fiscalyear order by opp.amount desc) as rep_opportunity_rank_by_fy,
        lag(opp.amount) over (partition by opp.accountid order by opp.createddate) as prior_opportunity_amount

    from opportunities opp
    left join accounts acc
        on opp.accountid = acc.account_id
    left join users usr
        on opp.ownerid = usr.user_id
    left join campaigns cmp
        on opp.campaignid = cmp.campaign_id

)

select * from enriched_with_metrics
    );
  
  