
    
    

select
    line_item_key as unique_field,
    count(*) as n_records

from "dbt"."marts"."fct_opportunity_line_items"
where line_item_key is not null
group by line_item_key
having count(*) > 1


