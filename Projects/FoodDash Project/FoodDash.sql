create database FoodDash;

use FoodDash;

create table dbo.Customers
(
	customer_id int identity(1, 1) primary key,
	full_name nvarchar(100) not null,
	city nvarchar(100) not null,
	gender nvarchar(10) not null,
	signup_date date default getdate()
);

------------------------------------------------------------

create table dbo.Restaurants
(	
	restaurant_id int identity(1, 1) primary key,
	restaurant_name nvarchar(100) not null,
	city nvarchar(100) not null,
	category nvarchar(100) not null
);

------------------------------------------------------------

create table dbo.DeliveryPartners 
(
	partner_id int identity(1, 1) primary key,
	partner_name nvarchar(100) not null,
	city nvarchar(100) not null
);

------------------------------------------------------------

create table dbo.Orders 
( 
	order_id int identity(1, 1) primary key, 
	customer_id int not null, 
	restaurant_id int not null, 
	partner_id int not null, 
	city nvarchar(100) not null, 
	order_date date default getdate(), 
	total_amount decimal(10, 2) not null, 
	delivery_fee decimal(10, 2) not null, 
	status varchar(30) not null,
	
	constraint fk_Orders_Customers 
		foreign key(customer_id) 
		references Customers(customer_id), 
		
	constraint fk_Orders_Restaurants 
		foreign key(restaurant_id) 
		references Restaurants(restaurant_id), 
		
	constraint fk_Orders_DeliveryPartners 
		foreign key(partner_id) 
		references DeliveryPartners(partner_id) 
);

------------------------------------------------------------

-- Part 1 — Basic SELECT

-- Task 1
select * from dbo.Customers; 

-- Task 2
select full_name from dbo.Customers;

-- Task 3
select restaurant_name, category from dbo.Restaurants;

-- Task 4
select distinct city from dbo.Customers;

-- Task 5
select top 10 * from dbo.Orders
order by order_id;

------------------------------------------------------------

-- Part 2 — Filtering Data

-- Task 1
select * from dbo.Orders
where status = 'Delivered';

-- Task 2
select * from dbo.Orders
where status = 'Cancelled';

-- Task 3
select * from dbo.Orders
where total_amount > 500;

-- Task 4
select * from dbo.Orders
where total_amount between 300 and 800;

-- Task 5
select * from dbo.Customers
where city = 'Cairo';

-- Task 6
select * from dbo.Restaurants
where city = 'Alexandria';

-- Task 7 
select * from dbo.Customers
where city = 'Cairo' or city = 'Giza';

-- Task 8
select * from dbo.Customers
where full_name like 'A%';

-- Task 9 
select * from dbo.Restaurants
where restaurant_name like '%House';

-- Task 10
select * from dbo.Orders
where order_date > '2026-01-01';

------------------------------------------------------------

-- Part 3 — Sorting

-- Task 1
select * from dbo.Orders
order by total_amount desc;

-- Task 2
select * from dbo.Orders
order by delivery_fee;

-- Task 3
select * from dbo.Orders
order by order_date desc;

------------------------------------------------------------

-- Part 4 — Aggregate Functions

-- Task 1
select count(*) as total_customers from dbo.Customers;

-- Task 2
select count(*) as total_restaurants from dbo.Restaurants;

-- Task 3
select count(*) as delivered_orders from dbo.Orders
where status = 'Delivered';

-- Task 4
select sum(total_amount) as total_revenue from dbo.Orders;

-- Task 5
select sum(delivery_fee) as total_delivery_fees from dbo.Orders;

-- Task 6
select avg(total_amount) as average_order_amount from dbo.Orders;

-- Task 7
select avg(delivery_fee) as average_delivery_fee from dbo.Orders;

-- Task 8
select min(total_amount) as smallest_order_amount from dbo.Orders;

-- Task 9
select max(total_amount) as highest_order_amount from dbo.Orders;

------------------------------------------------------------

-- Part 5 — GROUP BY

-- Task 1
select city, count(*) as total_orders from dbo.Orders
group by city;

-- Task 2
select city, sum(total_amount) as total_revenue from dbo.Orders
group by city;

-- Task 3
select status, count(*) as total_orders from dbo.Orders
group by status;

-- Task 4
select r.restaurant_name, sum(o.total_amount) as total_revenue from dbo.Orders as o
inner join dbo.Restaurants as r on o.restaurant_id = r.restaurant_id
group by r.restaurant_name;

-- Task 5 
select city, avg(total_amount) as average_order_amount from dbo.Orders
group by city;

-- Task 6
select partner_id, count(*) as completed_orders from dbo.Orders
where status = 'Delivered'
group by partner_id;

------------------------------------------------------------

-- Part 6 — HAVING

-- Task 1 
select city, count(*) as total_orders from dbo.Orders
group by city
having count(*) > 100;

-- Task 2 
select r.restaurant_name, sum(o.total_amount) as total_revenue from dbo.Orders as o
inner join dbo.Restaurants as r on o.restaurant_id = r.restaurant_id
group by r.restaurant_name 
having sum(o.total_amount) > 50000;

-- Task 3 
select o.city, avg(o.total_amount) as average_order_value from dbo.Orders as o
group by o.city
having avg(o.total_amount) > 400;

-- Task 4
select dp.partner_name, count(*) as completed_orders from dbo.Orders as o
inner join dbo.DeliveryPartners as dp on o.partner_id = dp.partner_id
where o.status = 'Delivered'
group by dp.partner_name 
having count(*) > 80;

------------------------------------------------------------

-- Business KPI Challenge

-- Task 1
select count(*) as total_orders from dbo.Orders;

-- Task 2
select sum(total_amount) as total_revenue from dbo.Orders;

-- Task 3
select avg(total_amount) as avg_order_value from dbo.Orders;

-- Task 4 
select top 1 city, sum(total_amount) as total_revenue from dbo.Orders
group by city
order by total_revenue desc;

-- Task 5
select top 1 r.restaurant_name, sum(o.total_amount) as total_revenue from dbo.Orders as o
inner join dbo.Restaurants as r on o.restaurant_id = r.restaurant_id
group by r.restaurant_name 
order by total_revenue desc;

-- Task 6
select top 1 dp.partner_name, count(*) as completed_orders from dbo.Orders as o
inner join dbo.DeliveryPartners as dp on o.partner_id = dp.partner_id
where o.status = 'Delivered'
group by dp.partner_name 
order by completed_orders desc;

-- Task 7
select top 1 status, count(*) as total_orders from dbo.Orders 
group by status
order by total_orders desc;

-- Task 8 
select top 5 city, count(*) as total_orders from dbo.Orders 
group by city
order by total_orders desc;

-- Task 9 
select r.restaurant_name, sum(o.total_amount) as total_revenue from dbo.Orders as o
inner join dbo.Restaurants as r on o.restaurant_id = r.restaurant_id
group by r.restaurant_name
having sum(o.total_amount) > 50000;

-- Task 10
select city, avg(total_amount) as avg_order_revenue from dbo.Orders
group by city 
having avg(total_amount) > 400;

------------------------------------------------------------

-- Bonus Challenges

-- Task 1 
select top 3 r.restaurant_name, sum(o.total_amount) as total_revenue from dbo.Orders as o
inner join dbo.Restaurants as r on o.restaurant_id = r.restaurant_id
group by r.restaurant_name 
order by total_revenue desc;

-- Task 2 
select top 1 city, avg(total_amount) as avg_order_value from dbo.Orders
group by city
order by avg_order_value desc;

-- Task 3
select top 5 * from dbo.Orders
order by total_amount desc;

-- Task 4
select category, count(*) as total_restaurants from dbo.Restaurants
group by category;

-- Task 5
select top 1 r.category, sum(o.total_amount) as total_revenue from dbo.Orders as o
inner join dbo.Restaurants as r on o.restaurant_id = r.restaurant_id
group by category 
order by total_revenue desc;

-- Task 6
select top 1 
	year(order_date) as order_year,
	month(order_date) as order_month,
	count(*) as total_orders 
from dbo.Orders
group by year(order_date), month(order_date)
order by total_orders desc;

-- Task 7
select city, avg(delivery_fee) as avg_delivery_fee from dbo.Orders
group by city;

-- Task 8 
select city, count(*) as total_orders from dbo.Orders
group by city
having count(*) > 200;

-- Task 9 
select r.restaurant_name, count(*) as total_orders from dbo.Orders as o
inner join dbo.Restaurants as r on o.restaurant_id = r.restaurant_id
group by r.restaurant_name 
having count(*) > 500;

-- Task 10
select city, 
	count(*) as no_of_orders,
	sum(total_amount) as total_revenue,
	avg(total_amount) as avg_revenue_value,
	max(total_amount) as highest_order,
	min(total_amount) as lowest_order
from dbo.Orders
group by city 