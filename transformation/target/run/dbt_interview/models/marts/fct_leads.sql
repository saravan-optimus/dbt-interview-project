
  
    
    

    create  table
      "dbt"."marts"."fct_leads__dbt_tmp"
  
    as (
      

with leads as (

    select * from "dbt"."intermediate"."int_leads_converted"

),

final as (

    select
        md5(cast(coalesce(cast(lead_id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as lead_key,
        lead_id,
        owner_id,
        converted_account_id,
        converted_contact_id,
        converted_opportunity_id,
        full_name,
        company,
        title,
        industry,
        lead_source,
        lead_status,
        rating,
        annual_revenue,
        number_of_employees,
        country,
        company_size_band,
        is_converted,
        converted_date,
        converted_with_opportunity,
        lead_outcome,
        days_to_convert,
        owner_full_name,
        owner_department,
        owner_is_active,
        created_date,
        last_modified_date,
        last_activity_date,
        is_deleted
    from leads

)

select * from final
    );
  
  