create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);

-- DATA EXPLORATION


-- COUNT OF ROWS
SELECT COUNT(*) FROM zepto

-- LOOK FIRST 10 RECORDS
SELECT * FROM zepto
LIMIT 10


-- NULL CHECK
SELECT * FROM zepto
WHERE category IS NULL 
OR 
name IS NULL 
OR 
mrp IS NULL 
OR 
discountPercent IS NULL 
OR
availableQuantity IS NULL 
OR
discountSellingPrice IS NULL
OR
weightInGms IS NULL 
OR
outOfStock IS NULL
OR
quantity IS NULL

-- DIFFERENT PRODUCT CATEGORY
SELECT DISTINCT category FROM zepto
ORDER BY category

-- CHECK STOCKS
SELECT outOfStock, COUNT(sku_id) FROM zepto
GROUP BY outOfStock

-- PRODUCT PRESENT MULTIPLE TIMES
SELECT name, COUNT(sku_id) as "Number of SKUs"
FROM zepto GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC


-- DATA CLEANING


-- REMOVING RECORD BY MRP
SELECT * FROM zepto WHERE mrp = 0 
OR discountSellingPrice = 0

DELETE FROM zepto WHERE mrp = 0

-- CONVERT MRP PRICE IN RS
UPDATE zepto
SET mrp = mrp/100,
discountSellingPrice = discountSellingPrice/100

SELECT mrp,discountSellingPrice FROM zepto

--Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name,mrp,discountPercent
FROM zepto ORDER BY discountPercent DESC 
LIMIT 10

--Q2.What are the Products with High MRP but Out of Stock
SELECT DISTINCT name,mrp FROM zepto 
WHERE outOfStock = TRUE and mrp > 300
ORDER BY mrp DESC

--Q3.Calculate Estimated Revenue for each category
SELECT category, 
SUM(discountSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category 
ORDER BY total_revenue

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT name,mrp,discountPercent FROM zepto
WHERE mrp > 500 and discountPercent < 10
ORDER BY mrp DESC,discountPercent DESC

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category,
ROUND(AVG(discountPercent),2) AS avg_disc
FROM zepto
GROUP BY category 
ORDER BY avg_disc DESC
LIMIT 5

-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountSellingPrice,
ROUND(discountSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

--Q7.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto;

--Q8.What is the Total Inventory Weight Per Category 
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;

