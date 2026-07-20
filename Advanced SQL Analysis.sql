#Business Analysis tasks
#Task 1-Customer Portfolio Analysis

Select year(created_at) AS registration_year,
    monthname(created_at) AS registration_month,
    count(customer_id) AS total_registrations
From customers
group by year(created_at), monthname(created_at)
order by registration_year, monthname(created_at);
    
Select year(created_at) AS registration_year,
    Count(customer_id) AS new_customers,
    Sum(Count(customer_id)) OVER (order by year(created_at)) AS cumulative_customers
From customers
group by year(created_at)
order by registration_year;

#Task 2-Credit score analysis
Select
case when credit_score>=300 and credit_score<=399 then 'Poor(300 to 399)'
     when credit_score>=400 and credit_score<=499 then 'Fair(400 to 499)'
	when credit_score>=500 and credit_score<=599 then 'Good(500 to 599)'
	when credit_score>=600 and credit_score<=699 then 'Very good(600 to 699)'
	when credit_score>=700 and credit_score<=799 then 'Excellent(700 to 799)'
Else 'Exceptional (800 and above)'
End as Credit_score_segment,
count(customer_id) as Total_customers
from customers
group by credit_score_segment
order by Total_customers desc;

#Task 3-Account Performance Analysis
#Already completed in KPI task

#Task 4-Customer Balance Analysis
Select customer_id, balance_usd as Highest_balances
from accounts
order by Highest_balances desc
limit 5;

Select customer_id, round(avg(balance_usd),2) as Average_Balance
from accounts
group by customer_id;

Select customer_id, sum(balance_usd) as Total_balance
From accounts
group by customer_id;

Select customer_id, account_type,
dense_rank() over
(
partition by account_type 
order by balance_usd desc) 
as customer_rank
from accounts;

#Task 5
select *
from transactions;

#Daily Transaction activity
Select date(transaction_date) as Transaction_day, 
count(transaction_id) as Number_of_Transactions,
sum(amount_usd) as Total_transaction_amount
from transactions
group by date(transaction_date)
order by transaction_day;

#Monthly transaction trends
Select year(transaction_date) as Year, 
Month(transaction_date),
Monthname(transaction_date) as Month,
count(transaction_id) as Number_of_transactions,
sum(amount_usd) as Transaction_amount
from transactions
group by  year(transaction_date), 
Month(transaction_date),
Monthname(transaction_date)
order by year(transaction_date), 
Month(transaction_date);

#Yearly transaction trends
Select year(transaction_date) as Year, 
count(transaction_id) as Number_of_transactions,
sum(amount_usd) as Transaction_amount
from transactions
group by  year(transaction_date)
order by year;

#Task 6-Customer Transaction behaviour
#Total transaction value per customer
select a.customer_id, coalesce(sum(t.amount_usd),0)as Transaction_value
from accounts a
left join transactions t on a.account_id=t.account_id
group by a.customer_id
order by Transaction_value desc;

#Highest spending customers
select c.customer_id, 
c.first_name, c.last_name,
ct.amount_spent,
dense_rank() over (order by ct.amount_spent desc) as highest_spending_customer_rank
from customers c
join (select a.customer_id, sum(acc.account_spent) as amount_spent
    from accounts a
    join (select account_id, sum(amount_usd) as account_spent
        from transactions
        group by account_id
    ) acc
    on a.account_id = acc.account_id
    group by a.customer_id
) ct
on c.customer_id = ct.customer_id
order by amount_spent desc
limit 10;

#Task 7-Merchant Performance Analysis
#Total transactions received
select m.merchant_id,m.merchant_name, count(t.transaction_id)as Transaction_Received
from merchants m
left join transactions t on m.merchant_id=t.merchant_id
group by m.merchant_id
order by Transaction_Received desc;

Select m.merchant_id, m.merchant_name, 
coalesce(sum(t.amount_usd),0) as Transaction_value,
dense_rank() over (order by sum(t.amount_usd) DESC)as Merchant_Rank
from merchants m
inner join transactions t on m.merchant_id=t.merchant_id
group by m.merchant_id,m.merchant_name
limit 10;

#Task 8-Merchant city Analysis
Select city, count(merchant_id) as Number_of_Merchants
from merchants m
group by city
order by Number_of_Merchants desc
limit 10;

#Task 9-Loan portfolion Analysis
#Customer loan distribution
Select customer_id, count(loan_id) as Number_of_Loans
from loans
group by customer_id
order by Number_of_Loans desc;

#Highest loan values
Select loan_id, customer_id, loan_amount
from loans
order by loan_amount desc
limit 10;

#Task 10-Card portfolio Analysis
Select year(expiration_date) as Expiring_year,
monthname(expiration_date) as Expiration_Month_Name, 
count(card_id) as Expiring_cards
from cards
group by year(expiration_date),
month(expiration_date), 
monthname(expiration_date)
order by Expiring_year,month(expiration_date);

#Accounts owning multiple cards
Select account_id as Accounts, count(card_id) as Number_of_Cards
from cards
group by account_id
having count(card_id)>1
order by Number_of_Cards desc;

#Task 11 – Customer Loan Analysis
#Customers who have taken loans
Select distinct c.customer_id, c.first_name, c.last_name
from customers c
inner join loans l on c.customer_id=l.customer_id;

#Average loan amount per customer
Select c.customer_id, c.first_name, c.last_name, roun(avg(loan_amount),0) as Average_loan_amount
from customers c
inner join loans l on c.customer_id=l.customer_id
group by c.customer_id, c.first_name, c.last_name
order by average_loan_amount desc;

#Customers with multiple loans
Select c.customer_id,c.first_name, c.last_name, count(l.loan_id) as Number_of_loans
from loans l
inner join customers c on l.customer_id=c.customer_id
group by c.customer_id, c.first_name, c.last_name
having count(l.loan_id)>1
order by Number_of_loans desc;

#Highest loan amounts
Select loan_id,customer_id, loan_amount as Highest_loan_amounts,
dense_rank() over (order by loan_amount desc)
from loans
order by loan_amount desc
limit 10;

#Loan distribution across customer cities
Select c.city as Customer_cities, count(l.loan_id) as Number_of_loans
from loans l
inner join customers c on l.customer_id=c.customer_id
group by c.city
order by Number_of_loans desc;

#Interest rate comparison among customers
Select c.customer_id,c.first_name,c.last_name, round(avg(l.interest_rate),2)as Average_interest_rate
from loans l
inner join customers c on l.customer_id=c.customer_id
group by c.customer_id,c.first_name,c.last_name
order by Average_interest_rate desc;

#Task 12-Customer Banking Relationship Analysis
Select c.customer_id, c.first_name,c.last_name, count(a.account_id) as Number_of_accounts
from customers c
inner join accounts a on a.customer_id=c.customer_id
group by c.customer_id, c.first_name,c.last_name
having count(a.account_id)>1;

#Customers with multiple cards
Select c.customer_id, c.first_name,c.last_name, count(cd.card_id) as Number_of_cards
from customers c
inner join accounts a on a.customer_id=c.customer_id
inner join cards cd on a.account_id=cd.account_id
group by c.customer_id, c.first_name,c.last_name
having count(cd.card_id)>1;

#Customers having both accounts and loans
Select c.customer_id as Customers_having_both_accounts_and_laons, c.first_name,c.last_name
from customers c
inner join accounts a on c.customer_id=a.customer_id
inner join loans l on c.customer_id=l.customer_id
group by c.customer_id, c.first_name,c.last_name;

#Customer banking relationship summary
select
    c.customer_id,
    c.first_name,
    c.last_name,
    coalesce(a.number_of_accounts, 0) as number_of_accounts,
    coalesce(cd.number_of_cards, 0) as number_of_cards,
    coalesce(l.number_of_loans, 0) as number_of_loans,
    coalesce(t.number_of_transactions, 0) as number_of_transactions,
    coalesce(a.total_account_balance, 0) as total_account_balance,
case
        when l.number_of_loans > 0 then 'customer has loan/loans'
        else 'customer has no loans'
    end as customer_has_loan,

    case
        when cd.number_of_cards > 0 then 'customer has card/cards'
        else 'customer has no cards'
    end as customer_has_card
from customers c

left join
(select
        customer_id,
        count(account_id) as number_of_accounts,
        sum(balance_usd) as total_account_balance
    from accounts
    group by customer_id
) a
on c.customer_id = a.customer_id

left join
(select
        a.customer_id,
        count(cd.card_id) as number_of_cards
    from accounts a
    left join cards cd
        on a.account_id = cd.account_id
    group by a.customer_id
) cd
on c.customer_id = cd.customer_id

left join
(select
        customer_id,
        count(loan_id) as number_of_loans
    from loans
    group by customer_id
) l
on c.customer_id = l.customer_id
left join
(select
        a.customer_id,
        count(t.transaction_id) as number_of_transactions
    from accounts a
    inner join transactions t
        on a.account_id = t.account_id
    group by a.customer_id
) t
on c.customer_id = t.customer_id
order by c.customer_id;

#Task 13 – Transaction Trend Analysis
#Peak transaction months
Select Year(transaction_date), 
monthname(transaction_date) as Peak_Transaction_Month, 
sum(amount_usd) as Transaction_value
from transactions
group by Year(transaction_date), month(transaction_date),
monthname(transaction_date) 
order by transaction_value desc
limit 10;

#Lowest transaction months
Select Year(transaction_date), 
monthname(transaction_date) as Lowest_Transaction_Months, 
sum(amount_usd) as Transaction_value
from transactions
group by Year(transaction_date), month(transaction_date),
monthname(transaction_date) 
order by transaction_value asc
limit 10;

#Task 14 – Customer Lifetime Transaction Value
#Top customers by total transaction value
Select c.customer_id as Top_customers,c.first_name, c.last_name, 
sum(t.total_transaction_value) as Total_transaction_value,
dense_rank() over (order by sum(t.total_transaction_value) desc) as Customer_rank
from customers c
inner join accounts a on c.customer_id= a.customer_id
inner join (select account_id, 
sum(amount_usd) as Total_transaction_value
from transactions
group by account_id)t on a.account_id=t.account_id
group by c.customer_id, c.first_name, c.last_name
order by Total_transaction_value desc
limit 10;

with t as (select account_id, 
sum(amount_usd) as Total_transaction_value
from transactions
group by account_id)
Select c.customer_id as Top_customers,c.first_name, c.last_name, 
sum(t.total_transaction_value) as Total_transaction_value,
round ((sum(t.total_transaction_value)/(select sum(amount_usd) from transactions))*100,4) as Percentage_contribution_of_top_customers
from customers c
inner join accounts a on c.customer_id= a.customer_id
inner join t on a.account_id=t.account_id
group by c.customer_id, c.first_name, c.last_name
order by Total_transaction_value desc
limit 10;

select * from transactions;

#Task 15 – Account Type Performance Analysis
#Transaction frequency by account type
Select a.account_type, count(t.transaction_id) as Transaction_frequency
from accounts a
inner join transactions t on a.account_id=t.account_id
group by a.account_type
order by Transaction_frequency desc;

#Task 16 – Merchant Revenue Contribution Analysis
#Percentage contribution of each merchant
with t as (select merchant_id, 
sum(amount_usd) as Total_transaction_value
from transactions
group by merchant_id)
Select m.merchant_id as Top_Merchants,
t.total_transaction_value as Total_transaction_value,
round (((t.total_transaction_value)/(select sum(amount_usd) from transactions))*100,4) as Percentage_contribution_of_each_merchant
from merchants m
inner join t on m.merchant_id= t.merchant_id
order by Total_transaction_value desc;

#Task 17 – Card Usage Portfolio Analysis
#Customer card ownership
Select c.customer_id,c.first_name, c.last_name, count(cd.card_id) as Number_of_Cards
from cards cd
inner join accounts a on cd.account_id=a.account_id
inner join customers c on a.customer_id=c.customer_id
group by c.customer_id,c.first_name, c.last_name
order by Number_of_Cards desc;

#Task 18 – Customer Credit Portfolio Analysis
#Average account balance by credit score
Select
case when credit_score>=300 and credit_score<=599 then 'Very Poor(Less than 600)'
	when credit_score>=600 and credit_score<=649 then 'Poor(600 to 649)'
	when credit_score>=650 and credit_score<=699 then 'Fair(650 to 699)'
	when credit_score>=700 and credit_score<=749 then 'Good(700 to 749)'
Else 'Excellent (750 and above)'
End as Credit_score_segment,
avg(a.balance_usd)as Average_account_balance
from customers c
inner join accounts a on c.customer_id=a.customer_id
group by Credit_score_segment
order by Average_account_balance desc;

#Task 19 – Executive Banking Performance Summary
select
    (select count(*) from customers) as Total_customers,
    (select count(*) from accounts) as Total_accounts,
    (select count(*) from transactions) as Total_transactions,
    (select sum(balance_usd) from accounts) as Total_account_balance,
    (select sum(loan_amount) from loans) as Total_loan_amount,
    (select round(avg(credit_score),2) from customers) as Average_credit_score;
