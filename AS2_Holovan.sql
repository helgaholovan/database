CREATE DATABASE a02;
USE a02;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(255),
    country VARCHAR(255)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    category VARCHAR(255),
    price DECIMAL(10,2)
);


CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

EXPLAIN analyze
SELECT
    c.customer_id,
    c.name,
    SUM(p.price * o.quantity) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN products p ON o.product_id = p.product_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC;

CREATE INDEX idx_c_customer ON customers(customer_id);
CREATE INDEX idx_products_product ON products(product_id);
CREATE INDEX idx_orders_customer_product ON orders(customer_id, product_id);
CREATE INDEX idx_orders_covering ON orders(customer_id, product_id, quantity);




EXPLAIN analyze
WITH /*+ SUBQUERY(MATERIALIZATION) */ spending_per_order AS (
    SELECT
        customer_id,
        SUM(quantity * p.price) AS order_total
    FROM orders o
    USE INDEX (idx_orders_covering)
    JOIN products p 
    ON o.product_id = p.product_id
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    c.name,
    s.order_total AS total_spent
FROM customers c 
JOIN spending_per_order s 
ON c.customer_id = s.customer_id
ORDER BY total_spent DESC;





