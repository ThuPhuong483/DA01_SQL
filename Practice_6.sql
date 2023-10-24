--EX1:
SELECT COUNT(*) AS duplicate_companies
FROM (SELECT company_id, 
COUNT(job_id)  
FROM job_listings
GROUP BY company_id
HAVING COUNT(job_id)>1) AS A

--EX2:
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

--EX6:
--EX7:SELECT product_id, year AS first_year, quantity, price
FROM sales AS a
WHERE year = (select min(year) from sales
where product_id = a.product_id
group by product_id)

--EX8:
--EX9:
--EX10:
SELECT COUNT(*) AS duplicate_companies
FROM (SELECT company_id, 
COUNT(job_id)  
FROM job_listings
GROUP BY company_id
HAVING COUNT(job_id)>1) AS A
