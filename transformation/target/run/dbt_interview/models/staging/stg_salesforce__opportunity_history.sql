
  
  create view "dbt"."staging"."stg_salesforce__opportunity_history__dbt_tmp" as (
    with source as (

    select * from "dbt"."raw"."opportunity_history"

),

renamed as (

    select
        id opportunity_history_id,
        opportunityid,
        createdbyid,
        createddate,
        createddateforinsert,
        stagename,
        amount,
        expectedrevenue,
        closedate,
        probability,
        fromforecastcategory,
        forecastcategory,
        prevforecastupdate,
        fromopportunitystagename,
        prevopportunitystageupdate,
        validthroughdate,
        systemmodstamp,
        isdeleted,
        prevamount,
        prevclosedate

    from source

)

select * from renamed
  );
