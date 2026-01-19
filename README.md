# eCommerce Analytics Project (theLook)

This repo is a reproducible analytics project built on the **theLook eCommerce** dataset (Kaggle export).  
Goal: stand up a local Postgres warehouse with a proper ER model and QA checks, then build analytics-ready SQL for ecommerce performance, category growth, and fulfillment insights.

## Step 1 — Local Data Setup (Postgres)

This step demonstrates production-style data setup: schema creation, typed tables, ingestion handling for real-world edge cases (long strings/URIs), relational integrity via PK/FKs, and QA checks for orphan records. Raw data is excluded from version control due to size constraints (e.g., events.csv ~375MB) and to keep the repo reproducible and clean.

### What this step includes
- Download dataset (kept out of git)
- Load CSVs into Postgres (`thelook_raw` schema)
- Fix common ingestion edge cases (long text fields, event URIs)
- Add Primary Keys + Foreign Keys (ER model)
- Run QA checks (row counts + orphan detection)

My environment note: I executed this setup and loaded the dataset on a private Postgres instance running on my VPS. This repository does not include credentials or server access; it includes the full reproducible scripts and ER model so anyone can replicate the setup in their own Postgres environment.

### Repo structure

data/raw/ # CSVs go here (ignored by git)

events.csv is ~375MB and exceeds GitHub’s 100MB file limit, so raw CSVs are intentionally excluded from version control.

sql/ # database setup scripts

scripts/ # helpers to download data + run setup

docs/erd/ # ERD screenshot(s)


### Prerequisites
- Postgres (local or VPS)
- psql available in PATH
- Kaggle account + Kaggle API token (optional if downloading manually)

### Run Step 1 (high-level)
1) Put Kaggle CSVs in `data/raw/`
2) Run scripts in order from `sql/`:
   - `00_create_schema.sql`
   - `01_create_tables.sql`
   - `02_load_csv.sql`  (edit file paths first)
   - `03_fix_types.sql`
   - `04_constraints.sql`
   - `05_qa.sql`

### Notes
- Dataset files are intentionally ignored from version control.
- Foreign keys are created with `NOT VALID` to allow loading even if orphan records exist. QA scripts surface any issues.
