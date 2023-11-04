--1.Chuyển đổi kiểu dữ liệu phù hợp cho các trường ( sử dụng câu lệnh ALTER) 
SELECT * FROM sales_dataset_rfm_prj

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN ordernumber TYPE interger USING (trim(ordernumber)::interger);

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN quantityordered TYPE numeric USING (trim(quantityordered)::numeric);

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN priceeach TYPE numeric USING (trim(priceeach)::numeric);

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN orderlinenumber TYPE interger USING (trim(orderlinenumber)::interger);

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN sales TYPE numeric USING (trim(sales)::numeric);

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN orderdate TYPE timestamp USING (trim(orderdate)::timestamp);

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN msrp TYPE numeric USING (trim(msrp)::numeric);

SELECT * FROM sales_dataset_rfm_prj

/*2.Check NULL/BLANK (‘’)  ở các trường: 
ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE.*/
SELECT COUNT(*) FROM sales_dataset_rfm_prj

SELECT * FROM sales_dataset_rfm_prj
WHERE ordernumber IS NULL OR quantityordered IS NULL OR priceeach IS NULL OR orderlinenumber IS NULL 
OR sales IS NULL OR orderdate IS NULL 

/*3.Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME . 
Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng chữ cái đầu tiên viết hoa, 
chữ cái tiếp theo viết thường. 
Gợi ý: ( ADD column sau đó INSERT)*/
SELECT * FROM sales_dataset_rfm_prj

ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN CONTACTFIRSTNAME VARCHAR(50)

ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN CONTACTLASTNAME VARCHAR(50)

UPDATE sales_dataset_rfm_prj
SET contactfirstname = UPPER(LEFT(contactfullname,1))||
LOWER(SUBSTRING(contactfullname,2,POSITION('-' IN contactfullname)-2))

UPDATE sales_dataset_rfm_prj
SET contactlastname = UPPER(SUBSTRING(contactfullname,POSITION('-' IN contactfullname)+1,1))||
LOWER(SUBSTRING(contactfullname,POSITION('-' IN contactfullname)+2))

SELECT * FROM sales_dataset_rfm_prj

--4.Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE 
SELECT * FROM sales_dataset_rfm_prj

ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN month_id numeric

UPDATE sales_dataset_rfm_prj
SET month_id = EXTRACT(month FROM orderdate)

ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN year_id numeric

UPDATE sales_dataset_rfm_prj
SET year_id = EXTRACT(year FROM orderdate)

ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN qtr_id numeric

UPDATE sales_dataset_rfm_prj
SET qtr_id = EXTRACT(quarter FROM orderdate)

SELECT * FROM sales_dataset_rfm_prj

/*5.Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED và hãy chọn cách xử lý cho bản ghi đó (2 cách) 
( Không chạy câu lệnh trước khi bài được review)*/
-- CÁCH 1:
WITH twt_min_max AS
(SELECT (a.Q1-1.5*a.IQR) AS min, (a.Q3+1.5*a.IQR) AS max
FROM (SELECT percentile_cont(0.25) WITHIN GROUP(ORDER BY quantityordered) AS Q1,
percentile_cont(0.75) WITHIN GROUP(ORDER BY quantityordered) AS Q3,
percentile_cont(0.75) WITHIN GROUP(ORDER BY quantityordered) -
percentile_cont(0.25) WITHIN GROUP(ORDER BY quantityordered) AS IQR
FROM sales_dataset_rfm_prj) AS a)
SELECT * FROM sales_dataset_rfm_prj
WHERE quantityordered < (select min FROM twt_min_max) OR quantityordered > (select max FROM twt_min_max)

-- CÁCH 2:
WITH cte AS 
(SELECT quantityordered,
(select avg(quantityordered) FROM sales_dataset_rfm_prj) AS avg,
(select stddev(quantityordered) FROM sales_dataset_rfm_prj) AS stddev
FROM sales_dataset_rfm_prj), twt_outlier AS
(SELECT quantityordered,(quantityordered-avg)/stddev
FROM cte
WHERE abs((quantityordered-avg)/stddev)>3)
DELETE FROM sales_dataset_rfm_prj
WHERE quantityordered IN (select quantityordered IN twt_outlier)
--6.Sau khi làm sạch dữ liệu, hãy lưu vào bảng mới tên là SALES_DATASET_RFM_PRJ_CLEAN

