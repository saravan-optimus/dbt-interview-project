





with validation_errors as (

    select
        caseid, lastmodifieddate
    from "dbt"."staging"."stg_salesforce__case_history_2"
    group by caseid, lastmodifieddate
    having count(*) > 1

)

select *
from validation_errors


