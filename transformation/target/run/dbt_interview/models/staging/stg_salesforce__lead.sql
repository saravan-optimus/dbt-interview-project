
  
  create view "dbt"."staging"."stg_salesforce__lead__dbt_tmp" as (
    with source as (

    select * from "dbt"."raw"."lead"

),

renamed as (

    select
        id as lead_id,
        isdeleted,
        masterrecordid,
        salutation,
        firstname,
        lastname,
        title,
        company,
        street,
        city,
        state,
        postalcode,
        country,
        latitude,
        longitude,
        geocodeaccuracy,
        phone,
        mobilephone,
        fax,
        email,
        website,
        description,
        leadsource,
        status,
        industry,
        rating,
        annualrevenue,
        numberofemployees,
        ownerid,
        hasoptedoutofemail,
        isconverted,
        converteddate,
        convertedaccountid,
        convertedcontactid,
        convertedopportunityid,
        isunreadbyowner,
        createddate,
        createdbyid,
        lastmodifieddate,
        lastmodifiedbyid,
        systemmodstamp,
        lastactivitydate,
        donotcall,
        hasoptedoutoffax,
        lasttransferdate,
        jigsaw,
        jigsawcontactid,
        cleanstatus,
        companydunsnumber,
        dandbcompanyid,
        emailbouncedreason,
        emailbounceddate,
        individualid,
        pronouns,
        genderidentity,
        siccode__c,
        productinterest__c,
        primary__c,
        currentgenerators__c,
        numberoflocations__c

    from source

)

select * from renamed
  );
