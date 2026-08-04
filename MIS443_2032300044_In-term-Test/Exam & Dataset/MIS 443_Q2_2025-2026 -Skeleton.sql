
/*
MIS 443 - FINAL EXAM - Q2
DATE: 25/03/2026

STUDENT NAME:
STUDENT ID:
*/

/*

Question 1 – Database Setup (10 marks)

Using pgAdmin & PostgreSQL:

(a) Create a database named yourfullname. Then load all Northwind tables into this schema. (5 marks)
Use file "Northwind.sql"

(b) Create a new table called students inside schema exam with the following columns:

Column	Requirement
studentid	5-digit number, Primary Key
fullname	Required
email	Must be unique

Insert your own information into the table. (5 marks)

Then you can check your database before continuing.
*/
SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public' 
ORDER BY table_name, ordinal_position;


--(b) Create table students
-- Your answer here

--(c) Insert your own record
-- Your answer here

-- (d) Verify the result
SELECT * FROM students;


-- Question 2: Write an SQL query to find the top 5 customers who placed the highest number of orders.

-- Your answer here


-- Question 3: Write an SQL query to display a list of orders and the customers who made them. Sort by order date (newest first)

-- Your answer here


-- Question 4: Northwind management wants to identify large product movements to better plan inventory and logistics. Write an SQL query to display orders where a product was purchased in large quantity (more than 99 units in a single order).

-- Your answer here

-- Question 5: Northwind management wants to evaluate the delivery performance of each shipping partner. Write an SQL query to calculate the average delivery time (in days) for each shipper. Delivery time = shipped_date – order_date

-- Your answer here


-- Question 6: Northwind wants to identify the most active customers (customers who place orders most frequently) to target retention campaigns. Write an SQL query to rank customers based on their total number of orders (highest = rank 1). Customers with the same number of orders must have the same rank.
-- Your answer here
