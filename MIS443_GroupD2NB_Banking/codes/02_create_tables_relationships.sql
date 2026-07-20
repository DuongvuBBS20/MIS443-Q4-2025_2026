-- MIS443 - Assignment 2: PostgreSQL Database Development and SQL Practice
-- Group: D2NB | Schema: Banking (SQL Practice Online)
-- File 02: Create Tables and Relationships

-- Table creation order follows the foreign-key dependency chain:
--   branches -> customers -> accounts -> transactions / loans

-- 1. Branches: stores information about each bank branch
CREATE TABLE branches (
    branch_id    INTEGER PRIMARY KEY,
    branch_name  VARCHAR(100),
    city         VARCHAR(50),
    state        VARCHAR(2)
);

-- 2. Customers: each customer belongs to exactly one branch
CREATE TABLE customers (
    customer_id          INTEGER PRIMARY KEY,
    first_name           VARCHAR(50),
    last_name            VARCHAR(50),
    email                VARCHAR(100),
    branch_id            INTEGER REFERENCES branches(branch_id),
    account_opened_date  DATE
);

-- 3. Accounts: each account belongs to exactly one customer
CREATE TABLE accounts (
    account_id    INTEGER PRIMARY KEY,
    customer_id   INTEGER REFERENCES customers(customer_id),
    account_type  VARCHAR(20),
    balance       REAL,
    opened_date   DATE
);

-- 4. Transactions: each transaction is tied to one account
CREATE TABLE transactions (
    transaction_id    INTEGER PRIMARY KEY,
    account_id        INTEGER REFERENCES accounts(account_id),
    transaction_type  VARCHAR(20),
    amount            REAL,
    transaction_date  DATE
);

-- 5. Loans: each loan is tied to one customer
CREATE TABLE loans (
    loan_id        INTEGER PRIMARY KEY,
    customer_id    INTEGER REFERENCES customers(customer_id),
    loan_amount    REAL,
    interest_rate  REAL,
    status         VARCHAR(20),
    start_date     DATE
);
