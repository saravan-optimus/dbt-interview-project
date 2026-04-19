
  
    
    

    create  table
      "dbt"."marts"."dim_products__dbt_tmp"
  
    as (
      

with products as (

    select * from "dbt"."staging"."stg_salesforce__product_2"

),

final as (

    select
        md5(cast(coalesce(cast(product_id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as product_key,
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
    );
  
  