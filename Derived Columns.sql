#Derived columns
SELECT
    customer_id,
    YEAR(created_at) AS Customer_Registration_Year
FROM customers;

SELECT
    customer_id,
    MONTHNAME(created_at) AS Customer_Registration_Month
FROM customers;

SELECT
    account_id,
    YEAR(open_date) AS Account_Opening_Year
FROM accounts;

SELECT
    account_id,
    MONTHNAME(open_date) AS Account_Opening_Month
FROM accounts;

SELECT
    transaction_id,
    YEAR(transaction_date) AS Transaction_Year
FROM transactions;

SELECT
    transaction_id,
    QUARTER(transaction_date) AS Transaction_Quarter
FROM transactions;

SELECT
    transaction_id,
    MONTHNAME(transaction_date) AS Transaction_Month
FROM transactions;

SELECT
    transaction_id,
    DAY(transaction_date) AS Transaction_Day
FROM transactions;

SELECT
    transaction_id,
    DAYNAME(transaction_date) AS Transaction_Weekday
FROM transactions;

SELECT
    loan_id,
    YEAR(start_date) AS Loan_Start_Year
FROM loans;

SELECT
    loan_id,
    MONTHNAME(start_date) AS Loan_Start_Month
FROM loans;