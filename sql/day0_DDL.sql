CREATE TABLE sales (
    order_id INT,
    customer_id INT,
    product_id INT,
    date DATE,
    quantity INT,
    unit_price NUMERIC,
    discount NUMERIC,
    channel VARCHAR(50),
    region VARCHAR(50)
);

CREATE TABLE customers (
    customer_id INT,
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    city VARCHAR(50),
    loyalty_level VARCHAR(50)
);

CREATE TABLE products (
    product_id INT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    cost NUMERIC
);

-- Validation PK Sales
SELECT order_id, product_id, COUNT(*)
FROM sales
GROUP BY order_id, product_id
HAVING COUNT(*) > 1;

-- Validaction PK customers
SELECT DISTINCT customer_id
FROM sales
WHERE customer_id NOT IN (
    SELECT customer_id FROM customers
);
-- Validation PK products
SELECT DISTINCT product_id
FROM sales
WHERE product_id NOT IN (
    SELECT product_id FROM products
);

-- Add PK and FK
ALTER TABLE customers
ADD PRIMARY KEY (customer_id);

ALTER TABLE products
ADD PRIMARY KEY (product_id);

ALTER TABLE sales
ADD PRIMARY KEY (order_id, product_id);

ALTER TABLE sales
ADD CONSTRAINT fk_sales_customer
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

ALTER TABLE sales
ADD CONSTRAINT fk_sales_product
FOREIGN KEY (product_id)
REFERENCES products(product_id);