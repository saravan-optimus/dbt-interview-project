
  
  create view "dbt"."staging"."stg_salesforce__solution__dbt_tmp" as (
    with source as (

    select * from "dbt"."raw"."solution"

),

renamed as (

    select
        id as solution_id,
        isdeleted,
        solutionnumber,
        solutionname,
        ispublished,
        ispublishedinpublickb,
        status,
        isreviewed,
        solutionnote,
        caseid,
        ownerid,
        createddate,
        createdbyid,
        lastmodifieddate,
        lastmodifiedbyid,
        systemmodstamp,
        timesused,
        ishtml

    from source

)

select * from renamed
  );
