-- MIS443 - Assignment 2: PostgreSQL Database Development and SQL Practice
-- Group: D2NB | Schema: Banking (SQL Practice Online)
-- File 04: SQL Questions 1-30

-- 1. Return the complete customer roster from the customers table.
SELECT * FROM customers;

-- 2. Return all branch names and their cities.
SELECT branches.branch_name, branches.city
FROM branches;

-- 3. Return all accounts with account type Savings.
SELECT accounts.account_id, accounts.customer_id, accounts.balance
FROM accounts
WHERE account_type = 'Savings';

-- 4. Return accounts with a balance greater than $10,000.
SELECT accounts.customer_id, accounts.account_type, accounts.balance
FROM accounts
WHERE balance > 10000
ORDER BY account_id ASC;

-- 5. Return all transactions of type Deposit.
SELECT transaction_id, account_id, amount, transaction_date
FROM transactions
WHERE transaction_type = 'Deposit'
ORDER BY transaction_id ASC;

-- 6. Return all loans with an Active status.
SELECT loan_id, customer_id, loan_amount, interest_rate
FROM loans
WHERE status = 'Active'
ORDER BY loan_id;

-- 7. Count the total number of accounts.
SELECT COUNT(*) AS total_accounts
FROM accounts;

-- 8. Sum the total amount across all Deposit transactions.
SELECT SUM(amount) AS total_deposits
FROM transactions
WHERE transaction_type  = 'Deposit';

-- 9. The product team needs a list of all account types offered.
-- Find all unique account types available. Show account_type ordered alphabetically.*/
SELECT DISTINCT account_type
FROM accounts
ORDER BY account_type;

-- 10. The audit team needs to review mid-month activity. Find all transactions where
-- transaction_date is between January 10 and January 20, 2025 (inclusive).
-- Show transaction_id, account_id, amount, and transaction_date. Order by transaction_date.
SELECT transaction_id, account_id, amount, transaction_date
FROM transactions
WHERE transaction_date BETWEEN '2025-01-10' AND '2025-01-20'
ORDER BY transaction_date;

-- 11. The new-accounts team wants to follow up with registered customers who have not
-- yet opened any account. Find all customers who have no accounts. Show first name and last name.
SELECT c.first_name, c.last_name
FROM customers c
LEFT JOIN accounts a ON c.customer_id = a.customer_id
WHERE a.account_id IS NULL
ORDER BY c.last_name;

-- 12. The loans department needs to identify customers who have not taken any loan — potential targets for a new loan campaign.
-- Find all customers who have no loans. Show first name and last name ordered by last name.
SELECT c.first_name, c.last_name
FROM customers c
LEFT JOIN loans l ON c.customer_id = l.customer_id
WHERE l.loan_id IS NULL
ORDER BY c.last_name;

-- 13. The relationship management team wants to know how diversified each customer's portfolio is.
-- Show every customer's full name and the number of accounts they hold (including zero).
-- Order by account_count descending, then last name.
SELECT c.first_name, c.last_name, COUNT(a.account_id) AS account_count
FROM customers c
LEFT JOIN accounts a ON c.customer_id = a.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY account_count DESC, c.last_name;

-- 14. Calculate the total balance for each account type.
SELECT account_type, SUM(balance) AS total_balance
FROM accounts
GROUP BY account_type
ORDER BY account_type;

-- 15. Return each customer's name alongside their branch name.
SELECT c.first_name, c.last_name, b.branch_name
FROM customers c JOIN branches b
ON b.branch_id = c.branch_id
ORDER BY last_name;

-- 16. Return each transaction with the transaction date, amount, type, and the customer's last name.
SELECT t.transaction_date, t.amount, t.transaction_type, c.last_name
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
JOIN customers c ON a.customer_id = c.customer_id
ORDER BY t.transaction_date;

-- 17. Return the number of customers assigned to each branch.
SELECT b.branch_name, COUNT(c.customer_id) AS customer_count
FROM branches b
LEFT JOIN customers c ON b.branch_id = c.branch_id
GROUP BY b.branch_name, b.branch_id
ORDER BY b.branch_id;

-- 18. Return the number of accounts held by each customer.
SELECT a.customer_id, COUNT(a.account_id) AS account_count
FROM accounts a
GROUP BY a.customer_id
ORDER BY a.customer_id;

-- 19. Return each loan with the borrower's first and last name, loan amount, and status.
SELECT c.first_name, c.last_name, l.loan_amount, l.status FROM loans l
JOIN customers c ON l.customer_id = c.customer_id
ORDER BY l.loan_amount DESC, c.last_name;

-- 20. Return the total account balance held by customers at each branch.
SELECT b.branch_name, SUM(a.balance) AS total_balance
FROM branches b
JOIN  customers c ON c.branch_id = b.branch_id
JOIN  accounts a  ON c.customer_id = a.customer_id
GROUP BY b.branch_name
ORDER BY total_balance DESC;

-- 21. The branch operations team wants a portfolio view of every customer's holdings.
-- Show each customer's name, their branch name, account type, and balance.
-- Order by branch name, then customer last name.
SELECT c.first_name, c.last_name, b.branch_name, a.account_type, a.balance
FROM customers c
JOIN branches b ON b.branch_id = c.branch_id
JOIN accounts a ON a.customer_id = c.customer_id
ORDER BY b.branch_name, c.last_name;

-- 22. For each account that has transactions, show total deposits and
-- total withdrawals side by side using conditional aggregation. Order by account_id.
SELECT account_id,
  SUM(CASE WHEN transaction_type = 'Deposit' THEN amount ELSE 0 END ) AS total_deposits,
  SUM(CASE WHEN transaction_type = 'Withdrawal' THEN amount ELSE 0 END ) AS total_withdrawals
FROM transactions
GROUP BY account_id
ORDER BY account_id;

-- 23. Group transactions by year-month (using strftime).
-- Show month, transaction count, and total amount. Order by month ascending.
--Note: using TO_CHAR instead of STRFTIME, because TO_CHAR is the standard PostgreSQL function for formatting dates; 
--STRFTIME is only supported by SQLite.
SELECT TO_CHAR(transaction_date, 'YYYY-MM') AS month,
       COUNT(transaction_id) AS transaction_count,
       SUM(amount) AS total_amount
FROM transactions
GROUP BY month
ORDER BY month ASC;

-- 24. The operations team wants to contact customers who have never used their accounts.
-- Find customers who have no transactions in any of their accounts. Show first name and last name.
SELECT c.first_name, c.last_name FROM customers c
LEFT JOIN accounts a ON a.customer_id = c.customer_id
LEFT JOIN transactions t ON t.account_id = a.account_id
GROUP BY c.first_name, c.last_name
HAVING COUNT(transaction_id) = 0;

-- 25. Create a cash flow list combining all deposits (labelled 'Income') and all withdrawals (labelled 'Expense')
-- into one unified report. Show account_id, amount, flow_type, and transaction_date. Order by transaction_date.*/
SELECT account_id, amount,
	CASE WHEN transaction_type = 'Deposit' THEN 'Income'
		ELSE 'Expense' END AS flow_type,
		transaction_date
FROM transactions
ORDER BY transaction_date;

-- 26. Find the customer with the largest total active loan amount.
-- Show first name, last name, and total_loans. Only include Active loans.
SELECT c.first_name, c.last_name, SUM(l.loan_amount) as total_loans FROM customers c
JOIN loans l ON c.customer_id = l.customer_id
WHERE l.status = 'Active'
GROUP BY c.customer_id
ORDER BY total_loans DESC LIMIT 1;

-- 27. The wealth management team wants to identify accounts performing above their peer group.
-- Find accounts with a balance above the average balance for their account_type. Show account_id, account_type, balance, and customer name.*/
SELECT a.account_id, a.account_type, a.balance, c.first_name, c.last_name FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
WHERE a.balance > (select AVG(a2.balance) FROM accounts a2 WHERE a2.account_type = a.account_type)
ORDER BY a.account_id;

-- 28. Rank accounts by balance within each account type using a window function.
-- Show account_id, account_type, balance, and balance_rank. Order by account_type, then rank.*/
SELECT account_id, account_type, balance, RANK() OVER (PARTITION BY account_type ORDER BY balance DESC) AS balance_rank
FROM accounts
ORDER BY account_type, balance_rank;

-- 29. The branch management team wants to identify the top depositor at each location.
-- Find the customer with the highest total account balance in each branch. Show first name, last name, branch name, and total_balance.
SELECT first_name, last_name, branch_name, total_balance
FROM (
    SELECT c.first_name,
           c.last_name,
           b.branch_name,
           SUM(a.balance) AS total_balance,
           RANK() OVER (PARTITION BY b.branch_id ORDER BY SUM(a.balance) DESC) AS rn
    FROM customers c
    JOIN branches b ON b.branch_id = c.branch_id
    JOIN accounts a ON a.customer_id = c.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, b.branch_id, b.branch_name
) ranked
WHERE rn = 1
ORDER BY branch_name;

-- 30. The product team wants a breakdown of account distribution by balance tier.
-- Using a CTE, classify accounts into tiers: High (balance >= 10000), Medium (balance >= 3000), Low (below 3000).
-- Show each tier's account count, average balance, and total balance. Order by avg_balance descending.
WITH tiered_accounts AS (
    SELECT account_id,
           balance,
           CASE
               WHEN balance >= 10000 THEN 'High'
               WHEN balance >= 3000  THEN 'Medium'
               ELSE 'Low'
           END AS balance_tier
    FROM accounts
)
SELECT balance_tier,
       COUNT(account_id) AS account_count,
       AVG(balance) AS avg_balance,
       SUM(balance) AS total_balance
FROM tiered_accounts
GROUP BY balance_tier
ORDER BY avg_balance DESC;
