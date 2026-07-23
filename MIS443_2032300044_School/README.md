# MIS443 - Assignment 4: Individual PostgreSQL Database Project

**Course:** MIS 443 - Business Data Management
**Lecturer:** Mr. Dang Thai Doan
**Selected Schema:** School
**Student:** Vu Dong Duong - 2032300044

## Project Description

This project recreates the **School** schema from [SQL Practice Online](https://www.sql-practice.online/) in PostgreSQL. The database models a simplified university consisting of four related tables (`students`, `professors`, `courses`, `enrollments`) and includes solutions for the SQL practice questions provided for this schema.

## Tools Used

- PostgreSQL (database engine)
- pgAdmin 4 (database creation, CSV import, and query execution)
- SQL Practice Online (source schema and question set)
- Microsoft Word (report)
- CSV (data storage format)
- GitHub (project publication)

## Folder Structure

```
MIS443_2032300044_School/
│
├── codes/
│   ├── 01_create_database.sql
│   ├── 02_create_tables_relationships.sql
│   ├── 03_import_data.md
│   └── 04_questions_01_30.sql
│
├── data/
│   ├── students.csv
│   ├── professors.csv
│   ├── courses.csv
│   └── enrollments.csv
│
├── report/
│   ├── ERD.png
│   └── MIS443_2032300044_School_Report.docx
│
└── README.md
```

## How to Run

1. Open pgAdmin 4 and connect to your local PostgreSQL server.
2. Open the Query Tool on the default `postgres` database and run `codes/01_create_database.sql` to create the `school` database.
3. Reconnect the Query Tool to the new `school` database.
4. Run `codes/02_create_tables_relationships.sql` to create all tables, keys, and constraints.
5. Load the data from the `data/` folder by following `codes/03_import_data.md`. In short: use the pgAdmin **Import/Export** tool (right-click a table → Import/Export Data → Import, format CSV, Header = Yes) and import in this order so the foreign keys resolve:
   `students` → `professors` → `courses` → `enrollments`
6. Run `codes/04_questions_01_30.sql` to execute all 30 SQL practice questions and review the results.

Note: this project loads data via CSV import rather than a separate `03_insert_data.sql` script. The import procedure is documented in `codes/03_import_data.md`, which occupies the 03 slot instead.

## Source

Schema and question set: [SQL Practice Online](https://www.sql-practice.online/)

## GitHub Repository

https://github.com/DuongvuBBS20/MIS443-Q4-2025_2026/tree/main/MIS443_2032300044_School
