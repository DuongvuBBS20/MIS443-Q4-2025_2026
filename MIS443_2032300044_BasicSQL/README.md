# MIS443_2032300044_BasicSQL

**Assignment 1 Basic SQL: Install and Load a Database with PostgreSQL**

Course: MIS 443 - Business Data Management
Student: Vu Dong Duong (2032300044)

## What this assignment covers

Installing PostgreSQL and pgAdmin 4, loading the course database `sqlda` (the fictional
ZoomZoom car company used throughout *SQL for Data Analytics*), and running a first set of
`SELECT` statements to explore what the database actually contains.

## The task

Fetch the first 20 rows of each of the 10 tables in `sqlda`, then answer two questions:

1. Which table is empty?
2. Which table has fewer than 20 records?

## Approach

The first part is ten `SELECT * FROM <table> LIMIT 20` statements, one per table.

For the two questions, reading ten separate result grids and comparing them by eye is slow
and easy to get wrong. Instead the row counts are stacked into a single result with
`UNION ALL`, so every table appears as one row of a single table and the answers can be
read off directly:

```sql
select 'countries' as table_name, count(*) from countries
union all select 'customer_sales', count(*) from customer_sales
...
```

## Answers

| Question | Answer |
|---|---|
| Which table is empty? | `countries` — 0 rows |
| Which table has fewer than 20 records? | `products` — 12 rows |

`dealerships` has exactly 20 rows, so it does not qualify as "fewer than 20".

## Files

| File | Description |
|---|---|
| `MIS443_2032300044_Assignment_1.sql` | The SQL statements |
| `MIS443_2032300044_Assignment_1.pdf` | Report with pgAdmin screenshots of each result |

## Tools

PostgreSQL 17 · pgAdmin 4
