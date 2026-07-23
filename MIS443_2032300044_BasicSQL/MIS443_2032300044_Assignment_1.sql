/*
STUDENT NAME: Vũ Đông Dương
STUDENT ID: 2032300044
LAB NAME: Assignment 1 - Basic SQL Install and Load Database with PostgreSQL
DATE: 02/07/2026
*/

-- ======================================================================================================
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
-- ======================================================================================================