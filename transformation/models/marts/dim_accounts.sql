{{
    config(materialized='table')
}}

with source_accounts as (

    select * from {{ ref('int_accounts_enriched') }}

),

with_surrogate_keys as (

    select
        {{ dbt_utils.generate_surrogate_key(['account_id']) }} as account_key,
        account_id,
        owner_id,
        parent_account_id,
        account_name,
        account_type,
        industry,
        rating,
        annual_revenue,
        number_of_employees,
        ownership,
        billing_city,
        billing_state,
        billing_country,
        phone,
        website,
        account_source,
        customer_priority,
        sla_tier,
        is_active,
        number_of_locations,
        upsell_opportunity,
        company_size_band,
        revenue_band,
        is_subsidiary,
        owner_full_name,
        owner_email,
        owner_department,
        owner_is_active,
        created_date,
        last_modified_date,
        last_activity_date,
        is_deleted
    from source_accounts

)

select * from with_surrogate_keys
