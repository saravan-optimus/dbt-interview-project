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