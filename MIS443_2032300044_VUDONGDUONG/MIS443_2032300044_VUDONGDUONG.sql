/*
===============================================================================
MIS 443 - FINAL EXAM - SQL SKELETON
Database Management System: PostgreSQL
Duration: 90 minutes | Total: 100 marks

STUDENT ID : 2032300044
FULL NAME  : VU DONG DUONG
GITHUB URL :
DATE: 27/08/2026
===============================================================================
*/


/*
QUESTION 1 - DATABASE SETUP (10 marks)

(a) Load the database (5 marks)
Create a PostgreSQL database using your full name in lowercase, without spaces
or Vietnamese diacritics. Connect to it and execute the provided file:
MIS443_Customer_Insights_PostgreSQL.sql

Confirm that country, customers, orders, products, and baskets are available
in the public schema.
*/
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_name IN ('country', 'customers', 'orders', 'products', 'baskets')
ORDER BY table_name;

/*
Expected rows:
baskets
country
customers
orders
products
*/
-- Question 1(b): Create public.students.
create table public.students (
student_id char(10) primary key,
full_name varchar(100) not null,
email varchar(100) unique not null);

-- Question 1(b): Insert your actual information.
insert into public.students(student_id, full_name, email) 
values ('2032300044','Vu Dong Duong','duong.vu.bbs20@eiu.edu.vn');
select * from students;

/*QUESTION 2 - CUSTOMER PROFILE (10 marks)

The Marketing Manager wants to understand customers who permit marketing
emails. Calculate their average age, name the result average_age, and round it
to two decimal places.
*/

select round(avg(age), 2) as average_age
from customers
where can_email = 'yes';


-- Expected result: 37.00
/*
QUESTION 3 - CUSTOMER AND CHANNEL ACTIVITY (20 marks)

(a) Sales-channel activity (10 marks)
The Sales Manager wants to compare retail and online channel usage. Calculate
the number of orders for each sales_channel. Name the result total_orders and
sort it from highest to lowest.
*/

select sales_channel, count(order_id) as total_orders
from orders 
group by sales_channel
order by total_orders desc;


/*
Expected rows:
retail | 5
online | 3
*/

/*
(b) Repeat customers (10 marks)
The Customer Relationship Manager wants to identify customers who placed more
than one order. Display customer_id, age, and total_orders. Sort by total_orders
descending and then customer_id ascending.
*/

select c.customer_id, c.age, count (o.order_id) as total_orders
from customers c
join orders o on o.customer_id = c.customer_id
group by c.customer_id, c.age
having count(o.order_id)>1
order by total_orders desc, customer_id asc;



/*
Expected rows:
customer_id 1 | age 23 | 2 orders
customer_id 3 | age 32 | 2 orders
*/

/*
QUESTION 4 - ORDER AND COUNTRY ANALYSIS (20 marks)

(a) Order-monitoring report (10 marks)
Create an order report showing order_id, date_shop, sales_channel, customer age
as customer_age, and country_name. Sort by the newest order date and then by
order_id.
*/

select o.order_id, o.date_shop, o.sales_channel,
		c.age as customer_age,
		co.country_name
from orders o
join customers c on c.customer_id = o.customer_id
join country co on co.country_id = o.country_id
order by o.date_shop desc, order_id;
		



/*
Expected rows:
8 | 2023-02-11 | online | 32 | China
7 | 2023-02-05 | retail | 28 | UK
6 | 2023-02-02 | online | 49 | UK
5 | 2023-01-28 | retail | 23 | China
3 | 2023-01-25 | retail | 26 | USA
4 | 2023-01-25 | online | 32 | UK
2 | 2023-01-20 | retail | 25 | UK
1 | 2023-01-16 | retail | 23 | UK
*/

/*
(b) Country performance (10 marks)
Calculate the number of orders for each country, including countries with no
orders. Display country_name and total_orders. Sort by total_orders descending
and then country_name alphabetically.
*/

select  co.country_name, count(o.order_id) as total_orders
from country co
left join orders o on o.country_id = co.country_id
group by co.country_name
order by country_name asc, total_orders desc;



/*
Expected rows:
UK    | 5
China | 2
USA   | 1
*/


/*
QUESTION 5 - PRODUCT AND REVENUE ANALYSIS (20 marks)

(a) Category performance (10 marks)
For each product category, calculate total_quantity and total_revenue. Revenue
equals price multiplied by quantity. Round revenue to two decimal places and
sort from highest to lowest revenue.
*/

select p.category, sum(b.quantity) as total_quantity,
	  round(sum(p.price * b.quantity),2) as total_revenue
from baskets b
join products p on p.product_id = b.product_id
group by p.category
order by total_revenue desc


/*
Expected rows:
vitamins | 7 | 66.93
sports   | 3 | 37.47
food     | 6 | 25.74
*/

/*
(b) High-value orders (10 marks)
Calculate the total value of each order and return only orders worth more than
20.00. Display order_id and total_order_value, rounded to two decimal places.
Sort from highest to lowest value.
*/

select o.order_id,
round(sum(p.price * b.quantity),2) as total_revenue
from orders o
join baskets b on b.order_id = o.order_id
join products p on p.product_id = b.product_id
group by o.order_id
having sum(p.price * b.quantity) >20
order by total_revenue desc;


/*
Expected rows:
order 1 | 34.47
order 5 | 22.98
*/

/*
QUESTION 6 - ADVANCED BUSINESS ANALYSIS (20 marks)

(a) Customer purchase recency (10 marks)
For every customer who permits marketing emails, display customer_id, age, and
their latest order date as latest_order_date. Include eligible customers with
no orders and sort by customer_id.
*/

select c.customer_id, c.age, 
	max (o.date_shop) as latest_order_date
from customers c
left join orders o on o.customer_id = c.customer_id
where can_email = 'yes'
group by c.customer_id, c.age
order by c.customer_id ;


/*
Expected rows:
customer 4 | age 25 | 2023-01-20
customer 5 | age 49 | 2023-02-02
customer 8 | age 37 | NULL
*/


/*
(b) Customer activity ranking (5 marks)
Rank all customers by their number of orders. Customers with equal totals must
receive the same rank without ranking gaps. Include customers with no orders.
Display customer_id, age, total_orders, and activity_rank. Do not use a CTE.
*/

select c.customer_id, c.age,
count(o.order_id) as total_orders,
dense_rank () over (order by count(o.order_id)) as activity_rank
from customers c
left join orders o on o.customer_id = c.customer_id
group by c.customer_id, c.age
order by activity_rank desc;


/*
Expected ranking:
Rank 1: customers 1 and 3 with 2 orders
Rank 2: customers 2, 4, 5, and 6 with 1 order
Rank 3: customers 7 and 8 with 0 orders
*/

/*
(c) Channel performance using a CTE (5 marks)
Use a CTE to calculate each order's total value. Then summarise performance by
sales_channel. Display sales_channel, total_orders, total_revenue, and
average_order_value. Round monetary values to two decimal places and sort by
total_revenue descending.
*/

with order_totals as(
select o.sales_channel, o.order_id,
sum(p.price * b.quantity) as order_value
from orders o
join baskets b on b.order_id = o.order_id
join products p on p.product_id = b.product_id
group by o.order_id, o.sales_channel
)
select sales_channel,
count(order_id) as total_orders, 
round(sum(order_value),2) as total_revenue,
round (avg(order_value),2) as avg_order_value
from order_totals
group by sales_channel
order by total_revenue desc;




/*
Expected rows:
retail | 5 | 83.81 | 16.76
online | 3 | 46.33 | 15.44
*/

-- END OF EXAM
