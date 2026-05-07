# Salesforce Semantic Model — Generation Summary

**Date Generated:** May 7, 2026  
**Method:** Power BI MCP (Model Control Plane) + LLM  
**Status:** ✓ Complete and Committed

---

## Overview

Salesforce CRM semantic model built locally as a proof of concept using Power BI MCP tools. All tables, columns, relationships, and DAX measures were generated programmatically from dbt schema definitions **without manual Power BI Desktop interaction**.

This demonstrates end-to-end workflow orchestration:


---

## Tables Created (4)

### 1. **fct_opportunities** — Fact Table
- **Grain:** 1 row per opportunity
- **Columns:** 21 (plus 16 additional columns for denormalization)
- **Key Metrics:** Win Rate, Total Pipeline Value, Avg Days to Close
- **Source:** Salesforce opportunities via dbt, CSV: `dim_accounts.csv`

| Column | Type | Description |
|--------|------|-------------|
| opportunity_key | string | Surrogate key (dbt-generated) |
| opportunity_id | string | Natural key (Salesforce) |
| account_id | string | FK to `dim_accounts` |
| owner_id | string | FK to `dim_users` |
| amount | decimal | USD value |
| probability | decimal | Win probability 0-100 |
| is_won | boolean | Won/lost indicator |
| stage_name | string | Pipeline stage |
| stage_sequence | int64 | Numeric order 1-10 |
| deal_size_band | string | Derived: Small/Medium/Large/Enterprise |
| fiscal_year, fiscal_quarter | int64 | Fiscal period |
| created_date, close_date | datetime | Timeline fields |

### 2. **fct_opportunities_summary** — Summary Table
- **Grain:** 1 row per owner per fiscal quarter
- **Columns:** 12
- **Purpose:** Pre-aggregated metrics for dashboard performance
- **Source:** Aggregated from `fct_opportunities` via dbt

| Column | Type | Description |
|--------|------|-------------|
| owner_id | string | FK to `dim_users` |
| fiscal_year, fiscal_quarter | int64 | Period |
| total_opportunities | int64 | Count of opps |
| total_pipeline_value | decimal | Sum of amounts |
| weighted_pipeline_value | decimal | amount × probability / 100 |
| won_count, lost_count, open_count | int64 | Status counts |
| won_revenue | decimal | Sum of won amounts |

### 3. **dim_accounts** — Account Dimension
- **Grain:** 1 row per account
- **Columns:** 15 core + 18 additional
- **Source:** Salesforce accounts via dbt, CSV: `dim_accounts.csv`

| Column | Type | Description |
|--------|------|-------------|
| account_key | string | Surrogate key |
| account_id | string | Natural key |
| account_name | string | Company name |
| industry, rating | string | Classifications |
| annual_revenue | decimal | USD |
| number_of_employees | int64 | Headcount |
| billing_city, billing_state, billing_country | string | Address |
| company_size_band | string | SMB/Mid-Market/Enterprise |
| is_active | string | Active status |

### 4. **dim_users** — User Dimension
- **Grain:** 1 row per Salesforce user
- **Columns:** 8 core + 19 additional
- **Source:** Salesforce users via dbt, CSV: `dim_users.csv`

| Column | Type | Description |
|--------|------|-------------|
| user_key | string | Surrogate key |
| user_id | string | Natural key |
| full_name | string | Sales rep name |
| email | string | Email |
| title, department | string | Org attributes |
| role_name | string | Salesforce role |
| is_active | string | Active status |

---

## Relationships Created (3)

All relationships configured with **OneDirection** cross-filtering for optimal performance:

| From | To | Cardinality | Purpose |
|------|-----|-------------|---------|
| `fct_opportunities.account_id` | `dim_accounts.account_id` | Many-to-One | Filter opps by account |
| `fct_opportunities.owner_id` | `dim_users.user_id` | Many-to-One | Filter opps by sales rep |
| `fct_opportunities_summary.owner_id` | `dim_users.user_id` | Many-to-One | Filter summary by rep |

---

## DAX Measures Created (3)

All measures in `fct_opportunities` table, **Key Metrics** folder:

### 1. **Win Rate**
```dax
DIVIDE(
    COUNTROWS(FILTER('fct_opportunities', 'fct_opportunities'[is_won] = TRUE())),
    COUNTROWS('fct_opportunities'),
    0
)

Format: 0.00%
Use: Dashboard KPI tiles, trend analysis

2. Total Pipeline Value

SUM('fct_opportunities'[amount])

Format: $#,##0.00,,M
Use: Pipeline summary cards, forecast analysis

3. Avg Days to Close
AVERAGEX(FILTER('fct_opportunities', 'fct_opportunities'[days_to_close] >= 0), 'fct_opportunities'[days_to_close])

AVERAGEX(FILTER('fct_opportunities', 'fct_opportunities'[days_to_close] >= 0), 'fct_opportunities'[days_to_close])


salesforce_pbi/salesforce_pbi.SemanticModel/
├── definition.pbism                          # Model package
├── diagramLayout.json                        # Table diagram layout
├── .platform                                 # Fabric metadata
├── definition/
│   ├── model.tmdl                           # ✓ Model structure + description
│   ├── database.tmdl                        # ✓ Database settings
│   ├── relationships.tmdl                   # ✓ All 3 relationships
│   ├── cultures/
│   │   └── en-IN.tmdl                       # ✓ Localization
│   └── tables/
│       ├── fct_opportunities.tmdl           # ✓ Fact table + 3 measures
│       ├── fct_opportunities_summary.tmdl   # ✓ Summary table
│       ├── dim_accounts.tmdl                # ✓ Account dimension
│       ├── dim_users.tmdl                   # ✓ User dimension
│       └── LocalDateTable_*.tmdl            # ✓ Auto-generated date tables (8)
└── salesforce_pbi.pbip                      # ✓ Project structure


Production Deployment Workflow
This POC demonstrates how to automate semantic model creation in production:

Airflow DAG:
  1. dbt run (Transform Salesforce data)
  2. Export schema definitions to JSON
  3. Call LLM with schema + MCP instructions
  4. LLM generates table/column/relationship/measure specs
  5. Power BI MCP tools execute model creation
  6. Commit TMDL files to git
  7. Deploy to Power BI Service via CI/CD
