--EX1:
SELECT country.continent, 
FLOOR(AVG(city.population)) 
FROM city  
JOIN country 
ON city.countrycode = country.code 
GROUP BY country.continent

--EX2:
SELECT 
ROUND(CAST(SUM(CASE
  WHEN texts.signup_action = 'Confirmed' THEN 1 ELSE 0
END) AS numeric)/COUNT(texts.*),2)
FROM emails
JOIN texts 
ON emails.email_id = texts.email_id

--EX3:
SELECT age_bucket,
ROUND(SUM(CASE 
  WHEN activity_type='send' THEN time_spent ELSE 0 
END)/(SUM(CASE 
  WHEN activity_type='open' THEN time_spent ELSE 0 
END) + SUM(CASE 
  WHEN activity_type='send' THEN time_spent ELSE 0 
END))*100,2) AS send_perc,

ROUND(SUM(CASE 
  WHEN activity_type='open' THEN time_spent ELSE 0 
END)/(SUM(CASE 
  WHEN activity_type='open' THEN time_spent ELSE 0 
END) + SUM(CASE 
  WHEN activity_type='send' THEN time_spent ELSE 0 
END))*100,2) AS open_perc
FROM age_breakdown
LEFT JOIN activities
ON age_breakdown.user_id = activities.user_id
GROUP BY age_bucket
ORDER BY age_bucket

--EX4: no data
--EX5:

--EX6:
SELECT product_name, SUM(unit) AS unit
FROM products
JOIN orders 
ON products.product_id = orders.product_id
WHERE extract(Month FROM order_date) = '02' 
AND extract(Year FROM order_date) = '2020'
GROUP BY products.product_id, product_name
HAVING SUM(unit)>=100

--EX7:
SELECT pages.page_id 
FROM pages
LEFT JOIN page_likes
ON page_likes.page_id = pages.page_id
WHERE liked_date IS NULL 
ORDER BY pages.page_id 
