with accounts as (

    select * from "dbt"."staging"."stg_salesforce__account"

),

users as (

    select
        user_id,
        firstname   as owner_first_name,
        lastname    as owner_last_name,
        email       as owner_email,
        department  as owner_department,
        isactive    as owner_is_active,
        userroleid  as owner_role_id
    from "dbt"."staging"."stg_salesforce__user"

),

enriched as (

    select
        -- keys
        acc.account_id,
        acc.ownerid             as owner_id,
        acc.parentid            as parent_account_id,

        -- account core fields
        acc.name                as account_name,
        acc.type                as account_type,
        acc.industry,
        acc.rating,
        acc.annualrevenue       as annual_revenue,
        acc.numberofemployees   as number_of_employees,
        acc.ownership,
        acc.billingcity         as billing_city,
        acc.billingstate        as billing_state,
        acc.billingcountry      as billing_country,
        acc.phone,
        acc.website,
        acc.accountsource       as account_source,
        acc.createddate         as created_date,
        acc.lastmodifieddate    as last_modified_date,
        acc.lastactivitydate    as last_activity_date,
        acc.isdeleted           as is_deleted,

        -- custom fields
        acc.customerpriority__c as customer_priority,
        acc.sla__c              as sla_tier,
        acc.active__c           as is_active,
        acc.numberoflocations__c as number_of_locations,
        acc.upsellopportunity__c as upsell_opportunity,

        -- owner context
        usr.owner_first_name,
        usr.owner_last_name,
        usr.owner_first_name || ' ' || usr.owner_last_name as owner_full_name,
        usr.owner_email,
        usr.owner_department,
        usr.owner_is_active,

        -- derived fields
        case
            when acc.numberofemployees is null      then 'Unknown'
            when acc.numberofemployees < 50         then 'SMB'
            when acc.numberofemployees < 500        then 'Mid-Market'
            else                                         'Enterprise'
        end                                         as company_size_band,

        case
            when acc.annualrevenue is null          then 'Unknown'
            when acc.annualrevenue < 1000000        then 'Under $1M'
            when acc.annualrevenue < 10000000       then '$1M - $10M'
            when acc.annualrevenue < 100000000      then '$10M - $100M'
            else                                         'Over $100M'
        end                                         as revenue_band,

        case
            when acc.parentid is not null           then true
            else                                         false
        end                                         as is_subsidiary

    from accounts acc
    left join users usr
        on acc.ownerid = usr.user_id

)

select * from enriched