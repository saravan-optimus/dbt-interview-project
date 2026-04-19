
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  -- Test: No opportunity should have a negative amount
-- Returns rows that FAIL the test (should be 0 rows)

select
    opportunity_id,
    amount
from "dbt"."marts"."fct_opportunities"
where amount < 0
  
  
      
    ) dbt_internal_test