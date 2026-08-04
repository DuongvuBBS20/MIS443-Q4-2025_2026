# MIS443 - In-term Test Q4 2025-2026: Northwind SQL Analysis

**Course:** MIS 443 - Business Data Management
**Student:** Vu Dong Duong - 2032300044

## Project Description

This project is the in-term test for MIS 443 (Q4, 2025-2026), built on the **Northwind** dataset in PostgreSQL. Northwind models a mid-sized international trading company that sells food and beverage products to business customers, covering customers, orders, order details, products, and shippers.

The test consists of database setup plus six SQL questions covering aggregation, joins, filtering, grouping, and window functions to answer business questions about customer activity, order history, inventory movement, and delivery performance.

## Tools Used

- PostgreSQL (database engine)
- pgAdmin 4 (database creation and query execution)
- Northwind sample dataset
- Microsoft Word (report)
- GitHub (project publication)

## Folder Structure

```
MIS443_2032300044_In-term-Test/
│
├── MIS 443 - In-term Test Q4 2025-2026.doc   # Original test paper
├── Northwind.sql                              # Dataset (14 Northwind tables)
├── MIS443_2032300044_In-term-Test.sql         # Answer script (all 6 questions)
├── MIS443_2032300044_In-term-Test.pdf         # Report with query results
└── README.md
```

## Questions Covered

| # | Question | Marks |
|---|----------|-------|
| 1 | Database setup: create database, load Northwind, create `exam.students` table with constraints | 10 |
| 2 | Top 5 customers with the highest number of orders | 10 |
| 3 | List of orders and their customers, sorted by order date (newest first) | 20 |
| 4 | Orders where a product was purchased in large quantity (> 99 units in a single order) | 20 |
| 5 | Average delivery time (in days) per shipper (`shipped_date - order_date`) | 20 |
| 6 | Rank customers by total number of orders, with ties sharing the same rank | 20 |

## How to Run

1. Open pgAdmin 4 and connect to your local PostgreSQL server.
2. Create a new database (e.g. `vudongduong`).
3. Open the Query Tool on the new database and run `Northwind.sql` to load all 14 Northwind tables.
4. Open `MIS443_2032300044_In-term-Test.sql` and run the statements section by section to reproduce each question's result.

## Source

Dataset: Northwind sample database (provided via `Northwind.sql`)

## GitHub Repository

https://github.com/DuongvuBBS20/MIS443-Q4-2025_2026/tree/main/MIS443_2032300044_In-term-Test
