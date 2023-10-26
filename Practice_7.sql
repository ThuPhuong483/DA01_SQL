--EX1:
SELECT to_char(DATE(transaction_date),'yyyy') AS year,
product_id, spend AS curr_year_spend,
LAG(spend) OVER(PARTITION BY product_id ORDER BY to_char(DATE(transaction_date),'yyyy')) AS prev_year_spend,
ROUND(((spend-LAG(spend) OVER(PARTITION BY product_id ORDER BY to_char(DATE(transaction_date),'yyyy')))/LAG(spend) 
OVER(PARTITION BY product_id ORDER BY to_char(DATE(transaction_date),'yyyy')))*100,2) AS yoy_rate
FROM user_transactions

--EX2:
SELECT a.card_name, a.issued_amount
FROM (SELECT *,
RANK() OVER(PARTITION BY card_name ORDER BY issue_year, issue_month ) AS stt
FROM monthly_cards_issued
ORDER BY card_name, issue_year, issue_month) AS a 
WHERE stt = 1
ORDER BY a.issued_amount DESC

--EX3:
SELECT a.user_id, a.spend, a.transaction_date
FROM (SELECT *, 
ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY DATE(transaction_date)) AS stt
FROM transactions
ORDER BY user_id, DATE(transaction_date)) AS a 
WHERE stt = 3

--EX4:
SELECT a.transaction_date, a.user_id, a.purchase_count
FROM (SELECT DATE(transaction_date) AS transaction_date, user_id,
COUNT(product_id) OVER(PARTITION BY user_id ORDER BY user_id, DATE(transaction_date) DESC) AS purchase_count,
ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY user_id, DATE(transaction_date) DESC) AS stt
FROM user_transactions) AS a
WHERE stt = 1
ORDER BY a.transaction_date , a.purchase_count 

--EX5:
--EX6:
--EX7:
SELECT b.category, b.product, b.sum_spend AS total_spend
FROM (SELECT a.category, a.product, a.sum_spend,
RANK() OVER(PARTITION BY category ORDER BY a.sum_spend DESC) AS stt
FROM (SELECT category, product,
SUM(spend) AS sum_spend
FROM product_spend
WHERE to_char(DATE(transaction_date),'yyyy') ='2022' 
GROUP BY category, product
ORDER BY category, product) AS a ) AS b
WHERE stt < 3

--EX8:
