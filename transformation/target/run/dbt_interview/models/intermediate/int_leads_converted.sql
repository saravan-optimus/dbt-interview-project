
  
    
    

    create  table
      "dbt"."intermediate"."int_leads_converted__dbt_tmp"
  
    as (
      with leads as (

    select * from "dbt"."staging"."stg_salesforce__lead"

),

users as (

    select
        user_id,
        firstname   as owner_first_name,
        lastname    as owner_last_name,
        email       as owner_email,
        department  as owner_department,
        isactive    as owner_is_active
    from "dbt"."staging"."stg_salesforce__user"

),

enriched as (

    select
        -- keys
        ld.lead_id,
        ld.ownerid                  as owner_id,
        ld.convertedaccountid       as converted_account_id,
        ld.convertedcontactid       as converted_contact_id,
        ld.convertedopportunityid   as converted_opportunity_id,

        -- lead core fields
        ld.firstname                as first_name,
        ld.lastname                 as last_name,
        ld.firstname || ' ' || ld.lastname as full_name,
        ld.company,
        ld.title,
        ld.email,
        ld.phone,
        ld.industry,
        ld.rating,
        ld.leadsource               as lead_source,
        ld.status                   as lead_status,
        ld.annualrevenue            as annual_revenue,
        ld.numberofemployees        as number_of_employees,
        ld.country,
        ld.isconverted              as is_converted,
        ld.converteddate            as converted_date,
        ld.createddate              as created_date,
        ld.lastmodifieddate         as last_modified_date,
        ld.lastactivitydate         as last_activity_date,
        ld.isdeleted                as is_deleted,

        -- owner context
        usr.owner_first_name,
        usr.owner_last_name,
        usr.owner_first_name || ' ' || usr.owner_last_name as owner_full_name,
        usr.owner_email,
        usr.owner_department,
        usr.owner_is_active,

        -- derived fields
        datediff('day', ld.createddate, ld.converteddate::timestamp) as days_to_convert,

        case
            when ld.isconverted = true  then 'Converted'
            when ld.isdeleted = true    then 'Deleted'
            when ld.status = 'Closed - Not Converted' then 'Lost'
            else 'Open'
        end                         as lead_outcome,

        case
            when ld.numberofemployees is null   then 'Unknown'
            when ld.numberofemployees < 50      then 'SMB'
            when ld.numberofemployees < 500     then 'Mid-Market'
            else                                     'Enterprise'
        end                         as company_size_band,

        case
            when ld.isconverted = true
                and ld.convertedopportunityid != '000000000000000AAA'
                then true
            else false
        end                         as converted_with_opportunity

    from leads ld
    left join users usr
        on ld.ownerid = usr.user_id

)

select * from enriched
    );
  
  