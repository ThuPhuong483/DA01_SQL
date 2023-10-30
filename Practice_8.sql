--EX1:
--EX2:
--EX3:
--EX4:
SELECT b.visited_on, b.amount,
ROUND(b.amount/7,2) AS average_amount 
FROM (SELECT a.visited_on, 
SUM(a.amount1) OVER(ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW ) AS amount
FROM (SELECT visited_on, SUM(amount) AS amount1
FROM Customer
GROUP BY visited_on) AS a) AS b
WHERE b.visited_on >= (SELECT min(visited_on) FROM Customer)+6

--EX5:


--EX6:
SELECT c.Department, c.name AS Employee, c.salary 
FROM (SELECT a.*, b.name AS Department,
DENSE_RANK() OVER(PARTITION BY b.name ORDER BY a.salary DESC) AS stt
FROM Employee AS a
JOIN Department AS b ON a.departmentId = b.id) AS c
WHERE c.stt < 4

--EX7:
SELECT a.person_name 
FROM (SELECT *,
SUM(weight) OVER(ORDER BY turn) AS sum_weight
FROM Queue 
ORDER BY turn ) AS a
WHERE a.sum_weight <= 1000
ORDER BY a.sum_weight DESC
LIMIT 1

--EX8: 
SELECT c.product_id, c.price
FROM (SELECT *,
RANK() OVER(PARTITION BY b.product_id ORDER BY b.price DESC) AS stt1
FROM (SELECT *
FROM (SELECT a.product_id, a.new_price AS price 
FROM (SELECT *,
RANK() OVER(PARTITION BY product_id ORDER BY change_date DESC) AS stt
FROM Products
WHERE change_date <= '2019-08-16') AS a
WHERE a.stt =1)
UNION 
SELECT * 
FROM(SELECT product_id, 10 AS price 
FROM Products 
WHERE change_date > '2019-08-16')) AS b) AS c
WHERE c.stt1 = 1
