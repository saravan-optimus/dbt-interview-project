-- Test: No opportunity should have a negative amount
-- Returns rows that FAIL the test (should be 0 rows)

select
    opportunity_id,
    amount
from {{ ref('fct_opportunities') }}
where amount < 0
