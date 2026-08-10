-- =============================================================================
-- MIS 443 - 05_analysis_queries.sql   [FULL VERSION - WITH ANSWERS]
-- Database : mis443_chinook
-- Schema   : new_chinook
-- Run after : 03_load_new_schema.sql
-- =============================================================================

SET search_path TO new_chinook;


-- -----------------------------------------------------------------------------
-- Q1. QUESTION: Is the store growing, flat, or shrinking over time?
-- -----------------------------------------------------------------------------

SELECT 
	EXTRACT(YEAR FROM invoice_date)::INT AS year,
    COUNT(*) AS invoices,
    COUNT(DISTINCT customer_id) AS active_customers,
    SUM(total) AS revenue
FROM invoice
GROUP BY 1
ORDER BY 1;


-- -----------------------------------------------------------------------------
-- Q2. QUESTION: Which countries generate the most revenue, and is a country
--     valuable because it has many customers or because each one spends more?
-- -----------------------------------------------------------------------------
SELECT c.country,
       COUNT(DISTINCT c.customer_id) AS num_customers,
       SUM(i.total)                  AS total_revenue,
       CASE WHEN COUNT(DISTINCT c.customer_id) >= 3
            THEN ROUND(SUM(i.total) / COUNT(DISTINCT c.customer_id), 2)
       END                           AS avg_spend_per_customer,
       ROUND(100.0 * SUM(i.total) / (SELECT SUM(total) FROM invoice), 1) AS pct_of_revenue
FROM customer c
JOIN invoice i ON i.customer_id = c.customer_id
GROUP BY c.country
ORDER BY total_revenue DESC;

-- -----------------------------------------------------------------------------
-- Q3. QUESTION: Which genres earn the most, and does catalog size match demand?
-- -----------------------------------------------------------------------------
-- Q3. QUESTION: Which genres earn the most, and does catalog size match demand?

SELECT 
	   g.name AS genre,
       COUNT(DISTINCT t.track_id) AS tracks_in_catalog,
       COALESCE(SUM(il.unit_price * il.quantity), 0) AS revenue,
       ROUND(COALESCE(SUM(il.unit_price * il.quantity), 0)
             / COUNT(DISTINCT t.track_id), 2) AS revenue_per_track
FROM genre g
LEFT JOIN track t ON t.genre_id = g.genre_id
LEFT JOIN invoice_line il ON il.track_id = t.track_id
GROUP BY g.genre_id, g.name
ORDER BY revenue DESC;

-- -----------------------------------------------------------------------------
-- Q4. QUESTION: How much of the catalog has never sold a single unit, and where
--     does it sit?
-- -----------------------------------------------------------------------------

-- Q4a. How much of the catalog has never sold a single unit?
SELECT
    COUNT(*) AS never_sold_tracks,
    (SELECT COUNT(*) FROM track) AS total_tracks,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM track), 1) AS pct_of_catalog
FROM track t
LEFT JOIN invoice_line il ON il.track_id = t.track_id
WHERE il.track_id IS NULL;


-- Q4b. Where does it sit?
SELECT
    g.name AS genre,
    COUNT(DISTINCT t.track_id) AS total_tracks,
    COUNT(DISTINCT t.track_id) FILTER (WHERE il.track_id IS NULL) AS unsold_tracks,
    ROUND(100.0 * COUNT(DISTINCT t.track_id) FILTER (WHERE il.track_id IS NULL)
          / COUNT(DISTINCT t.track_id), 1) AS pct_unsold
FROM genre g
JOIN track t ON t.genre_id = g.genre_id
LEFT JOIN invoice_line il ON il.track_id = t.track_id
GROUP BY g.genre_id, g.name
ORDER BY unsold_tracks DESC
LIMIT 10;

-- -----------------------------------------------------------------------------
-- Q5. QUESTION: Do sales agents differ in ability, or only in how many
--     customers they were assigned?
-- -----------------------------------------------------------------------------
SELECT 
	CONCAT(e.first_name,' ',e.last_name) AS agent,
    COUNT(DISTINCT c.customer_id) AS customers_assigned,
    COUNT(i.invoice_id) AS invoices,
	SUM(i.total) AS revenue,
    ROUND(SUM(i.total) / COUNT(DISTINCT c.customer_id), 2) AS revenue_per_customer
FROM employee e
JOIN customer c ON c.support_rep_id = e.employee_id
JOIN invoice  i ON i.customer_id    = c.customer_id
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY revenue DESC;


-- -----------------------------------------------------------------------------
-- Q6. QUESTION: How did revenue accumulate over time, and how long did it take
--     to reach the first $1,000?
-- -----------------------------------------------------------------------------

-- Q6a. Total sales over time (running total by day)

SELECT 
	invoice_date::DATE AS revenue_date,
    SUM(SUM(total)) OVER (ORDER BY invoice_date::DATE) AS cumulative_revenue
FROM invoice
GROUP BY invoice_date::DATE
ORDER BY revenue_date;


-- Q6b. The date sales reached $1,000, and the days since the first sale

WITH cumulative AS (
    SELECT
        invoice_date::DATE AS revenue_date,
        SUM(SUM(total)) OVER (ORDER BY invoice_date::DATE) AS cumulative_revenue
    FROM invoice
    GROUP BY invoice_date::DATE
)
SELECT
    revenue_date AS date_reached_1000,
    cumulative_revenue,
    revenue_date - (SELECT MIN(invoice_date)::DATE FROM invoice) AS days_since_first_invoice
FROM cumulative
WHERE cumulative_revenue >= 1000
ORDER BY revenue_date
LIMIT 1;
