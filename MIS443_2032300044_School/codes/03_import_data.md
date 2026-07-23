# File 03 — Importing the Data

Data is loaded from the CSV files in `data/`, so there is no `03_insert_data.sql`.

In pgAdmin: right-click the table → **Import/Export Data...** → Import, Format `csv`,
Header **Yes**, NULL Strings **empty**.

Import in this order, or the foreign keys reject the rows:
`students` → `professors` → `courses` → `enrollments`

Or in psql:

```
\copy students    FROM 'data/students.csv'    WITH (FORMAT csv, HEADER true);
\copy professors  FROM 'data/professors.csv'  WITH (FORMAT csv, HEADER true);
\copy courses     FROM 'data/courses.csv'     WITH (FORMAT csv, HEADER true);
\copy enrollments FROM 'data/enrollments.csv' WITH (FORMAT csv, HEADER true);
```
