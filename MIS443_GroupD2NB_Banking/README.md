# MIS443 - Assignment 2: PostgreSQL Database Development and SQL Practice

**Course:** MIS 443 - Business Data Management
**Lecturer:** Mr. Dang Thai Doan
**Selected Schema:** Banking
**Group:** D2NB

## Group Members

| No. | Student Name | Student ID |
|---|---|---|
| 1 | Vu Dong Duong | 2032300044 |
| 2 | Than Que Ngoc | 2232300060 |
| 3 | Van Vu Quynh Nhu | 2232300079 |
| 4 | Do Hoang Bao | 2232300071 |

## Project Description

This project recreates the **Banking** schema from [SQL Practice Online](https://www.sql-practice.online/practice/hr?engine=postgresql) in PostgreSQL. The database models a simplified bank consisting of five related tables (`branches`, `customers`, `accounts`, `transactions`, `loans`) and includes complete solutions for all 30 SQL practice questions provided for this schema.

## Tools Used

- PostgreSQL (database engine)
- pgAdmin 4 (database creation and query execution)
- SQL Practice Online (source schema and question set)
- Microsoft Word (group report)
- CSV (data storage format)
- GitHub (project publication)

## Folder Structure

```
MIS443_GroupD2NB_Banking/
│
├── codes/
│   ├── 01_create_database.sql
│   ├── 02_create_tables_relationships.sql
│   ├── 03_insert_data.sql
│   └── 04_questions_01_30.sql
│
├── data/
│   ├── branches.csv
│   ├── customers.csv
│   ├── accounts.csv
│   ├── transactions.csv
│   └── loans.csv
│
├── report/
│   └── MIS443_GroupD2NB_Banking_Report.docx
│
└── README.md
```

## How to Run

1. Open pgAdmin 4 and connect to your local PostgreSQL server.
2. Open the Query Tool on the default `postgres` database and run `codes/01_create_database.sql` to create the `banking` database.
3. Reconnect the Query Tool to the new `banking` database.
4. Run `codes/02_create_tables_relationships.sql` to create all tables, keys, and constraints.
5. Run `codes/03_insert_data.sql` to populate the tables (the same data is also available as CSV files in `data/`).
6. Run `codes/04_questions_01_30.sql` to execute all 30 SQL practice questions and review the results.

## Source

Schema and question set: [SQL Practice Online - Banking](https://www.sql-practice.online/practice/hr?engine=postgresql)

## Acknowledgement

This project was completed collaboratively as a group assignment for MIS 443. All four members contributed to schema analysis, database implementation, and SQL question solving, as detailed in the group report.
