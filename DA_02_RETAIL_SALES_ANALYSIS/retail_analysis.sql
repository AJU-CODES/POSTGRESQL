-- RETAIL SALES ANALYSIS USING PGADMIN4

-- CREATE TABLE AND IMPORT DATA

DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales(
transactions_id INT PRIMARY KEY,
sale_date DATE,
sale_time TIME,
customer_id INT,
gender VARCHAR(10),
age INT,
category VARCHAR(15),	
quantiy INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT
);

SELECT * FROM retail_sales
LIMIT 10;


-- TOTAL RECORDS

SELECT 
	COUNT(*)
FROM retail_sales; -- 2000

-- CHECKING AND HANDLING NULL

SELECT * FROM retail_sales
WHERE 
transactions_id IS NULL
OR sale_date IS NULL 
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR category IS NULL
OR quantiy IS NULL
OR cogs IS NULL
OR total_sale IS NULL
; -- 3 RECORDS 
-- DELETING RECORDS
DELETE FROM retail_sales
WHERE transactions_id IS NULL
OR sale_date IS NULL 
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR category IS NULL
OR quantiy IS NULL
OR cogs IS NULL
OR total_sale IS NULL
; -- 3 RECORDS DELETED 
-- LETS CHECK THE COUNT
SELECT COUNT(*)
FROM retail_sales; --1997


-- DATA EXPLRATION

-- HOW MANY SALES WE HAVE?
SELECT COUNT(*) AS total_sales
FROM retail_sales; --1997

-- HOW MANY CUSTOMERS WE HAVE?
SELECT COUNT(DISTINCT customer_id) AS total_customers 
FROM retail_sales; -- 155

-- HOW MANY CATEGORIES WE HAVE?
SELECT COUNT(DISTINCT category) AS total_categories
FROM retail_sales; --3

SELECT DISTINCT category
FROM retail_sales; 

-- DATA ANALYSIS & BUSINESS KEY Q/A

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
SELECT MAX(quantiy) FROM retail_sales; -- 4

SELECT * FROM retail_sales
WHERE 
category  = 'Clothing'
AND 
TO_CHAR(sale_date, 'YYYY-MM')='2022-11'
AND 
quantiy >= 4

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category,SUM(total_sale)
AS total_sale, COUNT(*) AS total_order
FROM retail_sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT ROUND(AVG(age),2)
FROM retail_sales
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales 
WHERE total_sale >1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category,gender,COUNT(*) AS total_trans
FROM retail_sales 
GROUP BY category,gender
ORDER BY 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT yr,mon,avg_sale FROM(
SELECT 
EXTRACT(YEAR FROM sale_date) AS yr,
EXTRACT(MONTH FROM sale_date) AS mon,
CAST(AVG(total_sale) AS DECIMAL(10,2)) AS avg_sale,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date)
ORDER BY CAST(AVG(total_sale) AS DECIMAL(10,2)) DESC) AS
rankings
FROM retail_sales
GROUP BY yr,mon)
AS t1
WHERE rankings = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
customer_id,
SUM(total_sale) AS tot_sale
FROM retail_sales
GROUP BY 1
ORDER BY tot_sale DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category,
COUNT(DISTINCT customer_id)
FROM retail_sales
GROUP BY 1;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_order AS(
SELECT * ,
CASE
	WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
	WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	ELSE 'Evening'
	END AS shift
FROM retail_sales
)
SELECT shift,COUNT(*)
FROM hourly_order
GROUP BY 1;