
  
  create view "dbt"."staging"."stg_salesforce__contact__dbt_tmp" as (
    with source as (

    select * from "dbt"."raw"."contact"

),

renamed as (

    select
        id as contact_id,
        isdeleted,
        masterrecordid,
        accountid,
        salutation,
        firstname,
        lastname,
        otherstreet,
        othercity,
        otherstate,
        otherpostalcode,
        othercountry,
        otherlatitude,
        otherlongitude,
        othergeocodeaccuracy,
        mailingstreet,
        mailingcity,
        mailingstate,
        mailingpostalcode,
        mailingcountry,
        mailinglatitude,
        mailinglongitude,
        mailinggeocodeaccuracy,
        phone,
        fax,
        mobilephone,
        homephone,
        otherphone,
        assistantphone,
        reportstoid,
        email,
        title,
        department,
        assistantname,
        leadsource,
        birthdate,
        description,
        ownerid,
        hasoptedoutofemail,
        hasoptedoutoffax,
        donotcall,
        createddate,
        createdbyid,
        lastmodifieddate,
        lastmodifiedbyid,
        systemmodstamp,
        lastactivitydate,
        lastcurequestdate,
        lastcuupdatedate,
        emailbouncedreason,
        emailbounceddate,
        jigsaw,
        jigsawcontactid,
        cleanstatus,
        individualid,
        pronouns,
        genderidentity,
        level__c,
        languages__c

    from source

)

select * from renamed
  );
