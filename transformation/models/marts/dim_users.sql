{{
    config(materialized='table')
}}

with users as (

    select * from {{ ref('stg_salesforce__user') }}

),

roles as (

    select * from {{ ref('stg_salesforce__user_role') }}

),

final as (

    select
        {{ dbt_utils.generate_surrogate_key(['u.user_id']) }} as user_key,
        u.user_id,
        u.userroleid            as user_role_id,
        u.managerid             as manager_id,
        u.firstname             as first_name,
        u.lastname              as last_name,
        u.firstname || ' ' || u.lastname as full_name,
        u.email,
        u.title,
        u.department,
        u.division,
        u.companyname           as company_name,
        u.alias,
        u.isactive              as is_active,
        u.usertype              as user_type,
        u.usersubtype           as user_sub_type,
        u.profileid             as profile_id,
        u.forecastenabled       as forecast_enabled,
        u.employeenumber        as employee_number,
        u.lastlogindate         as last_login_date,
        u.createddate           as created_date,
        u.lastmodifieddate      as last_modified_date,
        r.name                  as role_name,
        r.parentroleid          as parent_role_id
    from users u
    left join roles r
        on u.userroleid = r.user_role_id

)

select * from final
