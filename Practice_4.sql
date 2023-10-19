--EX1:
SELECT 
SUM(CASE 
  WHEN device_type IN ('laptop') THEN 1 ELSE 0
END) AS laptop_views,
SUM(CASE 
  WHEN device_type IN ('tablet', 'phone') THEN 1 ELSE 0
END) AS mobile_views
FROM viewership

--EX2:
SELECT *,
CASE 
    WHEN (x+y)>z AND (x+z)>y AND (y+z)>x THEN 'Yes'
    ELSE 'No'
END AS triangle
FROM triangle

--EX3:(ko có dữ liệu)
SELECT 
ROUND((SUM(CASE
  WHEN call_category IS NULL OR call_category='N/A' THEN 1 ELSE 0
END)/COUNT(*))*100,1) ||'%'
FROM callers 

  --EX4:
SELECT name FROM customer 
WHERE referee_id IS null OR referee_id != 2

--EX5: (stratascratch)
SELECT 
CASE 
    WHEN survived = 0 THEN 0 ELSE 1
END AS passenger,
SUM(CASE 
    WHEN pclass = 1 THEN 1 ELSE 0
END) AS  first_class,
SUM(CASE 
    WHEN pclass = 2 THEN 1 ELSE 0
END) AS  second_class,
SUM(CASE 
    WHEN pclass = 3 THEN 1 ELSE 0
END) AS  third_class
FROM titanic
GROUP BY  passenger

