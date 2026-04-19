
  
  create view "dbt"."staging"."stg_salesforce__product_2__dbt_tmp" as (
    with source as (

    select * from "dbt"."raw"."product_2"

),

renamed as (

    select
        id as product_id,
        name,
        productcode,
        description,
        isactive,
        createddate,
        createdbyid,
        lastmodifieddate,
        lastmodifiedbyid,
        systemmodstamp,
        family,
        externaldatasourceid,
        externalid,
        displayurl,
        quantityunitofmeasure,
        isdeleted,
        isarchived,
        stockkeepingunit,
        type,
        productclass,
        sourceproductid,
        sellerid

    from source

)

select * from renamed
  );
