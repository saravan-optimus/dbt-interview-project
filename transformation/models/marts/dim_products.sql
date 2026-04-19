{{
    config(materialized='table')
}}

with products as (

    select * from {{ ref('stg_salesforce__product_2') }}

),

final as (

    select
        {{ dbt_utils.generate_surrogate_key(['product_id']) }} as product_key,
        product_id,
        name                    as product_name,
        productcode             as product_code,
        description,
        family                  as product_family,
        isactive                as is_active,
        createddate             as created_date,
        lastmodifieddate        as last_modified_date,
        isdeleted               as is_deleted
    from products

)

select * from final
