DROP TABLE IF EXISTS blinkit_data

CREATE TABLE blinkit_data(
Item_fat_content VARCHAR(222),
Item_identifier VARCHAR(222),
Item_type VARCHAR(200),
Outlet_establishment_yr INT,
Outlet_identifier VARCHAR(100),
Outlet_location_type VARCHAR(100),
Outlet_size VARCHAR(222),
Outlet_type VARCHAR(222),
Item_visibility FLOAT,
Item_weight FLOAT,
Total_sales FLOAT,
Rating FLOAT
)

select * from blinkit_data

SELECT COUNT(*) FROM blinkit_data
-- TOTALLY 8523 RECORDS ARE THERE

SELECT DISTINCT Item_fat_content FROM blinkit_data
-- THE COLUMNS HAVE 5 DISTINCT VALUES THEY ARE:
-- Low Fat, low fat,Regular, LF, reg

-- LETS MAKE THEM PROPER
UPDATE blinkit_data
SET Item_fat_content = 
CASE 
WHEN Item_fat_content IN('LF','low fat') THEN 'Low Fat'
WHEN Item_fat_content ='reg' THEN 'Regular'
ELSE Item_fat_content 
END
-- LETS SEE THE UPDATE
SELECT DISTINCT Item_fat_content FROM blinkit_data

SELECT * FROM blinkit_data

-- KPI 1. TOTAL SALES
SELECT SUM(Total_sales) FROM blinkit_data

SELECT CAST(SUM(Total_sales)/1000000 AS DECIMAL(10,2)) AS Total_sales_Million FROM
blinkit_data
-- TOTAL SALES IS 1.20 MILLION

-- KPI 2. AVERAGE TOTAL SALES
SELECT AVG(Total_sales) FROM blinkit_data

SELECT CAST(AVG(Total_sales) AS DECIMAL(10,2)) AS Avg_sales 
FROM blinkit_data
-- AVG SALES IS 140.99

-- KPI 3. TOTAL NUMBER OF ITEMS
SELECT COUNT(*) FROM blinkit_data
-- 8523

SELECT COUNT(*) FROM blinkit_data WHERE Outlet_establishment_yr = 2012
-- 930 ITEMS 

SELECT (COUNT(DISTINCT Item_type)) FROM blinkit_data
-- DISTINCT ITEM TYPE IS 16

-- KPI 4. AVERAGE RATING
SELECT CAST(AVG(Rating) AS DECIMAL(10,2)) AS AVG_RATING 
FROM blinkit_data


-- BUSINESS REQUIREMENTS

-- TOTAL SALES BY FAT CONTENT

SELECT Item_fat_content,CAST(SUM(Total_sales)AS DECIMAL(10,2)) AS sum_tot_sales,
CAST(AVG(Total_sales)AS DECIMAL(10,2)) AS avg_tot_sales,
COUNT(*) ,
CAST(AVG(Rating) AS DECIMAL(10,2)) AS avg_rating 
FROM blinkit_data
GROUP BY Item_fat_content

-- TOTAL SALES BY ITEM TYPE
SELECT Item_type,CAST(SUM(Total_sales)AS DECIMAL(10,2)) AS sum_tot_sales,
CAST(AVG(Total_sales)AS DECIMAL(10,2)) AS avg_tot_sales,
COUNT(*) ,
CAST(AVG(Rating) AS DECIMAL(10,2)) AS avg_rating 
FROM blinkit_data
GROUP BY Item_type
ORDER BY sum_tot_sales DESC

--FAT CONTENT BY OUTLET TYPE
SELECT Outlet_location_type, Item_fat_content,
CAST(SUM(Total_sales)AS DECIMAL(10,2)) AS sum_tot_sales,
CAST(AVG(Total_sales)AS DECIMAL(10,2)) AS avg_tot_sales,
COUNT(*) ,
CAST(AVG(Rating) AS DECIMAL(10,2)) AS avg_rating 
FROM blinkit_data
GROUP BY Outlet_location_type, Item_fat_content
ORDER BY sum_tot_sales DESC

SELECT 
    Outlet_Location_Type,
    COALESCE(SUM(CASE WHEN Item_Fat_Content = 'Low Fat' THEN Total_Sales END), 0) AS Low_Fat,
    COALESCE(SUM(CASE WHEN Item_Fat_Content = 'Regular' THEN Total_Sales END), 0) AS Regular
FROM 
    blinkit_data
GROUP BY 
    Outlet_Location_Type
ORDER BY 
    Outlet_Location_Type;


-- SALES BY OUTLET ESTABLISHMENT YEAR
SELECT Outlet_establishment_yr,SUM(Total_sales) 
FROM blinkit_data
GROUP BY Outlet_establishment_yr

-- PERCENTAGE OF SALES BY OUTLET SIZE

SELECT Outlet_size, CAST(SUM(Total_sales) AS DECIMAL(10,2)),
CAST(SUM(Total_sales)*100 / SUM(SUM(Total_sales)) OVER() AS DECIMAL(10,0)) AS percentage_sales
FROM blinkit_data
GROUP BY Outlet_size

-- SALES BY OUTLET LOCATION

SELECT Outlet_location_type,
CAST(SUM(Total_sales) AS DECIMAL(10,2)),
CAST(SUM(Total_sales)*100 / SUM(SUM(Total_sales)) OVER() AS DECIMAL(10,0)) AS percentage_sales
FROM blinkit_data
GROUP BY Outlet_location_type

-- EVERY STATS OF SALES BY OUTLET TYPE

SELECT Outlet_type,
CAST(SUM(Total_sales) AS DECIMAL(10,2)) AS sum_of_sales,
CAST(SUM(Total_sales)*100 / SUM(SUM(Total_sales)) OVER() AS DECIMAL(10,0)) AS percentage_sales,
CAST(AVG(Total_sales)AS DECIMAL(10,2)) AS avg_tot_sales,
COUNT(*) ,
CAST(AVG(Rating) AS DECIMAL(10,2)) AS avg_rating
FROM blinkit_data
GROUP BY Outlet_type

