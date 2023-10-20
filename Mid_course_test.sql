--QUESTION 1:
SELECT DISTINCT replacement_cost
FROM film 
ORDER BY replacement_cost
LIMIT 1 

--QUESTION 2:
SELECT 
SUM(CASE
   WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 1 ELSE 0
END) AS Low
FROM film 

--QUESTION 3:
SELECT name, length 
FROM category
LEFT JOIN film_category
ON category.category_id = film_category.category_id
LEFT JOIN film 
ON film.film_id = film_category.film_id
WHERE name IN ('Drama', 'Sports')
ORDER BY length DESC
LIMIT 1 

--QUESTION 4:
SELECT name, COUNT(title)
FROM category
LEFT JOIN film_category
ON category.category_id = film_category.category_id
LEFT JOIN film 
ON film.film_id = film_category.film_id
GROUP BY name
ORDER BY COUNT(title) DESC
LIMIT 1 

--QUESTION 5:
SELECT first_name || ' ' || last_name, COUNT(title) 
FROM actor
LEFT JOIN film_actor 
ON actor.actor_id = film_actor.actor_id
LEFT JOIN film 
ON film.film_id = film_actor.film_id 
GROUP BY first_name || ' ' || last_name
ORDER BY COUNT(title) DESC 
LIMIT 1 

--QUESTION 6:
SELECT 
SUM(CASE
   WHEN customer_id IS NULL THEN 1 ELSE 0
END )
FROM customer
RIGHT JOIN address
ON customer.address_id = address.address_id

--QUESTION 7:
SELECT city, SUM(amount)
FROM city
LEFT JOIN address ON city.city_id = address.city_id
LEFT JOIN customer ON customer.address_id = address.address_id
LEFT JOIN payment ON customer.customer_id = payment.customer_id
WHERE amount IS NOT NULL
GROUP BY city
ORDER BY SUM(amount) DESC
LIMIT 1

--QUESTION 8:
SELECT city, country, SUM(amount)
FROM city
LEFT JOIN country ON city.country_id = country.country_id
LEFT JOIN address ON city.city_id = address.city_id
LEFT JOIN customer ON customer.address_id = address.address_id
LEFT JOIN payment ON customer.customer_id = payment.customer_id
WHERE amount IS NOT NULL
GROUP BY city, country
ORDER BY SUM(amount) 
LIMIT 1



