cat > /workspaces/dbt_interview/README.md << 'EOF'
# dbt Interview Project — Salesforce CRM Dimensional Model
**Saravan Subramaniam | April 2026**
Built with assistance from Claude and GitHub Copilot for accelerated development and code review.

## Overview
A production-grade dimensional model built with dbt on top of Salesforce CRM data using DuckDB. Demonstrates comprehensive dbt engineering practices across all layers — staging, intermediate, and marts.

## Quick Start
This project requires [Dev Containers](https://containers.dev/).

1. Clone the repository
2. Open in VS Code with the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) installed
3. Click **Reopen in Container** when prompted
4. Once inside the container:

```bash
cd transformation
dbt deps        # install packages (dbt_utils, dbt_date)
dbt build       # builds all 28 models + runs 97 tests
```

**Expected result: `PASS=129, ERROR=0`**

## View Documentation
```bash
cd transformation
dbt docs serve --port 8080
# Open: http://localhost:8080
```
Full interactive DAG with lineage from raw Salesforce data through to PowerBI exposures.

## Architecture
Raw Salesforce Data (DuckDB)
↓
Staging Layer (14 views)      — column renames, no logic
↓
Intermediate Layer (3 tables) — business logic, joins, window functions
↓
Marts Layer (11 models)       — star schema, BI ready
↓
PowerBI Dashboards (2 exposures)
## What's Built

### Models (28 Total)
| Layer | Count | Models |
|---|---|---|
| Staging | 14 | stg_salesforce__* (provided, views) |
| Intermediate | 3 | int_opportunities_enriched, int_accounts_enriched, int_leads_converted |
| Dimensions | 6 | dim_accounts, dim_users, dim_contacts, dim_campaigns, dim_products, dim_date |
| Facts | 5 | fct_opportunities (incremental), fct_cases, fct_leads, fct_opportunity_line_items (M:M bridge), fct_opportunities_summary |
| Snapshot | 1 | snap_accounts (SCD Type 2) |

### Tests (97 Total — All Passing)
- **17** unique PK tests
- **50** not_null tests
- **15** accepted_values tests
- **10+** relationship / FK integrity tests
- **2** composite key tests (dbt_utils.unique_combination_of_columns)
- **1** singular business rule test (amount > 0)

### Seeds (3)
- `opportunity_stages` — pipeline stage sequence and outcomes
- `case_statuses` — support case status lookup
- `employee_departments` — org department reference

## dbt Features Demonstrated
| Feature | Implementation |
|---|---|
| Materializations (view, table, incremental) | staging=view, intermediate=table, fct_opportunities=incremental |
| Snapshot SCD Type 2 | snap_accounts — tracks industry, rating, SLA, active status |
| Custom macro | macros/safe_divide.sql — null-safe division |
| generate_surrogate_key | All dim_ and fct_ models |
| dbt_date package | dim_date — 50-column date spine |
| Composite key tests | stg_opportunity_history, stg_case_history_2 |
| Jinja loops | fct_opportunities_summary — dynamic column selection |
| Tags | staging / intermediate / marts / daily |
| Exposures | 2 PowerBI dashboards with full DAG lineage |
| store_failures | Key PK test — failures persisted to DB |
| Window functions | ROW_NUMBER, LAG in int_opportunities_enriched |
| persist_docs | Model + column descriptions pushed to DuckDB |
| Doc blocks | models/docs.md — 600+ lines |

## Project Structure
transformation/
├── models/
│   ├── staging/          # 14 views — raw Salesforce data
│   │   └── _models.yml   # tests + descriptions
│   ├── intermediate/     # 3 tables — business logic + window functions
│   │   └── _models.yml
│   ├── marts/            # 6 dims + 5 facts — BI ready star schema
│   │   └── _models.yml   # FK tests, grain docs, meta tags
│   ├── docs.md           # 600+ line design documentation
│   └── exposures.yml     # 2 PowerBI dashboard declarations
├── macros/
│   └── safe_divide.sql   # custom Jinja macro
├── seeds/                # 3 reference CSV datasets
├── snapshots/
│   └── snap_accounts.sql # SCD Type 2
├── tests/
│   └── assert_opportunities_amount_positive.sql
└── transformation/
└── target/           # pre-generated dbt docs site
└── index.html    # open via dbt docs serve

## Design Decisions
Full architecture documentation in `transformation/models/docs.md` covering:
- Star schema design and dimensional modeling rationale
- Incremental materialization strategy for fct_opportunities
- SCD Type 2 approach for account change tracking
- Many-to-many bridge pattern for opportunity line items
- LEFT JOIN strategy to preserve all opportunities
- Surrogate key generation via dbt_utils
- FK relationship test strategy including nullable fields

## Build Verification

dbt build → PASS=129, WARN=0, ERROR=0, SKIP=0, NO-OP=2

- NO-OP=2: incremental model had no new rows on this run (expected behaviour)
