
    
    

select
    case_id as unique_field,
    count(*) as n_records

from "dbt"."staging"."stg_salesforce__case"
where case_id is not null
group by case_id
having count(*) > 1


