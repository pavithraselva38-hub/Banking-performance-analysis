CREATE DATABASE Bank;
USE Bank;

CREATE TABLE customers(
 customer_id VARCHAR(20) PRIMARY KEY,
 first_name VARCHAR(50),
 last_name VARCHAR(50),
 email VARCHAR(100),
 city VARCHAR(50),
 credit_score INT,
 created_at DATETIME
);

CREATE TABLE accounts(
 account_id VARCHAR(20) PRIMARY KEY,
 customer_id VARCHAR(20),
 account_type VARCHAR(20),
 balance_usd DECIMAL(12,2),
 open_date DATE,
 FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE cards(
 card_id VARCHAR(20) PRIMARY KEY,
 account_id VARCHAR(20),
 card_type VARCHAR(20),
 expiration_date DATE,
 FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

CREATE TABLE merchants(
 merchant_id VARCHAR(20) PRIMARY KEY,
 merchant_name VARCHAR(100),
 city VARCHAR(50)
);

CREATE TABLE branches(
 branch_id VARCHAR(20) PRIMARY KEY,
 branch_name VARCHAR(100),
 manager_name VARCHAR(100)
);

CREATE TABLE loans(
 loan_id VARCHAR(20) PRIMARY KEY,
 customer_id VARCHAR(20),
 loan_amount DECIMAL(12,2),
 interest_rate DECIMAL(5,2),
 start_date DATE,
 FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE transactions(
 transaction_id VARCHAR(25) PRIMARY KEY,
 account_id VARCHAR(20),
 merchant_id VARCHAR(20),
 amount_usd DECIMAL(12,2),
 transaction_date DATETIME,
 FOREIGN KEY (account_id) REFERENCES accounts(account_id),
 FOREIGN KEY (merchant_id) REFERENCES merchants(merchant_id)
);

select * from customers;
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE transactions;
TRUNCATE TABLE cards;
TRUNCATE TABLE loans;
TRUNCATE TABLE accounts;
TRUNCATE TABLE customers;
TRUNCATE TABLE merchants;
TRUNCATE TABLE branches;

SELECT COUNT(*) FROM transactions;
SET FOREIGN_KEY_CHECKS = 1;

DESCRIBE customers;

SHOW VARIABLES LIKE 'local_infile';
SELECT VERSION();


LOAD DATA LOCAL INFILE 'C:/Users/premc/Documents/GUVI class-BMAI/PROJECT/Final project/Data/customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/premc/Documents/GUVI class-BMAI/PROJECT/Final project/Data/merchants.csv'
INTO TABLE merchants
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/premc/Documents/GUVI class-BMAI/PROJECT/Final project/Data/branches.csv'
INTO TABLE branches
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/premc/Documents/GUVI class-BMAI/PROJECT/Final project/Data/accounts.csv'
INTO TABLE accounts
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/premc/Documents/GUVI class-BMAI/PROJECT/Final project/Data/cards.csv'
INTO TABLE cards
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/premc/Documents/GUVI class-BMAI/PROJECT/Final project/Data/loans.csv'
INTO TABLE loans
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM merchants;
SELECT COUNT(*) FROM branches;
SELECT COUNT(*) FROM accounts;
SELECT COUNT(*) FROM cards;
SELECT COUNT(*) FROM loans;
SELECT COUNT(*) FROM transactions;

#Data Validation
SELECT customer_id,count(*)
FROM Customers
GROUP BY customer_id
HAVING count(*)>1;

SELECT account_id,count(*)
FROM accounts
GROUP BY account_id
HAVING count(*)>1;

SELECT card_id,count(*)
FROM cards
GROUP BY card_id
HAVING count(*)>1;

SELECT 	loan_id,count(*)
FROM loans
GROUP BY loan_id
HAVING count(*)>1;

SELECT transaction_id,count(*)
FROM transactions
GROUP BY transaction_id
HAVING count(*)>1;

SELECT merchant_id,count(*)
FROM merchants
GROUP BY merchant_id
HAVING count(*)>1;

SELECT a.account_id, a.customer_id
FROM accounts a
LEFT JOIN customers c
ON a.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT c.account_id, c.card_id
FROM cards c
LEFT JOIN accounts a
ON a.account_id = c.account_id
WHERE a.account_id IS NULL;

SELECT l.loan_id, l.customer_id
FROM loans l
LEFT JOIN customers c
ON l.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT t.transaction_id, t.account_id
FROM transactions t
LEFT JOIN accounts a
ON t.account_id = a.account_id
WHERE a.account_id IS NULL;

SELECT t.transaction_id, t.merchant_id
FROM transactions t
LEFT JOIN merchants m
ON t.merchant_id = m.merchant_id
WHERE m.merchant_id IS NULL;

#Data Quality Assessment

#Customers
SELECT Email
FROM customers
where Email is NULL;

SELECT Email
FROM customers
where Email='';


SELECT Email
FROM customers
where Email NOT LIKE'%@%.%';

SELECT customer_id, email, city, count(email)
FROM customers
group by customer_id,email, city
having count(email)>1;


SELECT city
FROM customers
where city is NULL;

SELECT city
FROM customers
where city='';

SELECT *
FROM customers
WHERE TRIM(city) = '';

Select distinct city
from customers
order by city;

SELECT *
FROM customers
WHERE credit_score<300
OR credit_score>850;

SELECT *
FROM customers
WHERE credit_score is NULL;

SELECT *
FROM customers
where created_at IS NULL;

SELECT *
FROM customers
where TRIM(created_at)='';

SELECT *
FROM customers
WHERE created_at>NOW();

SELECT min(created_at), max(created_at)
FROM customers;

#Accounts
Select distinct account_type
from Accounts;

Select *
from accounts
where account_type is NULL;

Select *
from accounts
where account_type='';

Select *
from accounts
where balance_usd is NULL;

Select *
from accounts
where TRIM(balance_usd)='';

Select *
from accounts
where balance_usd<0;

SELECT
MIN(balance_usd),
MAX(balance_usd)
FROM accounts;

SELECT *
FROM accounts
where open_date IS NULL;

SELECT *
FROM accounts
where TRIM(open_date)='';

SELECT *
FROM accounts
WHERE open_date>NOW();


Select min(open_date), max(open_date)
from accounts;

#cards
SELECT DISTINCT Card_type
from cards;

Select *
from cards
where card_type is NULL;

Select *
from cards
where TRIM(card_type)='';

Select *
from cards
where expiration_date is NULL;

Select *
from cards
where TRIM(expiration_date)='';

Select count(expiration_date)
from cards
where expiration_date<CURDATE();

Select *
from cards
where expiration_date<CURDATE();

Select 
Case 
when expiration_date<CURDATE() then 'Expired'
else 'Active'
end as Card_status,
count(*) as Total_cards
from cards
group by card_status;

#merchants

Select *
from merchants
where merchant_name is NULL;

Select *
from merchants
where merchant_name='';

Select merchant_name,city, count(*)
From merchants
group by merchant_name, city
having count(*)>1;

Select *
from merchants
where trim(city)='';

Select *
from merchants
where city is NULL;

Select city, count(*)
from merchants
group by city;

Select *
from loans
where loan_amount is NULL;

Select *
from loans
where trim(loan_amount)='';

Select loan_amount
from loans
where loan_amount<=0;

Select max(loan_amount), min(loan_amount)
from loans;

Select *
from loans
where interest_rate<=0;

Select *
from loans
where interest_rate>100;

Select min(interest_rate), max(interest_rate)
from loans;

Select start_date
from loans
where start_date>curdate();

Select MIN(start_date), MAX(start_date)
from loans;

Select start_date
from loans
where start_date is NULL;

Select start_date
from loans
where trim(start_date)='';

#Transactions
select *
from transactions;

Select amount_usd
from transactions
where amount_usd<=0;

Select amount_usd
from transactions
where amount_usd is NULL;

Select amount_usd
from transactions
where TRIM(amount_usd)='';

Select min(amount_usd),max(amount_usd),avg(amount_usd)
FROM transactions;

Select transaction_date
from transactions
where transaction_date>now();

Select transaction_date
from transactions
where transaction_date is NULL;

Select transaction_date
from transactions
where trim(transaction_date)='';

#Data consistency checks
Select a.account_id, a.customer_id
from accounts a
left join customers c on a.customer_id=c.customer_id
where c.customer_id is NULL;

Select * 
FROM transactions;

Select t.transaction_id, t.account_id
from transactions t
left join accounts a on t.account_id=a.account_id
where a.account_id is NULL;

Select t.transaction_id, t.merchant_id
from transactions t
left join merchants m on t.merchant_id=m.merchant_id
where m.merchant_id is NULL;

Select c.card_id, c.account_id
from cards c
left join accounts a on c.account_id=a.account_id
where a.account_id is NULL;

Select l.loan_id, l.customer_id
from loans l
left join customers c on l.customer_id=c.customer_id
where c.customer_id is NULL;