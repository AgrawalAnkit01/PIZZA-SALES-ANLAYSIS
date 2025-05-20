-- Selecting the database
USE pizza_sales_analysis;

### BEGINNER LEVEL ANALYSIS
--- (These queries focus on basic data 
--        retrieval, aggregation, and simple calculations.)
        
-- 1. Display All Records from pizza_sales Table
SELECT * FROM pizza_sales;

-- 2. Total Orders Placed
SELECT 
    COUNT(*) AS Orders_Placed
FROM
    pizza_sales;

-- 3. Total Revenue
SELECT 
    ROUND(SUM(total_price), 2) AS Total_Revenue  
FROM 
    pizza_sales;
    
-- 4. Total Pizza Sold
SELECT
    SUM(quantity) AS Total_Pizza_Sold
FROM
    pizza_sales;

-- 5. Total Unique Orders
SELECT
    COUNT(DISTINCT order_id) AS Total_Order
FROM
    pizza_sales;

-- 6.Top 5 Pizzas by Revenue
SELECT pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue DESC
LIMIT 5;

-- 7.Bottom 5 Pizzas by Revenue
SELECT pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue ASC
LIMIT 5;

###INTERMEDIATE LEVEL ANALYSIS
-- (These queries include more advanced 
--       filtering, grouping, and multi-step calculations.)

-- 1. Average Order Value
SELECT
    ROUND(SUM(total_price) / COUNT(DISTINCT order_id), 2) AS Average_Order_Value
FROM 
    pizza_sales;
    
-- 2. Average Pizza per Order
SELECT
    ROUND(SUM(quantity) / COUNT(DISTINCT order_id), 2) AS Avg_Pizza_per_Order
FROM
    pizza_sales;

-- 3. Daily Trends for Total Orders
SELECT
    order_date AS order_day, 
    COUNT(DISTINCT order_id) AS total_orders 
FROM
    pizza_sales
GROUP BY 
    order_date
ORDER BY
    order_date;

-- 4. Daily Revenue Trends
SELECT 
    order_date AS order_day, 
    ROUND(SUM(total_price), 2) AS total_revenue
FROM 
    pizza_sales
GROUP BY 
    order_date
ORDER BY 
    order_date;

-- 5. Monthly Sales Performance
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS order_month, 
    COUNT(DISTINCT order_id) AS total_orders, 
    ROUND(SUM(total_price), 2) AS total_revenue
FROM
    pizza_sales
GROUP BY
    order_month
ORDER BY
    order_month;

-- 6.Revenue by Day of the Week
SELECT DAYNAME(order_date) AS day_of_week, ROUND(SUM(total_price), 2) AS total_revenue 
FROM pizza_sales
GROUP BY day_of_week 
ORDER BY FIELD(day_of_week, 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');

-- 7.Orders by Time of Day
SELECT HOUR(order_time) AS hour_of_day, COUNT(DISTINCT order_id) AS total_orders 
FROM pizza_sales
GROUP BY hour_of_day
ORDER BY hour_of_day;


### ADVANCED LEVEL ANALYSIS
-- (These queries use more complex SQL constructs such as
--       subqueries, conditional statements, and analysis over time.)

-- 1. Seasonality Analysis: Comparing Monthly Sales Across Years
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month_year, 
    ROUND(SUM(total_price), 2) AS monthly_revenue
FROM
    pizza_sales
GROUP BY
    month_year
ORDER BY
    month_year;
    
-- 2. Peak Order Hours
SELECT 
    HOUR(order_time) AS hour_of_day, 
    COUNT(order_id) AS total_orders
FROM 
    pizza_sales
GROUP BY 
    hour_of_day
ORDER BY 
    total_orders DESC
LIMIT 5;

-- 3. Percentage of Sales by Pizza Category
SELECT 
    pizza_category, 
    CAST(SUM(total_price) AS DECIMAL(10,2)) AS total_revenue,
    CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM 
    pizza_sales
GROUP BY 
    pizza_category;
    
-- 4. Pizza Sales by Daypart Analysis
SELECT 
    CASE 
        WHEN HOUR(order_time) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN HOUR(order_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN HOUR(order_time) BETWEEN 18 AND 21 THEN 'Evening'
        ELSE 'Night'
    END AS daypart,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_pizzas_sold,
    ROUND(SUM(total_price), 2) AS total_revenue
FROM 
    pizza_sales
GROUP BY 
    daypart
ORDER BY 
    total_revenue DESC;

-- 5. Hypothetical Analysis of Repeat Purchases
SELECT 
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT CASE WHEN order_count > 1 THEN order_id END) AS repeat_orders,
    ROUND(SUM(total_price), 2) AS total_revenue,
    ROUND(SUM(total_price) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM 
    (SELECT 
        order_id, 
        COUNT(*) AS order_count, 
        SUM(total_price) AS total_price
     FROM 
        pizza_sales
     GROUP BY 
        order_id
    ) AS order_summary;