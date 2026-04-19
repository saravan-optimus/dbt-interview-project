
  
  create view "dbt"."staging"."stg_salesforce__case__dbt_tmp" as (
    with source as (

    select * from "dbt"."raw"."case"

),

renamed as (

    select
        id as case_id,
        isdeleted,
        masterrecordid,
        casenumber,
        contactid,
        accountid,
        assetid,
        productid,
        entitlementid,
        sourceid,
        businesshoursid,
        parentid,
        suppliedname,
        suppliedemail,
        suppliedphone,
        suppliedcompany,
        type,
        status,
        reason,
        origin,
        subject,
        priority,
        description,
        isclosed,
        closeddate,
        isescalated,
        ownerid,
        isclosedoncreate,
        slastartdate,
        slaexitdate,
        isstopped,
        stopstartdate,
        createddate,
        createdbyid,
        lastmodifieddate,
        lastmodifiedbyid,
        systemmodstamp,
        servicecontractid,
        eventsprocesseddate,
        engineeringreqnumber__c,
        slaviolation__c,
        product__c,
        potentialliability__c

    from source

)

select * from renamed
  );
