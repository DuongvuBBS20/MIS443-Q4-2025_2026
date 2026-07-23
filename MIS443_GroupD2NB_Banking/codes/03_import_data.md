-- =====================================================================

-- MIS443 - Assignment 2: PostgreSQL Database Development and SQL Practice

-- Group: D2NB | Schema: Banking (SQL Practice Online)

-- File 03: Importing the Data

-- =====================================================================

Data is loaded from the CSV files in `data/`.

In pgAdmin: right-click the table → **Import/Export Data...** → Import, Format `csv`,
Header **Yes**.

Import in this order, or the foreign keys reject the rows:
`branches` → `customers` → `accounts` → `transactions` → `loans`
