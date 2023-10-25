--EX1:
SELECT COUNT(*) AS duplicate_companies
FROM (SELECT company_id, 
COUNT(job_id)  
FROM job_listings
GROUP BY company_id
HAVING COUNT(job_id)>1) AS A

----EX2: em ko biết query to identify the top two highest-grossing products 
SELECT category, product, SUM(spend) AS total_spend
FROM product_spend
WHERE to_char(DATE(transaction_date), 'yyyy') = '2022'
GROUP BY category, product
ORDER BY category, SUM(spend) DESC

--EX3:
SELECT COUNT(*) AS member_count
FROM (SELECT policy_holder_id, 
COUNT(call_category)
FROM callers
WHERE call_category IS NOT NULL 
GROUP BY policy_holder_id
HAVING COUNT(call_category)>=3
) AS a 

--EX4: 
SELECT page_id
FROM pages AS a
WHERE page_id NOT IN (select page_id from page_likes)

--EX5:
WITH twt_user_actions AS
(SELECT user_id, event_type, event_date 
  FROM user_actions
  WHERE event_type IN ('sign-in', 'like', 'comment')
  AND extract(month FROM event_date)='06'
)
SELECT 7 AS month,
COUNT(DISTINCT a.user_id) AS monthly_active_users
FROM user_actions AS a 
INNER JOIN twt_user_actions AS b
ON a.user_id = b.user_id
WHERE extract(month FROM a.event_date)='07'

-----EX6:
SELECT to_char(trans_date, 'yyyy-mm') AS month, country,
COUNT(id) AS trans_count,
SUM(CASE
    WHEN state = 'approved' THEN 1 ELSE 0
END) AS approved_count, 
SUM(amount) AS trans_total_amount, 
SUM(CASE
    WHEN state = 'approved' THEN amount ELSE 0
END) AS approved_total_amount  
FROM Transactions AS a 
GROUP BY to_char(trans_date, 'yyyy-mm'), country
  
--EX7:
SELECT product_id, year AS first_year, quantity, price
FROM sales AS a
WHERE year = (select min(year) from sales
where product_id = a.product_id
group by product_id)

-----EX8:
SELECT customer_id FROM (select customer_id, count(distinct product_key) as num
from Customer
group by customer_id) AS a
WHERE a.num = (select count(distinct product_key) from product)

--EX9:
SELECT emp.employee_id
FROM employees  AS emp
LEFT JOIN employees AS mng
ON mng.employee_id = emp.manager_id
WHERE emp.salary < 30000 AND emp.manager_id IS NOT NULL
AND mng.employee_id IS NULL
ORDER BY emp.employee_id
  
--EX10:
SELECT COUNT(*) AS duplicate_companies
FROM (SELECT company_id, 
COUNT(job_id)  
FROM job_listings
GROUP BY company_id
HAVING COUNT(job_id)>1) AS A

--EX11:
SELECT * FROM (SELECT name AS results
FROM users
LEFT JOIN movierating ON users.user_id = movierating.user_id 
GROUP BY users.user_id, name 
ORDER BY COUNT(movie_id) DESC, name
LIMIT 1 )
UNION ALL
SELECT * FROM (SELECT title
FROM movies 
LEFT JOIN movierating ON movies.movie_id = movierating.movie_id
WHERE to_char(created_at, 'yyyy-mm') = '2020-02'
GROUP BY movies.movie_id, title
ORDER BY avg(rating) DESC, title
LIMIT 1)
  
--EX12:
SELECT requester_id AS id , COUNT(requester_id) AS num
FROM (SELECT requester_id FROM RequestAccepted 
UNION ALL 
SELECT accepter_id  FROM RequestAccepted
ORDER BY requester_id)
GROUP BY requester_id
ORDER BY num DESC
LIMIT 1 

