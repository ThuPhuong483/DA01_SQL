--EX1:
SELECT name FROM students
WHERE marks > 75
ORDER BY (RIGHT(name,3)) ASC, ID ASC
--EX2:
SELECT user_id, 
CONCAT(UPPER(LEFT(name,1)),LOWER(RIGHT(name, length(name)-1))) AS name
FROM users
--EX3:
SELECT manufacturer,
'$'||ROUND(SUM(total_sales)/1000000,0) || ' ' || 'million' AS sale
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC
--EX4:
SELECT 
extract(month FROM submit_date) AS mth,
product_id AS product,
ROUND(AVG(stars),2) AS avg_stars
FROM reviews
GROUP BY extract(month FROM submit_date), product_id
ORDER BY extract(month FROM submit_date), product_id
--EX5:
SELECT sender_id,
COUNT(receiver_id) AS message_count
FROM messages
WHERE to_char(sent_date,'yyyy-mm') = '2022-08'
GROUP BY sender_id
ORDER BY COUNT(receiver_id) DESC
LIMIT 2 
--EX6:
SELECT tweet_id
FROM tweets
WHERE length(content) > 15
--EX7:
SELECT 
activity_date AS day,
COUNT(DISTINCT user_id) AS active_users
FROM activity
WHERE CAST(activity_date AS DATE) > '2019-06-27'
AND CAST(activity_date AS DATE) < '2019-07-28'
GROUP BY CAST(activity_date AS DATE)
--EX8: (stratascratch)
SELECT COUNT(*) 
FROM employees
WHERE to_char(joining_date, 'yyyy-mm-dd') > '2022-01-14'
AND to_char(joining_date, 'yyyy-mm-dd') < '2022-07-16'
--EX9: (stratascratch)
SELECT POSITION('a' IN first_name) 
FROM worker
WHERE first_name ='Amitah'
--EX10: (stratascratch)
SELECT 
SUBSTRING(title FROM POSITION(' ' IN title)+ 1 FOR 4) AS year,
SUBSTRING(title FROM 1 FOR POSITION(' ' IN title)-1) || ' ' || 
SUBSTRING(title FROM POSITION(' ' IN title)+ 6)
AS title
from winemag_p2
WHERE country = 'Macedonia'
FIX:
select id,
SUBSTRING(title FROM POSITION(' ' IN title)+ 1 FOR 4) AS year 
from winemag_p2 
where country ='Macedonia'

