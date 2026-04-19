
  
    
    

    create  table
      "dbt"."marts"."fct_cases__dbt_tmp"
  
    as (
      

with cases as (

    select * from "dbt"."staging"."stg_salesforce__case"

),

accounts as (

    select
        account_id,
        name as account_name,
        industry as account_industry
    from "dbt"."staging"."stg_salesforce__account"

),

contacts as (

    select
        contact_id,
        firstname || ' ' || lastname as contact_full_name
    from "dbt"."staging"."stg_salesforce__contact"

),

users as (

    select
        user_id,
        firstname || ' ' || lastname as owner_full_name,
        department as owner_department
    from "dbt"."staging"."stg_salesforce__user"

),

final as (

    select
        md5(cast(coalesce(cast(c.case_id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as case_key,
        c.case_id,
        c.accountid                 as account_id,
        c.contactid                 as contact_id,
        c.ownerid                   as owner_id,
        c.casenumber                as case_number,
        c.type                      as case_type,
        c.status                    as case_status,
        c.priority                  as case_priority,
        c.reason                    as case_reason,
        c.origin                    as case_origin,
        c.subject,
        c.isclosed                  as is_closed,
        c.isescalated               as is_escalated,
        c.closeddate                as closed_date,
        c.createddate               as created_date,
        c.lastmodifieddate          as last_modified_date,
        c.isdeleted                 as is_deleted,
        c.slaviolation__c           as sla_violation,
        c.engineeringreqnumber__c   as engineering_req_number,

        -- join context
        a.account_name,
        a.account_industry,
        ct.contact_full_name,
        u.owner_full_name,
        u.owner_department,

        -- derived
        datediff('day', c.createddate, c.closeddate) as days_to_resolve,

        case
            when c.isclosed = true
                and datediff('day', c.createddate, c.closeddate) <= 1  then 'Same Day'
            when c.isclosed = true
                and datediff('day', c.createddate, c.closeddate) <= 7  then 'Within Week'
            when c.isclosed = true
                then 'Over A Week'
            else 'Open'
        end                         as resolution_band

    from cases c
    left join accounts a    on c.accountid  = a.account_id
    left join contacts ct   on c.contactid  = ct.contact_id
    left join users u       on c.ownerid    = u.user_id

)

select * from final
    );
  
  