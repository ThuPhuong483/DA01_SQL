--EX1:
SELECT DISTINCT(city) FROM station
WHERE id % 2 = 0 
--EX2:
SELECT 
COUNT(*) - COUNT(DISTINCT city)
FROM station 
----EX3: chưa học 
--EX4: 
SELECT 
--SUM(item_count*order_occurrences) AS Total_items,
--SUM(order_occurrences) AS Total_orders,
ROUND(
CAST(SUM(item_count*order_occurrences) AS numeric)/SUM(order_occurrences),1) AS Mean
FROM items_per_order
--EX5:
SELECT candidate_id
FROM candidates
WHERE skill = 'Python' OR skill = 'Tableau' OR skill = 'PostgreSQL'
GROUP BY candidate_id
HAVING COUNT(skill) = 3
ORDER BY candidate_id
--EX6:
SELECT user_id, 
(MAX(DATE(post_date))- MIN(DATE(post_date))) AS days_between
FROM posts
WHERE DATE(post_date) BETWEEN '2021-01-01' AND '2021-12-31'
GROUP BY user_id
HAVING COUNT(post_date) >= 2
--EX7: 
SELECT card_name,
(MAX(issued_amount) - MIN(issued_amount)) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC
--EX8:
SELECT manufacturer,
COUNT(drug) AS drug_count,
SUM(cogs - total_sales) AS total_loss
FROM pharmacy_sales
WHERE (cogs - total_sales) > 0
GROUP BY manufacturer
ORDER BY total_loss DESC
--EX9:
SELECT id, movie, description, rating 
FROM cinema
WHERE id % 2 != 0  AND description NOT LIKE 'boring'
ORDER BY rating DESC
--EX10:
SELECT teacher_id,
COUNT(DISTINCT subject_id) AS cnt
FROM teacher
GROUP BY teacher_id
--EX11:
SELECT user_id,
COUNT(follower_id) AS followers_count
FROM followers
GROUP BY user_id
ORDER BY user_id
--EX12:
SELECT class
FROM courses
GROUP BY class
HAVING COUNT(student) >= 5 

