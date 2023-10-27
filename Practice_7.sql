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
SELECT P.user_id, P.tweet_date, 
CASE 
  WHEN P.previous1 = 0 AND P.previous2 = 0 THEN ROUND(P.tweet_count,2)
  WHEN P.previous1 <> 0 AND P.previous2 = 0 THEN ROUND((P.tweet_count + P.previous1)/2,2)
  WHEN P.previous1 <> 0 AND P.previous2 <> 0 THEN ROUND((P.tweet_count + P.previous1 + P.previous2)/3,2)
END AS rolling_avg_3d
FROM (SELECT T.user_id, T.tweet_date, CAST(T.tweet_count AS numeric),
COALESCE(CAST(T.a AS numeric), 0) AS previous1,
COALESCE(CAST(T.b AS numeric), 0) AS previous2
FROM (SELECT *,
LAG(tweet_count) OVER(PARTITION BY user_id ORDER BY tweet_date) AS a,
LAG(tweet_count,2) OVER(PARTITION BY user_id ORDER BY tweet_date) AS b
FROM tweets ) AS T) AS P
  
--EX6:
SELECT 
COUNT(c.time)  AS payment_count
FROM (SELECT *,
EXTRACT(DAY FROM a.transaction_timestamp - a.previous)*24 + 
EXTRACT(HOUR FROM a.transaction_timestamp - a.previous)*60+
EXTRACT(MINUTE FROM a.transaction_timestamp - a.previous) AS time
FROM  (SELECT *, 
LAG(transaction_timestamp) 
OVER(PARTITION BY merchant_id, credit_card_id, amount ORDER BY transaction_timestamp ) AS previous
FROM transactions) AS a 
WHERE a.previous IS NOT NULL) AS c
WHERE c.time <=10
  
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
SELECT P.artist_name, P.artist_rank
FROM (SELECT T.artist_name,
DENSE_RANK() OVER(ORDER BY T.count_rank DESC) AS artist_rank 
FROM (SELECT a.artist_name,
COUNT(rank) AS count_rank
FROM artists AS a
JOIN songs AS b ON a.artist_id = b.artist_id
JOIN global_song_rank AS c ON b.song_id = c.song_id
WHERE rank <=10
GROUP BY a.artist_name
ORDER BY  COUNT(rank) DESC) AS T) AS P
WHERE P.artist_rank <=5
