# dbt Interview Project — Documentation

## Dimensional Model Architecture

This dbt project implements a **star schema** dimensional model on top of Salesforce staging data, demonstrating enterprise-grade analytics engineering practices.

### Model Layers

- **Staging** (stg_*): Raw Salesforce data with minimal transformations (column renames, type conversions). 1:1 mapping to source objects.
- **Intermediate** (int_*): Denormalization and business logic. Enrichment with related entity context (e.g., enriching opportunities with account details).
- **Marts** (dim_*, fct_*): Fact and dimension tables optimized for BI consumption. Surrogate keys, star schema joins.

### Dimensional Model Diagram

```
                                ┌──────────────────┐
                                │   dim_date       │
                                │  (calendar dim)  │
                                └──────────────────┘
                                        ▲
                                        │
              ┌─────────────────────────┼─────────────────────────┐
              │                         │                         │
        ┌─────────────┐           ┌──────────────┐          ┌──────────────┐
        │ dim_users   │           │ dim_accounts │          │ dim_campaigns│
        │  (sales reps)│───┐      │  (companies) │─────┐    │  (campaigns) │
        └─────────────┘   │      └──────────────┘     │    └──────────────┘
              ▲            │             ▲             │
              │            │             │             │
              │      ┌──────────────────────────────────┐
              │      │                                  │
              │      ▼                                  │
              │  ┌─────────────────────────────────┐   │
              │  │  fct_opportunities (INCREMENTAL)│   │
              │  │  (sales transactions)           │   │
              │  └─────────────────────────────────┘   │
              │            │                           │
              │            └───────────────────────────┘
              │
        ┌─────────────┐    ┌──────────────┐
        │ dim_products│    │ dim_contacts │
        └─────────────┘    └──────────────┘
              ▲                    ▲
              │                    │
        ┌─────────────────────────────────────────────┐
        │  fct_opportunity_line_items (bridge M:M)    │
        │  Links opportunities to products            │
        └─────────────────────────────────────────────┘

Other Fact Tables:
- fct_cases (support tickets, joins dim_accounts, dim_contacts, dim_users)
- fct_leads (pre-conversion prospects, joins dim_campaigns, dim_users)

Snapshot (SCD Type 2):
- snap_accounts (time-series of account attribute changes)
```

---

## Key Design Patterns

### 1. Surrogate Keys

All dimension and fact tables use dbt-generated surrogate keys via the `dbt_utils.generate_surrogate_key()` macro:

```sql
{{ dbt_utils.generate_surrogate_key(['account_id']) }} as account_key
```

**Benefits:**
- Stable across source system changes (e.g., if Salesforce ID is re-assigned)
- Smaller than concatenated natural keys (better performance for joins)
- Consistent across all tables (standard BI practice)

**Implementation:**
- Natural keys are preserved (account_id, opportunity_id, etc.) for lineage and debugging
- Surrogate keys used for all BI joins
- PK tests validate both natural keys (unique, not_null) and surrogate keys

---

### 2. Incremental Materialization (fct_opportunities)

`fct_opportunities` is **incrementally materialized** to handle large transaction volumes efficiently:

```sql
{{
    config(
        materialized='incremental',
        unique_key='opportunity_id',
        on_schema_change='sync_all_columns'
    )
}}
```

**Strategy:**
- First dbt run: Build full table from int_opportunities_enriched
- Subsequent runs: Only insert/update opportunities where `lastmodifieddate > max(last_modified_date)` in target table
- `on_schema_change='sync_all_columns'`: Auto-detect and sync new columns from upstream
- `unique_key='opportunity_id'`: Merge on opportunityid for idempotency (re-running same fact gives same result)

**Benefits:**
- Reduces compute time (partial refreshes instead of full rebuild)
- Handles late-arriving facts (if a sale closes days after first seen)
- Maintains full historical record while being efficient

---

### 3. Slowly Changing Dimensions (SCD Type 2)

`snap_accounts` implements **SCD Type 2** (track all historical versions):

```sql
{% snapshot snap_accounts %}
  config(
    unique_key='account_id',
    strategy='check',
    check_cols=['industry', 'rating', 'sla__c', 'active__c'],
    invalidate_hard_deletes=True
  )
```

**How it works:**
- dbt runs snapshot once per day (via scheduling, e.g., Airflow)
- If tracked columns change, a new row is inserted with:
  - `dbt_valid_from`: When this version became active
  - `dbt_valid_to`: When next version started (NULL if current)
  - `dbt_scd_id`: Unique ID for each version
- Allows time-series analysis: "How many accounts were rated 'Hot' on any given date?"

**Tracked columns (account attribute changes trigger new rows):**
- `industry`
- `rating`
- `sla__c` (SLA tier)
- `active__c` (active status)

**Query example:**
```sql
SELECT * FROM snap_accounts
WHERE account_id = 'ABC123'
  AND dbt_valid_from <= '2026-04-01'
  AND (dbt_valid_to > '2026-04-01' OR dbt_valid_to IS NULL)
-- Returns the account as it existed on April 1, 2026
```

---

### 4. Many-to-Many Bridge (fct_opportunity_line_items)

`fct_opportunity_line_items` implements a **bridge table** pattern linking opportunities to products:

**Problem solved:**
- An opportunity can have multiple line items (products)
- A product can be on multiple opportunities
- But dim_opportunities and dim_products are 1:N and N:1 respectively

**Solution:**
- Bridge table with grain = 1 row per (opportunity, product) pair
- FKs to both fct_opportunities and dim_products
- Allows: "Total revenue by product across all opportunities"

**Query example:**
```sql
SELECT
  p.product_name,
  SUM(l.net_price_usd) as total_revenue
FROM fct_opportunity_line_items l
JOIN dim_products p ON l.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC
```

---

### 5. Foreign Key Relationships & Data Tests

All foreign keys are validated with dbt generic tests:

```yaml
- name: account_key
  data_tests:
    - relationships:
        to: ref('dim_accounts')
        field: account_key
```

**Coverage:**
- ✅ fct_opportunities.account_key → dim_accounts.account_key
- ✅ fct_opportunities.owner_key → dim_users.user_key
- ✅ fct_opportunities.campaign_key → dim_campaigns.campaign_key
- ✅ fct_opportunity_line_items.opportunity_key → fct_opportunities.opportunity_key
- ✅ fct_opportunity_line_items.product_key → dim_products.product_key
- ✅ fct_cases.account_key → dim_accounts.account_key
- ✅ fct_leads.campaign_key → dim_campaigns.campaign_key

**Ensures data integrity:** Every fact row points to valid dimension rows (no orphaned records).

---

## Test Strategy

### 1. Primary Key Tests (Uniqueness & Not Null)

Every dimension PK is tested for uniqueness and not_null:

```yaml
columns:
  - name: account_key
    data_tests:
      - unique
      - not_null
```

**Grain verification:** A unique PK confirms the table grain is correct (e.g., if account_key is not unique, we accidentally created duplicate account rows).

### 2. Foreign Key Tests (Referential Integrity)

Fact tables are tested for valid FK references to dimensions:

```yaml
- name: account_key
  data_tests:
    - relationships:
        to: ref('dim_accounts')
        field: account_key
```

**Prevents:**
- Opportunities pointing to non-existent accounts
- Cases with invalid account references
- Data anomalies from upstream ETL errors

### 3. Accepted Values Tests (Domain Constraints)

Categorical fields are validated against acceptable values:

```yaml
- name: stage_name
  data_tests:
    - accepted_values:
        values: ['Prospecting', 'Qualification', '...', 'Closed Won', 'Closed Lost']
```

**Catches:**
- Typos or new stage names in source (e.g., "Closed Won " with trailing space)
- Salesforce picklist changes
- Data entry errors

### 4. Not Null Tests

Critical fields are tested for no NULLs:

```yaml
- name: opportunity_name
  data_tests:
    - not_null
```

---

## Naming Conventions

Consistent naming ensures clarity and enables automated tooling:

| Object Type | Prefix | Example | Purpose |
|-------------|--------|---------|---------|
| Staging | stg_ | stg_salesforce__account | Raw data, minimal transform |
| Intermediate | int_ | int_opportunities_enriched | Business logic, denormalization |
| Dimension | dim_ | dim_accounts | BI dimension table |
| Fact | fct_ | fct_opportunities | BI fact table (transactions) |
| Snapshot | snap_ | snap_accounts | SCD Type 2 time-series |
| Seed | (no prefix) | opportunity_stages | Static reference data |
| Source | (no prefix) | source('salesforce', 'account') | Raw external data |

**Benefits:**
- SQL code is self-documenting ("int_" tells you it's intermediate)
- DAG lineage is clear (stg → int → fct/dim)
- Analytics tools can auto-classify (dim_* = dimensions, fct_* = facts)

---

## CTE-Based SQL Standard

All models follow the CTE (Common Table Expression) pattern:

```sql
with staging_data as (
  select * from {{ ref('stg_opportunity') }}
),

enriched_with_accounts as (
  select
    s.*,
    a.account_name,
    a.industry
  from staging_data s
  left join accounts a on s.account_id = a.account_id
),

final as (
  select
    {{ generate_surrogate_key(['opportunity_id']) }} as opportunity_key,
    opportunity_id,
    amount
  from enriched_with_accounts
)

select * from final
```

**Benefits:**
- **Readability:** CTEs make the data flow obvious (raw → enriched → final)
- **Debuggability:** Easy to comment out CTEs and test intermediate results
- **Consistency:** All models follow same structure
- **Maintainability:** Complex logic is broken into named steps

---

## Documentation Glossary

{% docs surrogate_key %}
A dbt-generated unique identifier (hash of the natural key) used for BI joins.
Provides stability if the source system changes the natural key format.
Stored as a VARCHAR hash, smaller and faster than concatenated natural keys.
{% enddocs %}

{% docs incremental_materialization %}
A table that is built once, then refreshed with only new/modified rows on subsequent runs.
Uses `unique_key` to identify which rows to update (merge logic).
Reduces compute time and enables efficient handling of large transaction tables.
Example: `fct_opportunities` refreshes daily with only modified opportunities.
{% enddocs %}

{% docs scd_type_2 %}
Slowly Changing Dimension Type 2: Tracks all historical versions of dimension records.
New rows are inserted when tracked columns change, with dbt_valid_from and dbt_valid_to dates.
Enables time-series analysis: "What was the account rating on a specific date?"
Example: snap_accounts tracks changes to industry, rating, SLA tier, and active status.
{% enddocs %}

{% docs bridge_table %}
A many-to-many join table linking two dimensions.
Grain = 1 row per unique combination of linked entities.
Example: fct_opportunity_line_items links opportunities to products (N:M relationship).
Used to enable aggregations: "Revenue by product across all opportunities".
{% enddocs %}

{% docs dbt_valid_from %}
Timestamp when a snapshot row became valid (SCD Type 2).
Marks the point in time when tracked columns changed in the source system.
Combined with dbt_valid_to, allows historical dimension lookups at any point in time.
{% enddocs %}

{% docs dbt_valid_to %}
Timestamp when a snapshot row expired (SCD Type 2).
NULL if the row represents the current version (still valid).
Marks the moment the next version of the record was created.
{% enddocs %}
