--EX1:
SELECT DISTINCT(city) FROM station
WHERE id % 2 = 0 
--EX2:
SELECT 
COUNT(*) - COUNT(DISTINCT city)
FROM station 
----EX3: chưa học 
----EX4: chưa làm tròn được 
SELECT 
SUM(item_count*order_occurrences) AS Total_items,
SUM(order_occurrences) AS Total_orders,
SUM(item_count*order_occurrences)/SUM(order_occurrences) AS Mean
FROM items_per_order
--EX5:
SELECT candidate_id
FROM candidates
WHERE skill = 'Python' OR skill = 'Tableau' OR skill = 'PostgreSQL'
GROUP BY candidate_id
HAVING COUNT(skill) = 3
ORDER BY candidate_id
--EX6:

