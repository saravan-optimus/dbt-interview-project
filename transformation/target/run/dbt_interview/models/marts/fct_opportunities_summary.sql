
  
    
    

    create  table
      "dbt"."marts"."fct_opportunities_summary__dbt_tmp"
  
    as (
      



with base as (
    select
        opportunity_id,
        account_id,
        owner_id,
        opportunity_status,
        deal_size_band,
        
            amount,
        
            probability,
        
            days_to_close
        
    from "dbt"."intermediate"."int_opportunities_enriched"
)

select * from base
    );
  
  