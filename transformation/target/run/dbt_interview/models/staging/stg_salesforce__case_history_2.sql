
  
  create view "dbt"."staging"."stg_salesforce__case_history_2__dbt_tmp" as (
    with source as (

    select * from "dbt"."raw"."case_history_2"

),

renamed as (

    select
        id as case_history_id,
        caseid,
        ownerid,
        status,
        previousupdate,
        lastmodifieddate,
        lastmodifiedbyid,
        isdeleted,
        systemmodstamp

    from source

)

select * from renamed
  );
