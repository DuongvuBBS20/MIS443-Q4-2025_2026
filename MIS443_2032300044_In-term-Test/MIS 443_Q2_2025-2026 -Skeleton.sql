/*
MIS 443 - FINAL EXAM - Q2
DATE: 25/03/2026

STUDENT NAME: VU DONG DUONG
STUDENT ID: 2032300044
*/

/*

Question 1 – Database Setup (10 marks)

Using pgAdmin & PostgreSQL:

(a) Create a database named yourfullname. Then load all Northwind tables into this schema. (5 marks)
Use file "Northwind.sql"*/
CREATE SCHEMA exam;
/*(b) Create a new table called students inside schema exam with the following columns:

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
CREATE TABLE exam.students (
    studentid   CHAR(5) PRIMARY KEY,
    fullname    VARCHAR(100) NOT NULL,
    email       VARCHAR(100) UNIQUE NOT NULL);

--(c) Insert your own record
INSERT INTO exam.students (studentid, fullname, email)
VALUES ('00044', 'VU DONG DUONG', 'duong.vu.bbs20@eiu.edu.vn');

-- (d) Verify the result
SELECT * FROM exam.students;

-- Question 2: Write an SQL query to find the top 5 customers who placed the highest number of orders.

SELECT 	c.customer_id, 
		COUNT(o.order_id) AS total_orders 
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.company_name
ORDER BY total_orders DESC
LIMIT 5;


-- Question 3: Write an SQL query to display a list of orders and the customers who made them. Sort by order date (newest first)

SELECT o.order_id,
       o.order_date,
       c.company_name
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
ORDER BY o.order_date DESC;


-- Question 4: Northwind management wants to identify large product movements to better plan inventory and logistics. 
-- Write an SQL query to display orders where a product was purchased in large quantity (more than 99 units in a single order).

SELECT o.order_id,
       o.order_date,
       p.product_name,
       od.quantity
FROM order_details od
JOIN orders o     ON o.order_id = od.order_id
JOIN customers c  ON c.customer_id = o.customer_id
JOIN products p   ON p.product_id = od.product_id
WHERE od.quantity > 99
ORDER BY od.quantity DESC;

-- Question 5: Northwind management wants to evaluate the delivery performance of each shipping partner. 
-- Write an SQL query to calculate the average delivery time (in days) for each shipper. Delivery time = shipped_date – order_date

SELECT s.company_name,
       AVG(o.shipped_date - o.order_date) AS avg_delivery_days
FROM orders o
JOIN shippers s ON s.shipper_id = o.ship_via
WHERE o.shipped_date IS NOT NULL
GROUP BY s.shipper_id, s.company_name
ORDER BY avg_delivery_days DESC;

-- Question 6: Northwind wants to identify the most active customers (customers who place orders most frequently) 
-- to target retention campaigns. Write an SQL query to rank customers based on their total number of orders (highest = rank 1). 
-- Customers with the same number of orders must have the same rank.
SELECT c.customer_id,
       c.company_name,
       COUNT(o.order_id) AS total_orders,
       RANK() OVER (ORDER BY COUNT(o.order_id) DESC) AS customer_rank
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.company_name
ORDER BY customer_rank;