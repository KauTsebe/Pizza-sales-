-- Use the pizza_sales database

-- KPIs (Key Performance Indicators)

-- 1) Total Revenue
-- This query calculates the total revenue generated from pizza sales.
SELECT ROUND(SUM(quantity * price), 2) AS [Total Revenue]
FROM order_details AS o
JOIN pizzas AS p ON o.pizza_id = p.pizza_id;

-- 2) Average Order Value
-- This query calculates the average value of each order.
SELECT ROUND(SUM(quantity * price) / COUNT(DISTINCT order_id), 2) AS [Average order value]
FROM order_details AS o
JOIN pizzas AS p ON o.pizza_id = p.pizza_id;

-- 3) Total Pizzas Sold
-- This query calculates the total number of pizzas sold.
SELECT SUM(quantity) AS [Total pizzas sold]
FROM order_details;

-- 4) Total Orders
-- This query calculates the total number of orders placed.
SELECT COUNT(DISTINCT order_id) AS [Total Orders]
FROM order_details;

-- 5) Average Pizzas Per Order
-- This query calculates the average number of pizzas ordered per order.
SELECT SUM(quantity) / COUNT(DISTINCT order_id) AS [Average pizzas per order]
FROM order_details;

-- Question Trends For Total Orders

-- 1) Daily Trends for Total Orders
-- This query provides a breakdown of the total number of orders placed each day of the week.
SELECT FORMAT(DATE, 'dddd') AS DayOfWeek,
       COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY FORMAT(DATE, 'dddd')
ORDER BY total_orders DESC;

-- 2) Hourly Rate for Total Orders
-- This query provides a breakdown of the total number of orders placed each hour.
SELECT DATEPART(HOUR, time) AS [Hour],
       COUNT(DISTINCT order_id) AS Count
FROM orders
GROUP BY DATEPART(HOUR, time)
ORDER BY Count DESC;

-- 3) Percentage of Sales by Pizza Category
-- This query calculates the percentage of total sales contributed by each pizza category.
SELECT pt.category,
       ROUND(SUM(quantity * price), 2) AS revenue,
       ROUND(SUM(quantity * price) * 100 / (SELECT SUM(quantity * price) FROM pizzas AS p2 JOIN order_details AS od2 ON od2.pizza_id = p2.pizza_id), 2) AS pct_sales
FROM pizzas AS p
JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY pct_sales DESC;

-- 4) Percentage of Sales by Pizza Size
-- This query calculates the percentage of total sales contributed by each pizza size.
SELECT p.size,
       ROUND(SUM(quantity * price), 2) AS revenue,
       ROUND(SUM(quantity * price) * 100 / (SELECT SUM(quantity * price) FROM pizzas AS p2 JOIN order_details AS od2 ON od2.pizza_id = p2.pizza_id), 2) AS pct_sales
FROM pizzas AS p
JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY pct_sales DESC;

-- 5) Total Pizzas Sold by Pizza Category
-- This query calculates the total number of pizzas sold for each pizza category.
SELECT pt.category,
       SUM(quantity) AS quantity_sold
FROM pizzas AS p
JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY SUM(quantity) DESC;

-- 6) The Top 5 Best Sellers by Total Pizzas Sold
-- This query identifies the top 5 best-selling pizzas based on the total number of pizzas sold.
SELECT TOP 5
       p.name,
       SUM(quantity) AS total_pizzas_sold
FROM pizzas AS p
JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY p.name
ORDER BY total_pizzas_sold DESC;

-- 7) The Bottom Five Pizzas Sold 
-- This query identifies the bottom 5 least-selling pizzas based on the total number of pizzas sold.
SELECT TOP 5
       p.name,
       SUM(quantity) AS total_pizzas_sold
FROM pizzas AS p
JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY p.name
ORDER BY total_pizzas_sold ASC;
