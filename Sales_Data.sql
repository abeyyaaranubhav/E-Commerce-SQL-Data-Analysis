-- Create Database
CREATE DATABASE ecommerce_analysis;
USE ecommerce_analysis;
-- Create Tables
-- Customers
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50),
    signup_date DATE
);
-- Products
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);
-- Orders
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
-- Order Details
CREATE TABLE order_details (
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
-- Sample data
INSERT INTO customers VALUES
(1,'Amit Sharma','amit@gmail.com','Delhi','2023-01-10'),
(2,'Riya Verma','riya@gmail.com','Mumbai','2023-02-15'),
(3,'Kunal Singh','kunal@gmail.com','Bangalore','2023-03-20'),
(4,'Neha Gupta','neha@gmail.com','Delhi','2023-04-18');
INSERT INTO products VALUES
(101,'Wireless Mouse','Electronics',799),
(102,'Bluetooth Speaker','Electronics',2499),
(103,'Notebook','Stationery',199),
(104,'Water Bottle','Accessories',499);
INSERT INTO orders VALUES
(1001,1,'2023-06-01',3297),
(1002,2,'2023-06-05',199),
(1003,1,'2023-07-10',2499),
(1004,3,'2023-07-12',1298),
(1005,4,'2023-08-01',499);
INSERT INTO order_details VALUES
(1,1001,101,1,799),
(2,1001,102,1,2499),
(3,1002,103,1,199),
(4,1003,102,1,2499),
(5,1004,101,1,799),
(6,1004,104,1,499),
(7,1005,104,1,499);
-- Total Revenue
SELECT SUM(total_amount) AS total_revenue
FROM orders;
-- Monthly Revenue Trend
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(total_amount) AS revenue
FROM orders
GROUP BY month
ORDER BY month;
-- Top-Selling Products
SELECT 
    p.product_name,
    SUM(od.quantity) AS total_sold
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC;
-- Revenue by Category
SELECT 
    p.category,
    SUM(od.quantity * od.price) AS revenue
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.category;
-- Top Customers by Spending
SELECT 
    c.customer_name,
    SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_spent DESC;
-- Repeat Customers
SELECT 
    customer_id,
    COUNT(order_id) AS order_count
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1;
-- Average Order Value
SELECT AVG(total_amount) AS avg_order_value
FROM orders;
-- Customer Ranking
SELECT 
    c.customer_name,
    SUM(o.total_amount) AS total_spent,
    RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS spending_rank
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name;
-- Customer Lifetime Value
SELECT 
    customer_id,
    SUM(total_amount) AS lifetime_value
FROM orders
GROUP BY customer_id;
-- Customers With No Orders
SELECT 
    c.customer_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
