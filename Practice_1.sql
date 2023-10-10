--EX1:
SELECT name FROM city 
WHERE countrycode="USA" AND population>120000
--EX2:
SELECT * FROM city 
WHERE countrycode="JPN" 
--EX3:
SELECT city, state FROM station
--EX4:
SELECT city FROM station 
WHERE city LIKE 'A%' OR city LIKE 'E%' OR city LIKE 'I%' OR city LIKE 'O%' OR city LIKE 'U%'
--EX5:
SELECT DISTINCT city FROM station 
WHERE (city LIKE '%A' OR city LIKE '%E' OR city LIKE '%I' OR city LIKE '%O' OR city LIKE'%U')
--EX6:
SELECT DISTINCT city FROM station 
WHERE city NOT LIKE 'A%' AND city NOT LIKE 'E%' AND city NOT LIKE 'I%' AND city NOT LIKE 'U%' AND city NOT LIKE 'O%'
--EX7:
SELECT name FROM employee
ORDER BY name ASC
--EX8:
SELECT name FROM employee
WHERE months<10 AND salary>2000 
ORDER BY employee_id ASC
--EX9:
SELECT product_id FROM products
WHERE low_fats = 'Y' AND recyclable = 'Y'
--EX10:
SELECT name FROM customer
WHERE referee_id !=2 OR referee_id is null
--EX11:
SELECT name, population, area FROM world
WHERE area >= 3000000 OR population >= 25000000
----EX12:
SELECT DISTINCT author_id FROM views
WHERE author_id = viewer_id
ORDER BY viewer_id ASC
--EX13:
SELECT part, assembly_step FROM parts_assembly
WHERE finish_date IS NULL
--EX14:
SELECT * FROM lyft_drivers
WHERE yearly_salary <= 30000 OR yearly_salary >= 70000
----EX15: 
SELECT * FROM uber_advertising
WHERE year='2019' AND money_spent>100000



