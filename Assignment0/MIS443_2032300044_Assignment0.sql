/*
STUDENT NAME: Vũ Đông Dương
STUDENT ID: 2032300044
LAB NAME: Assignment 0 - Basic SQL Install and Load Database with PostgreSQL
DATE: 02/07/2026
*/

-- ==========================================================
-- SETUP: Create database and import sample data
-- (Run in psql, not pgAdmin Query Tool -- \c and \i are psql-only commands)
-- ==========================================================
CREATE DATABASE sqlda;
\c sqlda
\i 'C:\\Users\\lenovo\\OneDrive\\Desktop\\MIS 443\\SQL-for-Data-Analytics-Fourth-Edition-main\\Datasets\\data.dump'

-- Verify connection
SELECT current_timestamp;
SELECT * FROM public.products LIMIT 5;

-- ==========================================================
-- QUESTION: Please create SQL statements to fetch the first 20 rows of each table in your sqlda database.
-- Q1. Which table is empty?
select * from countries limit 20;
select * from customer_sales limit 20;
select * from customer_survey limit 20;
select * from customers limit 20;
select * from dealerships limit 20;
select * from emails limit 20;
select * from products limit 20;
select * from public_transportation_by_zip limit 20;
select * from sales limit 20;
select * from salespeople limit 20;
-- SELECT * retrieves every column of the table, FROM specifies which table to query, and LIMIT 20 caps the output at the first 20 rows so the result set stays readable. 

-- Q2. Which table has fewer than 20 records?
select 'countries' as table_name, count(*) from countries
union all select 'customer_sales', count(*) from customer_sales
union all select 'customer_survey', count(*) from customer_survey
union all select 'customers', count(*) from customers
union all select 'dealerships', count(*) from dealerships
union all select 'emails', count(*) from emails
union all select 'products', count(*) from products
union all select 'public_transportation_by_zip', count(*) from public_transportation_by_zip
union all select 'sales', count(*) from sales
union all select 'salespeople', count(*) from salespeople;
-- "COUNT(*) returns the exact row count of a table. Each sub-query is labeled with a sub-name (table_name), so the result shows which table each count belongs to.
-- UNION ALL then combines all ten counts into a single result set for easy comparison."

-- RESULTS (row counts):
-- products                        12
-- dealerships                     20
-- salespeople                     300
-- countries                       0
-- customer_survey                 32
-- public_transportation_by_zip    15412
-- sales                           37711
-- customers                       50000
-- customer_sales                  50000
-- emails                          418158
-- ==========================================================

-- ANSWERS:
-- A1: The 'countries' table is empty (0 rows).
-- A2: The 'products' & 'countries'table has fewer than 20 records (12 rows and 0  row).
