CREATE DATABASE food_delivery_db;

USE food_delivery_db;

CREATE TABLE restaurants (
  restaurant_id INT PRIMARY KEY,
  restaurant_name VARCHAR(100),
 city VARCHAR(50),
 cuisine_type VARCHAR(50),
restaurant_rating DECIMAL(2,1)
);
select * from restaurants;

select  order_id


CREATE TABLE customers (
customer_id INT PRIMARY KEY,
 customer_name VARCHAR(100),
 city VARCHAR(50),
 signup_date DATE,
 age INT,
 gender VARCHAR(10)
);

select * from customers;


CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    restaurant_id INT,
    order_date DATE,
    quantity INT,
    order_amount DECIMAL(10,2),
    discount DECIMAL(10,2),
    payment_method VARCHAR(30),
    order_status VARCHAR(20),
    delivery_time_minutes INT,
    rating INT,

    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);

select * from orders;

USE food_delivery_db;


-- 1. Show all orders placed in December 2025
select order_id,  order_date, order_amount, order_status
FROM orders
WHERE order_date between'2025-12-01' and '2025-12-31'
ORDER BY order_date;


-- 2. Show customers above 50 years old
SELECT customer_id, customer_name, age, gender
FROM customers
WHERE age > 50
ORDER BY age desc;


-- 3. List all restaurants in Pune
select  restaurant_id, restaurant_name
FROM restaurants
WHERE city = 'Pune'
ORDER BY restaurant_name;


-- 4. Find customers with missing age or gender
select customer_id, customer_name, age, gender
FROM customers
WHERE age IS NULL OR gender IS NULL;


-- 5. Show the 10 highest-value orders
select order_id, customer_id, order_amount, order_status
FROM orders
order by order_amount DESC
limit 10;


-- 6. Find the total number of orders
SELECT COUNT(*) AS total_orders
FROM orders;



-- 7. Find the total revenue from delivered orders
SELECT SUM(order_amount) AS total_revenue
FROM orders
WHERE order_status = 'Delivered';

-- i
select * from orders;
-- 8. Find the average order amount
SELECT ROUND(AVG(order_amount), 2) AS average_order_amount
FROM orders;

select order_id, order_date
 (select round(avg(order_amount),2) As average_order_amount),
from orders;

-- 9. Find the highest and lowest order amount
SELECT MAX(order_amount) AS highest_order_amount,
MIN(order_amount) AS lowest_order_amount
FROM orders;


-- 10. Find the total number of orders for each payment method
SELECT payment_method, COUNT(*) AS total_orders
FROM orders
GROUP BY payment_method
ORDER BY total_orders DESC;

select * from orders;

-- 11. Find month-wise revenue for 2025
select monthname(order_date) as month_name,
sum(order_amount) as total_revenue
From orders
where year(order_date) = 2025
group by month(order_date) , monthname(order_date)
order by month(order_date) desc;



select * from orders;
-- 12. Find customers who placed an order above ₹1,500
select distinct c.customer_id, c.customer_name
FROM customers c
JOIN orders o on c.customer_id = o.customer_id
WHERE o.order_amount > 1500;

-- 13. Find customers who never placed an order
select c.customer_id, c.customer_name, c.city
FROM customers c
left join orders o 
on  c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- 14. Find restaurants with a rating above 4.0
select restaurant_name, cuisine_type, restaurant_rating
from restaurants
where restaurant_rating > 4.0
ORDER BY restaurant_rating desc;


-- 15. Find restaurants that received at least one cancelled order
select distinct r.restaurant_id, r.restaurant_name
FROM restaurants r
JOIN orders o
on  r.restaurant_id = o.restaurant_id
WHERE o.order_status = 'Cancelled';


-- 16. Find the number of orders placed by each customer
select c.customer_id, c.customer_name,COUNT(o.order_id) AS total_orders
FROM customers c JOIN orders o
on c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_orders desc;


-- 17. Show each order along with the average order amount for its restaurant
select order_id, restaurant_id, order_amount,
ROUND(avg(order_amount) OVER (PARTITION BY restaurant_id),2 ) as restaurant_avg_order
FROM orders
ORDER BY restaurant_id;



-- 18. List all distinct cities where the business has either a customer or a restaurant
SELECT city FROM customers
UNION
SELECT city FROM restaurants;



-- hard

-- 19. Find total orders and revenue for each restaurant
SELECT r.restaurant_name,COUNT(o.order_id) as total_orders,SUM(o.order_amount) as total_revenue
FROM restaurants r JOIN orders o 
on r.restaurant_id = o.restaurant_id
WHERE o.order_status = 'Delivered'
GROUP BY r.restaurant_id, r.restaurant_name
ORDER BY total_revenue desc;

-- 20. Categorize each order based on order amount
SELECT order_id, order_amount,
CASE
WHEN order_amount >= 2000 then 'High Value'
WHEN order_amount >= 1000 then 'Medium Value'
else 'Low Value'
END as order_category
FROM orders;

-- 21. Find customers who placed more than 5 orders
SELECT c.customer_id, c.customer_name,count(o.order_id) as total_orders
FROM customers c
JOIN orders o on c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING count(o.order_id) > 5
ORDER BY total_orders DESC;


-- 22. Find restaurants that have more than 50 delivered orders
SELECT r.restaurant_name,count(o.order_id) as delivered_orders
FROM restaurants r
JOIN orders o on  r.restaurant_id = o.restaurant_id
WHERE o.order_status = 'Delivered'
GROUP BY r.restaurant_id, r.restaurant_name
HAVING count(o.order_id) > 50
ORDER BY delivered_orders DESC;


-- 23. Find customers who ordered from more than 2 restaurants
SELECT c.customer_id, c.customer_name,
count(DISTINCT o.restaurant_id) as restaurant_count
FROM customers c
JOIN orders o on c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING count(DISTINCT o.restaurant_id) > 2
ORDER BY restaurant_count DESC;

































-- 24.Find the top 5 restaurants by total number of orders received.
SELECT r.restaurant_id, r.restaurant_name, COUNT(o.order_id) AS total_orders
FROM restaurants r
JOIN orders o on r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_id, r.restaurant_name
ORDER BY total_orders DESC
LIMIT 5;

-- 25. Find the top 5 customers by total spending
SELECT c.customer_name,SUM(o.order_amount) as total_spending
FROM customers c
JOIN orders o on c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spending DESC
LIMIT 5;



-- 26. Find the top 3 highest-value orders for each restaurant
SELECT order_id, restaurant_id, order_amount, restaurant_rank
FROM ( SELECT order_id, restaurant_id, order_amount, 
RANK() OVER (
PARTITION BY restaurant_id
ORDER BY order_amount DESC ) as restaurant_rank
FROM orders) AS ranked_orders
WHERE restaurant_rank <= 3
ORDER BY restaurant_id, restaurant_rank;




-- 27. Find the running (cumulative) total of delivered revenue by date
WITH daily_revenue AS ( SELECT order_date, SUM(order_amount) AS daily_total
FROM orders
WHERE order_status = 'Delivered'
GROUP BY order_date)
SELECT order_date, daily_total,
SUM(daily_total) OVER (ORDER BY order_date) AS running_total_revenue
FROM daily_revenue
ORDER BY order_date;