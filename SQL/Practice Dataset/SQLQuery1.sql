create database Parch_Posey;
use Parch_Posey;

-- =========================
-- accounts
-- =========================

ALTER TABLE accounts
ALTER COLUMN website VARCHAR(255) NULL;

ALTER TABLE accounts
ALTER COLUMN lat FLOAT NULL;

ALTER TABLE accounts
ALTER COLUMN [long] FLOAT NULL;

ALTER TABLE accounts
ALTER COLUMN primary_poc VARCHAR(255) NULL;


-- =========================
-- web_events
-- =========================

ALTER TABLE web_events
ALTER COLUMN occurred_at DATETIME NULL;

ALTER TABLE web_events
ALTER COLUMN channel VARCHAR(255) NULL;


-- =========================
-- orders
-- =========================

ALTER TABLE orders
ALTER COLUMN occurred_at DATETIME NULL;

ALTER TABLE orders
ALTER COLUMN standard_qty INT NULL;

ALTER TABLE orders
ALTER COLUMN gloss_qty INT NULL;

ALTER TABLE orders
ALTER COLUMN poster_qty INT NULL;

ALTER TABLE orders
ALTER COLUMN total INT NULL;

ALTER TABLE orders
ALTER COLUMN standard_amt_usd FLOAT NULL;

ALTER TABLE orders
ALTER COLUMN gloss_amt_usd FLOAT NULL;

ALTER TABLE orders
ALTER COLUMN poster_amt_usd FLOAT NULL;

ALTER TABLE orders
ALTER COLUMN total_amt_usd FLOAT NULL;

-- =========================
-- INSERT INTO accounts
-- =========================

INSERT INTO accounts
(id, name, website, lat, [long], primary_poc, sales_rep_id)
VALUES
(4001, 'Future Tech', NULL, 30.0444, 31.2357, NULL, 1),
(4002, 'Smart Solutions', 'SMART.COM', NULL, NULL, 'Ahmed Ali', 2);

INSERT INTO accounts
(id, name, website, lat, [long], primary_poc, sales_rep_id)
VALUES
(4003, 'ABC Company', 'abc1.com', 30.2, 31.1, 'Sara', 3),
(4004, 'ABC Company', 'abc2.com', 30.3, 31.2, 'Mona', 3);

INSERT INTO accounts
(id, name, website, lat, [long], primary_poc, sales_rep_id)
VALUES
(4005, 'Tech Vision', 'duplicate.com', 30.5, 31.5, 'Ali', 4),
(4006, 'AI World', 'duplicate.com', 30.6, 31.6, 'Omar', 4);

INSERT INTO accounts
(id, name, website, lat, [long], primary_poc, sales_rep_id)
VALUES
(4007, 'Delta Company', 'delta.com', 30.7, 31.7, 'Karim Hassan', 5);

-- =========================
-- INSERT INTO web_events
-- =========================

INSERT INTO web_events
(id, account_id, occurred_at, channel)
VALUES
(9001, 4001, GETDATE(), 'facebook'),
(9002, 4001, GETDATE(), 'Facebook'),
(9003, 4001, GETDATE(), 'FACEBOOK'),
(9004, 4001, GETDATE(), 'fb'),
(9005, 4001, GETDATE(), 'google'),
(9006, 4001, GETDATE(), 'Google Ads');

INSERT INTO web_events
(id, account_id, occurred_at, channel)
VALUES
(9007, 4002, GETDATE(), NULL);

-- =========================
-- INSERT INTO orders
-- =========================

INSERT INTO orders
(id, account_id, occurred_at,
standard_qty, gloss_qty, poster_qty,
total, standard_amt_usd, gloss_amt_usd,
poster_amt_usd, total_amt_usd)
VALUES
(8001, 4001, GETDATE(), 100, 50, 20, 170, 7000, 1000, 500, 8500),
(8002, 4001, GETDATE(), 10, 5, 2, 17, 12000, 500, 300, 12800),
(8003, 4002, GETDATE(), 2, 1, 0, 3, 1500, 200, 0, 1700);

INSERT INTO orders
(id, account_id, occurred_at,
standard_qty, gloss_qty, poster_qty,
total, standard_amt_usd, gloss_amt_usd,
poster_amt_usd, total_amt_usd)
VALUES
(8004, 4002, NULL,
NULL, NULL, NULL,
NULL, NULL, NULL, NULL, NULL);

-- =========================
-- DELETE DATA
-- =========================

DELETE FROM orders
WHERE id BETWEEN 8001 AND 8004;

DELETE FROM web_events
WHERE id BETWEEN 9001 AND 9007;

DELETE FROM accounts
WHERE id BETWEEN 4001 AND 4007;


select *,
       case
           when standard_qty >= gloss_qty and standard_qty >= poster_qty then 'Standard Order'
           when gloss_qty >= standard_qty and gloss_qty >= poster_qty then 'Gloss Order'
           else 'Poster Order'
       end as paper_type
from orders;

select account_id,
    sum(o.total_amt_usd) as total_sales,
    case
        when SUM(o.total_amt_usd) >= 200000 then 'VIP'
        when SUM(o.total_amt_usd) >= 50000 then 'Regular'
        else 'New'
    end as customer_type
from orders o
group by account_id;




select r.   name, sum(o.total_amt_usd) as total_sales,
    case 
        when sum(o.total_amt_usd) >= 1000000 then 'excellent'
        when sum(o.total_amt_usd) >= 500000 then 'good'
        else 'needs improvments'
    end as region_sts
from region r
join sales_reps s on r.id = s.region_id
join accounts a on s.id = a.sales_rep_id
join orders o on a.id = o.account_id
group by r.name;


select r.name as Region,
       year(o.occurred_at) as Year,
       month(o.occurred_at) as Month,
       sum(o.total) as Revenue
from orders o
join accounts a on o.account_id = a.id
join sales_reps sr on a.sales_rep_id = sr.id
join region r on sr.region_id = r.id
group by r.name, year(o.occurred_at), month(o.occurred_at)
order by r.name, Year, Month;

select a.id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id from accounts a
left join orders o on a.id = o.account_id
group by a.id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id
having datediff(getdate(), max(o.occurred_at)) > 365 or max(o.occurred_at) is null;


select a.name as account_name,
       sum(o.total_amt_usd) as total_revenue
from accounts a
join orders o on a.id = o.account_id
group by a.id
having sum(o.total_amt_usd) = 
        ( select max(total_revenue) from ( select sum(total_amt_usd) as total_revenue
                                           from orders 
                                           group by account_id
                                          ) as account_revenue
        );


CREATE VIEW vw_monthly_revenue AS
SELECT
    YEAR(occurred_at) AS Year,
    MONTH(occurred_at) AS Month,
    COUNT(*) AS Total_Orders,
    SUM(total_amt_usd) AS Total_Revenue,
    AVG(total_amt_usd) AS Average_Order_Value
FROM orders
GROUP BY YEAR(occurred_at), MONTH(occurred_at);

SELECT *
FROM vw_monthly_revenue
ORDER BY Year, Month;