-- ==================================
-- FILTERS & AGGREGATION
-- ==================================

USE coffeeshop_db;


-- Q1) Compute total items per order.
--     Return (order_id, total_items) from order_items.

select sum(quantity) as total_items, order_id from order_items 
group by order_id;
 

-- Q2) Compute total items per order for PAID orders only.
--     Return (order_id, total_items). Hint: order_id IN (SELECT ... FROM orders WHERE status='paid').

select order_id, sum(quantity) as total_items
from order_items 
where order_id in (select order_id from orders where status='paid')
group by order_id;

-- Q3) How many orders were placed per day (all statuses)?
--     Return (order_date, orders_count) from orders.

select date(order_datetime), count(order_id) as orders_count
from orders
group by date(order_datetime);

-- Q4) What is the average number of items per PAID order?
--     Use a subquery or CTE over order_items filtered by order_id IN (...).

select avg(total_items) as average_qty
from (
    select sum(quantity) as total_items
    from order_items 
    where order_id in ( select order_id from orders where status = 'paid') 
    group by order_id
) as subquery;


-- Q5) Which products (by product_id) have sold the most units overall across all stores?
--     Return (product_id, total_units), sorted desc.
select product_id, sum(quantity) as total_units
from order_items
group by product_id
order by total_units desc;
    
-- Q6) Among PAID orders only, which product_ids have the most units sold?
--     Return (product_id, total_units_paid), sorted desc.
--     Hint: order_id IN (SELECT order_id FROM orders WHERE status='paid').

select product_id, sum(quantity) as total_units_paid
from order_items
where order_id in (select order_id from orders where status='paid')
group by product_id
order by total_units_paid desc;


-- Q7) For each store, how many UNIQUE customers have placed a PAID order?
--     Return (store_id, unique_customers) using only the orders table.

select store_id, count(distinct customer_id) as unique_customers
from orders
where status = 'paid'
group by store_id
order by unique_customers desc; 
 

-- Q8) Which day of week has the highest number of PAID orders?
--     Return (day_name, orders_count). Hint: DAYNAME(order_datetime). Return ties if any.

with daily_counts as (
	select DAYNAME(order_datetime) as day_name, count(order_id) as orders_count 
	from orders
    where status = 'paid'
	group by day_name )

select day_name, orders_count from daily_counts
where orders_count = (select MAX(orders_count ) from daily_counts)
group by day_name
order by day_name limit 2;

-- Q9) Show the calendar days whose total orders (any status) exceed 3.
--     Use HAVING. Return (order_date, orders_count).

select date(order_datetime) as order_date, count(order_id) as orders_count from orders
group by order_date
having orders_count > 3
order by order_date; 


-- Q10) Per store, list payment_method and the number of PAID orders.
--      Return (store_id, payment_method, paid_orders_count).
select store_id, payment_method, count(payment_method) as paid_orders_count
from orders
where status = 'paid'
group by store_id, payment_method
order by store_id;



-- Q11) Among PAID orders, what percent used 'app' as the payment_method?
--      Return a single row with pct_app_paid_orders (0–100).

select 
	round ( 100.0 * app_payments / total_paid_orders, 0)
    as pct_paid_orders 
from (
	select
	count(*) as total_paid_orders, 
    count(case when payment_method = 'app' then 1 end) as app_payments
    from orders
    where status = 'paid'
) as subquery;


-- Q12) Busiest hour: for PAID orders, show (hour_of_day, orders_count) sorted desc.

select HOUR(order_datetime) as hour_of_day, count(order_id) as orders_count
from orders 
where status='paid' 
group by hour_of_day
order by orders_count desc;




-- ================
