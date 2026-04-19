{{
    config(materialized='table')
}}

with contacts as (

    select * from {{ ref('stg_salesforce__contact') }}

),

accounts as (

    select
        account_id,
        name as account_name,
        industry as account_industry
    from {{ ref('stg_salesforce__account') }}

),

final as (

    select
        {{ dbt_utils.generate_surrogate_key(['c.contact_id']) }} as contact_key,
        c.contact_id,
        c.accountid             as account_id,
        c.ownerid               as owner_id,
        c.reportstoid           as reports_to_id,
        c.salutation,
        c.firstname             as first_name,
        c.lastname              as last_name,
        c.firstname || ' ' || c.lastname as full_name,
        c.title,
        c.department,
        c.email,
        c.phone,
        c.mobilephone           as mobile_phone,
        c.mailingcity           as mailing_city,
        c.mailingstate          as mailing_state,
        c.mailingcountry        as mailing_country,
        c.leadsource            as lead_source,
        c.birthdate,
        c.hasoptedoutofemail    as has_opted_out_of_email,
        c.donotcall             as do_not_call,
        c.level__c              as level,
        c.languages__c          as languages,
        c.pronouns,
        c.genderidentity        as gender_identity,
        c.createddate           as created_date,
        c.lastmodifieddate      as last_modified_date,
        c.lastactivitydate      as last_activity_date,
        c.isdeleted             as is_deleted,
        a.account_name,
        a.account_industry
    from contacts c
    left join accounts a
        on c.accountid = a.account_id

)

select * from final
