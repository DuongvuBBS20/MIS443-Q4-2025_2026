# File 03 - Importing the Data

Data is loaded from the CSV files in `data/`.

In pgAdmin: right-click the table → **Import/Export Data...** → Import, Format `csv`,
Header **Yes**, NULL Strings **empty**.

Import in this order, or the foreign keys reject the rows:
`students` → `professors` → `courses` → `enrollments`
