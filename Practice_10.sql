/*1. Số lượng đơn hàng và số lượng khách hàng mỗi tháng
Thống kê tổng số lượng người mua và số lượng đơn hàng đã hoàn thành mỗi tháng ( Từ
1/2019-4/2022)
Output: month_year (yyyy-mm) , total_user, total_orde*/

SELECT p.dmyy AS year_month,
SUM(p.total_orde) AS total_orde,
COUNT(p.id) AS total_user
FROM (SELECT t.id AS id, t.num_of_item AS total_orde, LEFT(CAST(t.dmy AS string),7) AS dmyy 
FROM (SELECT id, num_of_item, CAST(shipped_at AS DATE) AS dmy
FROM bigquery-public-data.thelook_ecommerce.users AS a
JOIN bigquery-public-data.thelook_ecommerce.orders AS b 
ON a.id=b.user_id
WHERE status='Complete') AS t
WHERE LEFT(CAST(t.dmy AS string),7) BETWEEN '2019-01' AND '2022-04'
) AS p 
GROUP BY p.dmyy
ORDER BY p.dmyy

/* Insight là gì? 
--->Tìm ra xem trong các năm thì tháng nào có số đơn hàng và số khách hàng nhiều nhất 
từ đó họ biết mà nhập hàng để đáp ứng được nhu cầu của KH đồng thời gia tăng doanh thu cho họ, 
còn những tháng của năm nào có số đơn hàng và số khách hàng thấp thì họ sẽ tìm hiểu nguyên nhân để khắc phục trong tương lai hoặc 
hạn chế nhập hàng vào các tháng này trong tương lai để hạn chế tồn kho*/


/*2. Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng
Thống kê giá trị đơn hàng trung bình và tổng số người dùng khác nhau mỗi tháng( Từ 1/2019-4/2022)
Output: month_year ( yyyy-mm), distinct_users, average_order_value
Hint: Giá trị đơn hàng lấy trường sale_price từ bảng order_items
giá trị đơn hàng trung bình = tổng giá trị đơn hàng trong tháng/số lượng đơn hàng*/

SELECT p.dmyy AS year_month,
COUNT(DISTINCT p.id) AS distinct_users,
ROUND(SUM(p.sale_price)/COUNT(p.num_of_item),2) AS average_order_value
FROM (SELECT d.id, d.sale_price, d.num_of_item, LEFT(CAST(d.dmy AS string),7) AS dmyy 
FROM (SELECT a.id, sale_price, num_of_item, CAST(c.shipped_at AS DATE) AS dmy
FROM bigquery-public-data.thelook_ecommerce.users AS a
JOIN bigquery-public-data.thelook_ecommerce.order_items AS b 
ON a.id=b.user_id
JOIN c.status='Complete') AS d
WHERE LEFT(CAST(d.dmy AS string),7) BETWEEN '2019-01' AND '2022-04') AS p
GROUP BY p.dmyy
ORDER BY p.dmyy

/*Insight là gì? ( nhận xét về sự tăng giảm theo thời gian)
---> Để cho các manager biết được doanh nghiệp của họ mỗi tháng nhận được doanh thu là bao nhiêu trên một đơn hàng */


/*3. Nhóm khách hàng theo độ tuổi
Tìm các khách hàng có trẻ tuổi nhất và lớn tuổi nhất theo từng giới tính ( Từ 1/2019-4/2022)
Output: first_name, last_name, gender, age, tag (hiển thị youngest nếu trẻ tuổi nhất, oldest
nếu lớn tuổi nhất)
Hint: Sử dụng UNION các KH tuổi trẻ nhất với các KH tuổi trẻ nhất
tìm các KH tuổi trẻ nhất và gán tag ‘youngest’
tìm các KH tuổi trẻ nhất và gán tag ‘oldest’
Insight là gì? (Trẻ nhất là bao nhiêu tuổi, số lượng bao nhiêu? Lớn nhất là bao nhiêu tuổi, số
lượng bao nhiêu)
Note: Lưu output vào temp table rồi đếm số lượng tương ứng*/

--- Các khách hàng có trẻ tuổi nhất và lớn tuổi nhất theo từng giới tính ( Từ 1/2019-4/2022)
SELECT *
FROM (SELECT first_name, last_name, gender, age, 'youngest' AS tag
FROM bigquery-public-data.thelook_ecommerce.users
WHERE LEFT(CAST(created_at AS string),7) BETWEEN '2019-01' AND '2022-04'
AND age = (SELECT MIN(age)
FROM bigquery-public-data.thelook_ecommerce.users
WHERE LEFT(CAST(created_at AS string),7) BETWEEN '2019-01' AND '2022-04')) AS a
UNION ALL
SELECT *
FROM  (SELECT first_name, last_name, gender, age, 'oldest' AS tag 
FROM bigquery-public-data.thelook_ecommerce.users
WHERE LEFT(CAST(created_at AS string),7) BETWEEN '2019-01' AND '2022-04'
AND age = (SELECT MAX(age)
FROM bigquery-public-data.thelook_ecommerce.users
WHERE LEFT(CAST(created_at AS string),7) BETWEEN '2019-01' AND '2022-04')) AS b
  ---MIN(age) của Gender=F or gender=M đều là 12
  ---MAX(age) của Gender=F or gender=M đều là 70
--- Tạo bảng tạm thời 
CREATE TEMP TABLE temp_count AS 
(SELECT *
FROM (SELECT first_name, last_name, gender, age, 'youngest' AS tag
FROM bigquery-public-data.thelook_ecommerce.users
WHERE LEFT(CAST(created_at AS string),7) BETWEEN '2019-01' AND '2022-04'
AND age = (SELECT MIN(age)
FROM bigquery-public-data.thelook_ecommerce.users
WHERE LEFT(CAST(created_at AS string),7) BETWEEN '2019-01' AND '2022-04')) AS a
UNION ALL
SELECT *
FROM  (SELECT first_name, last_name, gender, age, 'oldest' AS tag 
FROM bigquery-public-data.thelook_ecommerce.users
WHERE LEFT(CAST(created_at AS string),7) BETWEEN '2019-01' AND '2022-04'
AND age = (SELECT MAX(age)
FROM bigquery-public-data.thelook_ecommerce.users
WHERE LEFT(CAST(created_at AS string),7) BETWEEN '2019-01' AND '2022-04')) AS b);
--- Đếm số lượng người già và người trẻ 
SELECT count(tag) AS so_ng_tre_nhat, count(*)
FROM temp_count
WHERE tag ='youngest' --- có 1109 người trẻ nhất

SELECT count(tag) AS so_ng_gia_nhat, count(*)
FROM temp_count
WHERE tag ='oldest' --- có 1145 người già nhất

/*4.Top 5 sản phẩm mỗi tháng.
Thống kê top 5 sản phẩm có lợi nhuận cao nhất từng tháng (xếp hạng cho từng sản phẩm).
Output: month_year ( yyyy-mm), product_id, product_name, sales, cost, profit,
rank_per_month
Hint: Sử dụng hàm dense_rank()*/

SELECT *
FROM (SELECT p.dmyy AS year_month, p.id AS product_id, p.name AS product_name,
ROUND(SUM(p.retail_price),2) AS sales, ROUND(SUM(p.cost),2) AS cost, ROUND(SUM(p.retail_price)-SUM(p.cost),2) AS profit,
DENSE_RANK() OVER(PARTITION BY p.dmyy ORDER BY SUM(p.retail_price)-SUM(p.cost) DESC) AS rank_per_month
FROM (SELECT d.id AS id, d.name, d.retail_price, d.cost, LEFT(CAST(d.dmy AS string),7) AS dmyy 
FROM (SELECT c.id, c.name, c.retail_price, c.cost, CAST(b.shipped_at AS DATE) AS dmy
FROM bigquery-public-data.thelook_ecommerce.order_items AS a 
JOIN bigquery-public-data.thelook_ecommerce.orders AS b
ON a.order_id=b.order_id
JOIN bigquery-public-data.thelook_ecommerce.products AS c 
ON a.product_id = c.id
WHERE b.status='Complete') AS d) AS p
GROUP BY p.dmyy, p.id, p.name
ORDER BY p.dmyy) AS q
WHERE q.rank_per_month<=5


/*5.Doanh thu tính đến thời điểm hiện tại trên mỗi danh mục
Thống kê tổng doanh thu theo ngày của từng danh mục sản phẩm (category) trong 3 tháng
qua ( giả sử ngày hiện tại là 15/4/2022)
Output: dates (yyyy-mm-dd), product_categories, revenue*/
----- Cách 1:
SELECT d.dates, d.category AS product_categories,
ROUND(SUM(d.retail_price),2) AS revenue
FROM  (SELECT CAST(b.shipped_at AS DATE) AS dates, c.category, c.retail_price 
FROM bigquery-public-data.thelook_ecommerce.order_items AS a 
JOIN bigquery-public-data.thelook_ecommerce.orders AS b
ON a.order_id=b.order_id
JOIN bigquery-public-data.thelook_ecommerce.products AS c 
ON a.product_id = c.id
WHERE b.status='Complete'
ORDER BY CAST(b.shipped_at AS DATE)) AS d
WHERE d.dates>='2022-04-15' AND d.dates=<'2022-07-15'
GROUP BY d.dates, d.category 
ORDER BY d.category, d.dates
----- Cách 2:
select date(created_at), 
b.category as product_categories,
sum(a.sale_price) as revenue,
from bigquery-public-data.thelook_ecommerce.order_items as a join bigquery-public-data.thelook_ecommerce.products as b
on a.product_id = b.id
where DATE(created_at) BETWEEN '2022-02-15' AND '2022-04-15'
group by 1,2
order by 1







/*RIGHT(LEFT(CAST(c.created_at AS string),7),2) AS month,
LEFT(CAST(c.created_at AS string),4) AS year, */



SELECT DATE(c.created_at),
a.category AS product_category,
SUM(b.sale_price) AS tpv,
COUNT(b.product_id) AS tpo
FROM bigquery-public-data.thelook_ecommerce.products AS a
JOIN bigquery-public-data.thelook_ecommerce.order_items AS b
ON a.id =b.product_id
JOIN bigquery-public-data.thelook_ecommerce.orders AS c 
ON c.order_id = b.order_id
WHERE c.status='Complete'
GROUP BY DATE(c.created_at),a.category
