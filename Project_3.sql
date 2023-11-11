/*1) Doanh thu theo từng ProductLine, Year  và DealSize?
Output: PRODUCTLINE, YEAR_ID, DEALSIZE, REVENUE*/
SELECT productline, year_id AS year, dealsize,
SUM(sales) AS revenue
FROM sales_dataset_rfm_prj
GROUP BY productline, year_id, dealsize
ORDER BY year_id
/*2) Đâu là tháng có bán tốt nhất mỗi năm?
Output: MONTH_ID, REVENUE, ORDER_NUMBER*/
SELECT a.month_id, a.revenue, a.ordernumber
FROM (SELECT year_id, month_id, ordernumber,
SUM(sales) AS revenue,
ROW_NUMBER() OVER(PARTITION BY year_id ORDER BY SUM(sales) DESC) AS stt
FROM sales_dataset_rfm_prj
GROUP BY year_id, month_id, ordernumber) AS a
WHERE a.stt=1
-----Tháng 10 năm 2003, tháng 10 năm 2004, tháng 3 năm 2005 là tháng bán tốt nhất 
/*3) Product line nào được bán nhiều ở tháng 11?
Output: MONTH_ID, REVENUE, ORDER_NUMBER*/
SELECT a.month_id, a.revenue, a.ordernumber
FROM (SELECT year_id, month_id, ordernumber, productline, SUM(sales) AS revenue,
ROW_NUMBER() OVER(PARTITION BY year_id ORDER BY SUM(sales) DESC) AS stt
FROM sales_dataset_rfm_prj
WHERE month_id=11
GROUP BY year_id, month_id, ordernumber, productline) AS a
WHERE a.stt =1 
----- Productline = Classic Cars được bán nhiều nhất ở tháng 11
/*4) Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm? 
Xếp hạng các các doanh thu đó theo từng năm.
Output: YEAR_ID, PRODUCTLINE,REVENUE, RANK*/
SELECT *,
RANK() OVER(ORDER BY b.revenue)
FROM (SELECT a.year_id, a.productline, a.revenue
FROM (SELECT year_id, productline, SUM(sales) AS revenue,
RANK() OVER(PARTITION BY year_id ORDER BY SUM(sales) DESC) AS stt
FROM sales_dataset_rfm_prj
WHERE country='UK'
GROUP BY year_id, productline) AS a
WHERE a.stt=1) AS b

/*5) Ai là khách hàng tốt nhất, phân tích dựa vào RFM 
(sử dụng lại bảng customer_segment ở buổi học 23)*/
WITH customer_rfm AS 
(SELECT 
contactfirstname || ' ' || contactlastname AS fullname,
current_date - MAX(DATE(orderdate)) AS R,
COUNT(DISTINCT ordernumber) AS F,
SUM(sales) AS M
FROM sales_dataset_rfm_prj
GROUP BY contactfirstname || ' ' || contactlastname),
rfm_score AS(
SELECT fullname,
ntile(5) OVER(ORDER BY R DESC) AS R_score,
ntile(5) OVER(ORDER BY F) AS F_score,
ntile(5) OVER(ORDER BY M DESC) AS M_score
FROM customer_rfm),
rfm_final AS(
SELECT fullname,
CAST(r_score AS varchar)||CAST(f_score AS varchar)||CAST(m_score AS varchar) AS rfm_score
FROM rfm_score)

SELECT *
FROM (SELECT a.fullname, b.segment, c.M
FROM rfm_final AS a 
JOIN segment_score AS b ON a.rfm_score=b.scores
JOIN customer_rfm AS c ON c.fullname=a.fullname) AS t
WHERE segment='Champions'
ORDER BY m DESC
LIMIT 1

