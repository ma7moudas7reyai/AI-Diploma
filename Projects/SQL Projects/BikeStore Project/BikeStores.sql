CREATE DATABASE	BikeStores;

-- Display all data on the tables
SELECT * FROM production.brands;

SELECT * FROM production.categories;

SELECT * FROM production.products;

SELECT * FROM production.stocks;

SELECT * FROM sales.customers;

SELECT * FROM sales.order_items;

SELECT * FROM sales.orders;

SELECT * FROM sales.staffs;

SELECT * FROM sales.stores;

-----------------------------------------------------

-- 1) Which bike is most expensive? What could be the motive behind pricing this bike at the high price?
SELECT TOP 1 pp.product_name, pp.list_price
FROM production.products AS pp
ORDER BY pp.list_price DESC;

SELECT TOP 1 pp.product_name, pb.brand_name, pc.category_name, pp.model_year, pp.list_price
FROM production.products AS pp
JOIN production.brands AS pb ON pp.brand_id = pb.brand_id
JOIN production.categories AS pc ON pp.category_id = pc.category_id
ORDER BY pp.list_price DESC;

-- The high price could be due to its premium brand (Trek) and its high-end road bike category.

-- 2) How many total customers does BikeStore have? Would you consider people with order status 3 as customers substantiate your answer?
SELECT COUNT(sc.customer_id) AS total_customer FROM sales.customers AS sc;

SELECT COUNT(DISTINCT so.customer_id) AS total_customers FROM sales.orders AS so
WHERE so.order_status = 3;

-- 45 customers have orders with status 3 (Rejected).
-- Yes, I would still consider them customers because order status 3 means
-- that their order was rejected, not that they are no longer customers.

-- 3) How many stores does BikeStore have?
SELECT COUNT(ss.store_id) AS total_stores FROM sales.stores AS ss;

-- 4) What is the total price spent per order?
-- Hint: total price = [list_price] *[quantity]*(1-[discount])
SELECT si.order_id, SUM(si.list_price * si.quantity * (1 - si.discount)) AS total_price 
FROM sales.order_items AS si
GROUP BY si.order_id;

-- 5) What’s the sales/revenue per store?
-- Hint: Sales revenue = ([list_price] *[quantity]*(1-[discount]))
SELECT ss.store_name, SUM(si.list_price * si.quantity * (1 - si.discount)) AS total_revenue
FROM sales.order_items AS si
JOIN sales.orders AS so ON si.order_id = so.order_id
JOIN sales.stores AS ss ON so.store_id = ss.store_id
GROUP BY ss.store_name;

-- 6) Which category is most sold?
SELECT TOP 1 pc.category_name, SUM(si.quantity) AS total_categoris
FROM sales.order_items AS si
JOIN production.products AS pp ON si.product_id = pp.product_id
JOIN production.categories AS pc ON pp.category_id = pc.category_id
GROUP BY pc.category_name
ORDER BY total_categoris DESC;

-- 7) Which category rejected more orders?
SELECT pc.category_name, COUNT(DISTINCT so.order_id) AS total_orders_rejected 
FROM sales.orders AS so
JOIN sales.order_items AS si ON so.order_id = si.order_id
JOIN production.products AS pp ON si.product_id = pp.product_id 
JOIN production.categories AS pc ON pp.category_id = pc.category_id
WHERE so.order_status = 3
GROUP BY pc.category_name;

-- 8) Which bike is the least sold?
SELECT TOP 1 pp.product_name, SUM(si.quantity) AS total_orders 
FROM sales.order_items AS si 
JOIN production.products AS pp ON si.product_id = pp.product_id
GROUP BY pp.product_name
ORDER BY total_orders;

-- 9) What’s the full name of a customer with ID 259?
SELECT sc.first_name + ' ' + sc.last_name AS full_name
FROM sales.customers AS sc
WHERE sc.customer_id = 259;

-- 10) What did the customer on question 9 buy and when? What’s the status of this order?
SELECT 
	sc.first_name + ' ' + sc.last_name AS full_name,
	pp.product_name,
	so.order_date,
	so.order_status
FROM sales.customers AS sc
JOIN sales.orders AS so ON sc.customer_id = so.customer_id
JOIN sales.order_items AS si ON so.order_id = si.order_id
JOIN production.products AS pp ON si.product_id = pp.product_id
WHERE sc.customer_id = 259;

-- 11) Which staff processed the order of customer 259? And from which store?
SELECT 
	st.first_name + ' ' + st.last_name AS full_name,
	ss.store_name
FROM sales.orders AS so
JOIN sales.staffs AS st ON so.staff_id = st.staff_id
JOIN sales.stores AS ss ON so.store_id = ss.store_id
WHERE so.customer_id = 259;

-- 12) How many staff does BikeStore have? Who seems to be the lead Staff at BikeStore?
SELECT COUNT(st.staff_id) AS total_staffs
FROM sales.staffs AS st;

SELECT * FROM sales.staffs;
-- Fabiola seems to be the top-level staff member because her manager_id is NULL.

-- 13) Which brand is the most liked?
SELECT TOP 1 pb.brand_name, SUM(si.quantity) AS total_sold 
FROM sales.order_items AS si
JOIN production.products AS pp ON si.product_id = pp.product_id
JOIN production.brands AS pb ON pp.brand_id = pb.brand_id
GROUP BY pb.brand_name
ORDER BY total_sold DESC;

-- 14) How many categories does BikeStore have, and which one is the least liked?
SELECT COUNT(pc.category_id) AS total_category 
FROM production.categories AS pc;

SELECT TOP 1 pc.category_name, SUM(si.quantity) AS total_quantity 
FROM sales.order_items AS si
JOIN production.products AS pp ON si.product_id = pp.product_id
JOIN production.categories AS pc ON pp.category_id = pc.category_id
GROUP BY pc.category_name
ORDER BY total_quantity;

-- 15) Which store still have more products of the most liked brand?
SELECT TOP 1 ss.store_name, pb.brand_name, SUM(ps.quantity) AS total_qauntity
FROM production.brands AS pb 
JOIN production.products AS pp ON pb.brand_id = pp.brand_id
JOIN production.stocks AS ps ON pp.product_id = ps.product_id
JOIN sales.stores AS ss ON ps.store_id = ss.store_id
GROUP BY ss.store_name, pb.brand_name
ORDER BY total_qauntity DESC;

-- 16) Which state is doing better in terms of sales?
SELECT TOP 1 sc.state, SUM(si.list_price * si.quantity * (1 - si.discount)) AS total_orders
FROM sales.customers AS sc 
JOIN sales.orders AS so ON sc.customer_id = so.customer_id
JOIN sales.order_items AS si ON so.order_id = si.order_id
GROUP BY sc.state
ORDER BY total_orders DESC;

-- 17) What’s the discounted price of product id 259?
SELECT pp.product_name, si.discount, si.list_price * (1 - si.discount) AS discounted_price
FROM production.products AS pp
JOIN sales.order_items AS si ON pp.product_id = si.product_id
WHERE si.product_id = 259;

-- 18) What’s the product name, quantity, price, category, model year and brand name of product number 44?
SELECT pp.product_name, si.quantity, si.list_price, pc.category_name, pp.model_year, pb.brand_name
FROM sales.order_items AS si 
JOIN production.products AS pp ON si.product_id = pp.product_id
JOIN production.categories AS pc ON pp.category_id = pc.category_id
JOIN production.brands AS pb ON pp.brand_id = pb.brand_id
WHERE pp.product_id = 44;

-- 19) What’s the zip code of CA?
SELECT sc.state, sc.zip_code
FROM sales.customers AS sc
WHERE sc.state = 'CA';

-- 20) How many states does BikeStore operate in?
SELECT COUNT(DISTINCT sc.state) AS total_states
FROM sales.customers AS sc;

-- 21) How many bikes under the children category were sold in the last 8 months?
SELECT SUM(SI.quantity) AS total_sold
FROM production.categories AS pc
JOIN production.products AS pp ON pc.category_id = pp.category_id
JOIN sales.order_items AS si ON pp.product_id = si.product_id
JOIN sales.orders AS so ON si.order_id = so.order_id
WHERE so.order_date >= DATEADD(MONTH, -8, (SELECT MAX(order_date) FROM sales.orders)) AND pc.category_name = 'Children Bicycles';

-- 22) What’s the shipped date for the order from customer 523?
SELECT so.shipped_date FROM sales.orders AS so
WHERE so.customer_id = 523;

-- 23) How many orders are still pending?
SELECT COUNT(so.order_id) AS total_orders FROM sales.orders AS so
WHERE so.order_status = 1;

-- 24) What’s the names of category and brand does "Electra white water 3i - 2018" fall under?
SELECT pc.category_name, pb.brand_name 
FROM production.products AS pp
JOIN production.categories AS pc ON pp.category_id = pc.category_id
JOIN production.brands AS pb ON pp.brand_id = pb.brand_id
WHERE pp.product_name = 'Electra white water 3i - 2018';

-- 25) Create a view that displays all completed orders with the following columns:
-- ● Order ID
-- ● Customer Full Name
-- ● Store Name
-- ● Staff Name
-- ● Total Order Price
GO 
CREATE VIEW completed_orders AS 
SELECT 
	so.order_id, 
	sc.first_name + ' ' + sc.last_name AS customer_full_name,
	ss.store_name,
	st.first_name + ' ' + st.last_name AS staff_full_name,
	SUM(si.list_price * si.quantity * (1 - si.discount)) AS total_order_price
FROM sales.orders AS so
JOIN sales.customers AS sc ON so.customer_id = sc.customer_id
JOIN sales.stores AS ss ON so.store_id = ss.store_id 
JOIN sales.staffs AS st ON so.staff_id = st.staff_id
JOIN sales.order_items AS si ON so.order_id = si.order_id
WHERE so.order_status = 4
GROUP BY so.order_id, sc.first_name, sc.last_name, ss.store_name, st.first_name, st.last_name;
GO

SELECT * FROM completed_orders;

-- 26) Create a view named vw_ProductDetails that contains:
-- ● Product Name
-- ● Brand Name
-- ● Category Name
-- ● Model Year
-- ● List Price
-- .View ثم اعرض كل البيانات من الـ
GO
CREATE VIEW vw_ProductDetails AS
SELECT 
	pp.product_name,
	pb.brand_name,
	pc.category_name,
	pp.model_year,
	pp.list_price
FROM production.products AS pp 
JOIN production.categories AS pc ON pp.category_id = pc.category_id
JOIN production.brands AS pb ON pp.brand_id = pb.brand_id
GO 

SELECT * FROM vw_ProductDetails;

-- 27) Create a view that shows the total sales for each store. 
-- Columns:
-- ● Store Name
-- ● Total Sales
GO 
CREATE VIEW vw_total_sales AS 
SELECT ss.store_name, SUM(si.list_price * si.quantity * (1 - si.discount)) AS total_sales
FROM sales.stores AS ss 
JOIN sales.orders AS so ON ss.store_id = so.store_id
JOIN sales.order_items AS si ON so.order_id = si.order_id
GROUP BY ss.store_name;
GO

SELECT * FROM vw_total_sales;

-- 28) Using a CTE, display customers who spent more than the average customer spending.
-- Columns:
-- ● Customer ID
-- ● Customer Name
-- ● Total Spending
WITH cte_customer_spending AS (
	SELECT 
		sc.customer_id,
		sc.first_name + ' ' + sc.last_name AS full_name,
		SUM(si.list_price * si.quantity * (1 - si.discount)) AS total_spending
	FROM sales.customers AS sc
	JOIN sales.orders AS so ON sc.customer_id = so.customer_id
	JOIN sales.order_items AS si ON so.order_id = si.order_id
	GROUP BY sc.customer_id, sc.first_name, sc.last_name
)

SELECT * FROM cte_customer_spending
WHERE total_spending > (SELECT AVG(total_spending) FROM cte_customer_spending); 

-- 29) Using a CTE, rank products from highest to lowest revenue using ROW_NUMBER().
-- Columns:
-- ● Rank
-- ● Product Name
-- ● Revenue
WITH cte_rank_products AS (
	SELECT 
		ROW_NUMBER() OVER(ORDER BY SUM(si.list_price * si.quantity * (1 - si.discount)) DESC) AS Rank,
		pp.product_name,
		SUM(si.list_price * si.quantity * (1 - si.discount)) AS total_revenue
	FROM production.products AS pp
	JOIN sales.order_items AS si ON pp.product_id = si.product_id
	GROUP BY pp.product_name
)

SELECT * FROM cte_rank_products;

-- 30) Using a CTE, display the top 5 most sold bikes.
-- Columns:
-- ● Product Name
-- ● Total Quantity Sold
WITH cte_most_sold_bikes AS (
	SELECT pp.product_name, SUM(si.quantity) AS total_sold
	FROM production.products AS pp
	JOIN sales.order_items AS si ON pp.product_id = si.product_id
	GROUP BY pp.product_name
)

SELECT TOP 5 * FROM cte_most_sold_bikes
ORDER BY total_sold DESC;

-- 31) Using a recursive CTE, display the staff hierarchy (Manager → Employee).
-- Columns:
-- ● Staff Name
-- ● Manager Name
-- ● Level
-- (.staffs في جدول id_manager يعتمد على وجود)

WITH cte_staff_rec AS (
	SELECT
		st.staff_id,
		st.first_name + ' ' + st.last_name AS staff_name,
		CAST(NULL AS VARCHAR(101)) AS manager_name,
		0 AS level
	FROM sales.staffs AS st
	WHERE st.manager_id IS NULL
	
	UNION ALL

	SELECT 
		st.staff_id,
		st.first_name + ' ' + st.last_name AS staff_name,
		csr.staff_name AS manager_name,
		csr.level + 1
	FROM sales.staffs AS st
	JOIN cte_staff_rec AS csr ON st.manager_id = csr.staff_id 
)

SELECT * FROM cte_staff_rec 
ORDER BY level, staff_id;

-- 32) Find all products whose price is higher than the average product price using a subquery.
SELECT * FROM production.products AS pp
WHERE pp.list_price > (SELECT AVG(pp.list_price) AS avg_total_price FROM production.products AS PP);

-- 33) Find customers who have placed more orders than the average number of orders per customer.
SELECT so.customer_id FROM sales.orders AS so
GROUP BY SO.customer_id
HAVING COUNT(so.order_id) > (SELECT AVG(order_count) 
							 FROM(SELECT so.customer_id, COUNT(so.order_id) AS order_count 
								  FROM sales.orders AS so 
								  GROUP BY so.customer_id) 
							 AS oc);

-- 34) Display the most expensive bike(s) using a subquery only.
SELECT pp.product_name, pp.list_price
FROM production.products AS pp
WHERE pp.list_price = (SELECT MAX(pp.list_price) FROM production.products AS pp);

-- 35) Find all products that have never been ordered.
SELECT 
	pp.product_id,
	pp.product_name
FROM production.products AS pp
WHERE NOT EXISTS (
	SELECT 1 
	FROM sales.order_items AS si
	WHERE si.product_id = pp.product_id
);

-- 36) Find the store with the highest total sales using a subquery.
SELECT TOP 1 ss.store_name
FROM (
	SELECT
		so.store_id,
		SUM(si.list_price * quantity * (1 - si.discount)) AS total_sold
	FROM sales.orders AS so
	JOIN sales.order_items AS si ON so.order_id = si.order_id
	GROUP BY so.store_id
	) AS ts
JOIN sales.stores AS ss ON ts.store_id = ss.store_id
ORDER BY ts.total_sold DESC;

-- 37) Display customers who purchased products from the most liked brand.
SELECT DISTINCT
    sc.first_name + ' ' + sc.last_name AS full_name
FROM sales.customers AS sc
JOIN sales.orders AS so
    ON sc.customer_id = so.customer_id
JOIN sales.order_items AS si
    ON so.order_id = si.order_id
JOIN production.products AS pp
    ON si.product_id = pp.product_id
JOIN production.brands AS pb
    ON pp.brand_id = pb.brand_id
WHERE pb.brand_id = (
    SELECT TOP 1
        pp.brand_id
    FROM sales.order_items AS si
    JOIN production.products AS pp
        ON si.product_id = pp.product_id
    GROUP BY pp.brand_id
    ORDER BY SUM(si.quantity) DESC
);

-- 38) Find categories whose total sales are above the average category sales.
WITH category_sales AS (
    SELECT
        pc.category_id,
        pc.category_name,
        SUM(soi.quantity * soi.list_price) AS total_sales
    FROM production.categories AS pc
    JOIN production.products AS pp ON pc.category_id = pp.category_id
    JOIN sales.order_items AS soi ON pp.product_id = soi.product_id
    GROUP BY
        pc.category_id,
        pc.category_name
)
SELECT
    category_name,
    total_sales
FROM category_sales
WHERE total_sales > (
    SELECT AVG(total_sales)
    FROM category_sales
);

-- 39) Display the products whose price is greater than the average price of their category.
SELECT
    pp.product_name,
    pp.list_price,
    pc.category_name
FROM production.products AS pp
JOIN production.categories AS pc ON pp.category_id = pc.category_id
WHERE pp.list_price > (
    SELECT AVG(pp2.list_price)
    FROM production.products AS pp2
    WHERE pp2.category_id = pp.category_id
);

-- 40) Find the staff member who processed the highest number of completed orders.
SELECT TOP 1
    ss.first_name + ' ' + ss.last_name AS full_name,
    COUNT(so.order_id) AS completed_orders
FROM sales.staffs AS ss
JOIN sales.orders AS so
    ON ss.staff_id = so.staff_id
WHERE so.order_status = 4
GROUP BY
    ss.staff_id,
    ss.first_name,
    ss.last_name
ORDER BY completed_orders DESC;

-------------------------------------------------------------------
-- Bonus (Advanced SQL)
-- 41) Create a view named vw_CustomerSales showing:
-- ● Customer ID
-- ● Customer Name
-- ● Number of Orders
-- ● Total Spending
GO
CREATE VIEW vw_CustomerSales AS 
	SELECT 
		sc.customer_id,
		sc.first_name + ' ' + sc.last_name AS full_name,
		COUNT(DISTINCT si.order_id) AS number_of_orders,
		SUM(si.list_price * si.quantity) AS total_spending
	FROM sales.customers AS sc
	JOIN sales.orders AS so ON sc.customer_id = so.customer_id
	JOIN sales.order_items AS si ON so.order_id = si.order_id
	GROUP BY 
		sc.customer_id,
		sc.first_name,
		sc.last_name
GO

SELECT * FROM vw_CustomerSales;

-- 42) Using the view created in Question 41, display customers whose total spending is
-- greater than the average spending of all customers.

SELECT
    customer_id,
    full_name,
    number_of_orders,
    total_spending
FROM vw_CustomerSales
WHERE total_spending > (
    SELECT AVG(total_spending)
    FROM vw_CustomerSales
);

-- 43) Using a CTE, calculate the cumulative sales by order date.
-- Columns:
-- ● Order Date
-- ● Daily Sales
-- ● Running Total

WITH daily_sales AS (
    SELECT
        so.order_date,
        SUM(soi.quantity * soi.list_price) AS daily_sales
    FROM sales.orders AS so
    JOIN sales.order_items AS soi
        ON so.order_id = soi.order_id
    GROUP BY so.order_date
)
SELECT
    order_date,
    daily_sales,
    SUM(daily_sales) OVER (
        ORDER BY order_date
    ) AS running_total
FROM daily_sales
ORDER BY order_date;

-- 44) Using a subquery, find the second most expensive bike.
SELECT
    product_id,
    product_name,
    list_price
FROM production.products
WHERE list_price = (
    SELECT MAX(list_price)
    FROM production.products
    WHERE list_price < (
        SELECT MAX(list_price)
        FROM production.products
    )
);