#Banking Key Performance Indicators (KPIs)
#Customer KPIs

Select count(customer_id) as Total_customers
from Customers;

Select monthname(created_at)as Created_month, count(customer_id) as New_Customers
from customers
where year(created_at)=2025
group by monthname(created_at)
order by Created_Month;

Select 
max(credit_score) as Highest_Credit_Score, 
min(credit_score) as Lowest_Credit_Score, 
avg(credit_Score) as Average_Credit_Score
from customers;

Select city, count(customer_id) as Number_of_customers
from customers
group by city
order by  Number_of_customers desc;

Select
case when credit_score>300 and credit_score<399 then 'Range between 300 to 400'
     when credit_score>400 and credit_score<499 then 'Range between 400 to 500'
	when credit_score>500 and credit_score<599 then 'Range between 500 to 600'
	when credit_score>600 and credit_score<699 then 'Range between 600 to 700'
	when credit_score>700 and credit_score<799 then 'Range between 700 to 800'
Else 'Range 800 and above 800'
End as Credit_score_range,
count(customer_id) as Total_customers
from customers
group by credit_score_range
order by Total_customers desc;

#Account KPIs
Select count(account_id) as Total_accounts
from accounts;

Select sum(balance_usd) as Total_Account_Balance
from accounts;

Select 
max(balance_usd) as Highest_Account_Balance, 
min(balance_usd) as Lowest_Account_Balance, 
avg(balance_usd) as Average_Account_Balance
from accounts;

Select account_type, count(account_id) as Total_accounts
from accounts
group by account_type;

Select account_type, avg(balance_usd) as Average_balance
from accounts
group by account_type;

#Transaction KPIs
Select count(transaction_id) as Total_transactions
from transactions;

Select sum(amount_usd) as Transaction_volume
 from transactions;
 
Select 
max(amount_usd) as Maximum_Transaction_Amount, 
min(amount_usd) as Minimum_Transaction_Amount, 
avg(amount_usd) as Average_Transaction_Amount
from transactions; 
Select *
from transactions;

Select monthname(transaction_date) as Month, 
       sum(amount_usd) as Monthly_Transaction_Volume
from transactions
group by Month
order by Monthly_Transaction_Volume desc;

Select Year(transaction_date) as Year, 
       sum(amount_usd) as Yearly_Transaction_Volume
from transactions
group by Year
order by Yearly_Transaction_Volume desc;

#Merchant KPIs
Select count(merchant_id) as Total_Merchants
from merchants;

select *
from transactions;

SELECT m.merchant_id, m.merchant_name, SUM(t.amount_usd) AS total_transaction_value
FROM merchants m
LEFT JOIN transactions t
    ON m.merchant_id = t.merchant_id
GROUP BY
    m.merchant_id,
    m.merchant_name
ORDER BY total_transaction_value DESC;

SELECT m.merchant_id, m.merchant_name, Avg(t.amount_usd) AS Average_transaction_value
FROM merchants m
LEFT JOIN transactions t
    ON m.merchant_id = t.merchant_id
GROUP BY
    m.merchant_id,
    m.merchant_name
ORDER BY Average_transaction_value DESC;

SELECT m.merchant_id, m.merchant_name as Top_performing_Merchants, SUM(t.amount_usd) AS total_transaction_value
FROM merchants m
LEFT JOIN transactions t
    ON m.merchant_id = t.merchant_id
GROUP BY
    m.merchant_id,
    Top_performing_Merchants
ORDER BY total_transaction_value DESC
Limit 10;

Select city, count(merchant_id)
from merchants
group by city;

 Select count(loan_id) as Total_loans
 from loans;
 
  Select 
  sum(loan_amount) as Total_loan_amount, 
  avg(loan_amount) as Average_Loan_Amount,
  avg(interest_rate) as Average_interest_rate, 
  max(loan_amount) as Highest_loan_amount,
  min(Loan_amount) as Lowest_Loan_Amount
 from loans;
 
 #Card KPIs
 Select count(card_id) as Total_cards_issued
 from cards;
 
 Select card_type, count(card_id) as Total_cards_issued
 from cards
 group by card_type;
 
 Select year(expiration_date), count(card_id) as "Number of Cards Expiring"
 from cards
 group by year(expiration_date)
 order by year(expiration_date);