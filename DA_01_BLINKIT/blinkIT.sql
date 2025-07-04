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

SELECT COUNT(Rating) FROM blinkit_data
-- TOTALLY 8523 RECORDS ARE THERE

