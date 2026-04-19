
  
  create view "dbt"."staging"."stg_salesforce__pricebook_entry__dbt_tmp" as (
    with source as (

    select * from "dbt"."raw"."pricebook_entry"

),

renamed as (

    select
        id as pricebook_entry_id,
        pricebook2id,
        product2id,
        unitprice,
        isactive,
        usestandardprice,
        createddate,
        createdbyid,
        lastmodifieddate,
        lastmodifiedbyid,
        systemmodstamp,
        isdeleted,
        isarchived

    from source

)

select * from renamed
  );
