-------------------create table for import CSV file


CREATE TABLE pizza_orders (
    pizza_id SERIAL PRIMARY KEY,
    order_id INT,
    pizza_name_id INT,
    quantity INT,
    order_date DATE,
    order_time TIME,
    unit_price NUMERIC,
    total_price NUMERIC,
    pizza_size VARCHAR(50),
    pizza_category VARCHAR(50),
    pizza_ingredients TEXT,
    pizza_name VARCHAR(100)
);
-------------------import CSV file-------

COPY pizza_orders
FROM 'C:/Users/mdarm/Downloads/pizza_sales.csv'
DELIMITER ','
CSV HEADER;
ALTER TABLE pizza_orders
ALTER COLUMN pizza_name_id TYPE VARCHAR(100);

-------------- -------------creating queries for KPI----------------------
	
----------------------------Total Revenue:--------------------------------

select * from pizza_orders
select sum(total_price)as total_revenue from pizza_orders


----------------------------Average Order Value:--------------------------------

select sum(total_price)/count(distinct order_id)as avg_order_value from pizza_orders
	

----------------------------Total Pizzas Sold-----------------------------------
select sum(quantity) as total_pizza_sold from pizza_orders
	
------------------------------Total Pizza Orders--------------------------------
select count(distinct  order_id) as total_pizza_order from pizza_orders
	
----------------------------Average Pizzas Per Order----------------------------------------

SELECT CAST(CAST(SUM(quantity) AS DECIMAL(10,2)) / 
CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2))
AS Avg_Pizzas_per_order
FROM pizza_orders

	----------------------------Daily Trend for Total Orders-----------------------------------
---
SELECT TO_CHAR(order_date, 'Day') AS order_day, COUNT(DISTINCT order_id) AS total_orders 
FROM pizza_orders
GROUP BY TO_CHAR(order_date, 'Day')
order by total_orders desc;

-------------------------------. Monthly Trend for Orders----------------------------------
SELECT TO_CHAR(order_date, 'MONTH') AS Month_Name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_orders
GROUP BY TO_CHAR(order_date, 'MONTH')
order by total_orders desc
	
------------------------------% of Sales by Pizza Category-----------------------------------
SELECT pizza_category,
       CAST(SUM(total_price) AS DECIMAL(10,2)) AS total_revenue,
       CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_orders) AS DECIMAL(10,2)) AS PCT
FROM pizza_orders
GROUP BY pizza_category
order by PCT desc;

------------------------------% of Sales by Pizza Size-----------------------------------
SELECT pizza_size,
       CAST(SUM(total_price) AS DECIMAL(10,2)) AS total_revenue,
       CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_orders) AS DECIMAL(10,2)) AS pct
FROM pizza_orders
GROUP BY pizza_size
ORDER BY pizza_size;

--------------------------------TTotal Pizzas Sold by Pizza Category-----------------------------------
SELECT pizza_category,
       SUM(quantity) AS Total_Quantity_Sold
FROM pizza_orders
WHERE EXTRACT(MONTH FROM order_date) = 2
GROUP BY pizza_category
ORDER BY Total_Quantity_Sold DESC;

-----------------------------. Top 5 Pizzas by Revenue-----------------------------------
SELECT pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_orders
GROUP BY pizza_name
ORDER BY Total_Revenue DESC
LIMIT 5;

------------------------------. Bottom 5 Pizzas by Revenue-----------------------------------
SELECT pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_Orders
GROUP BY pizza_name
ORDER BY Total_Revenue ASC
LIMIT 5;

------------------------------Top 5 Pizzas by Quantity-----------------------------------
SELECT pizza_name, SUM(quantity) AS Total_Pizza_Sold
FROM pizza_orders
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold DESC
LIMIT 5;

------------------------------Bottom  5 Pizzas by Quantity----------------------------------

SELECT pizza_name, SUM(quantity) AS Total_Pizza_Sold
FROM pizza_orders
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold asc
LIMIT 5;

--------------------------------Top 5 Pizzas by Total Orders----------------------------------
SELECT pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_orders
GROUP BY pizza_name
ORDER BY Total_Orders DESC
LIMIT 5;

--------------------------------Bottom  5 Pizzas by Total Orders-----------------------------------
SELECT pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_orders
GROUP BY pizza_name
ORDER BY Total_Orders asc
LIMIT 5;
























