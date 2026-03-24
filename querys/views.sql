
CREATE VIEW analytics_sales_base AS
SELECT 
    s.order_id,
	s.customer_id,
    s.product_id,
	s.date,
    s.quantity,
    s.unit_price,
	s.channel,
	s.region,
	CASE 
        WHEN s.discount IS NULL OR s.discount = 0 THEN 'No Discount'
        ELSE 'Discount Applied'
    END AS discount_analysis,
    COALESCE(s.discount,0) AS discount,
    ROUND(
        s.quantity * s.unit_price * (1-COALESCE(s.discount,0)),2
    ) AS revenue,
    ROUND(
        (s.quantity * s.unit_price * (1-COALESCE(s.discount,0)))
        -
        (s.quantity * p.cost),2
    ) AS profit
FROM sales s
LEFT JOIN products p
ON s.product_id = p.product_id;

CREATE VIEW Dim_products AS 
SELECT 
	product_id,
	product_name,
	category
FROM products;

CREATE VIEW Dim_customers AS 
SELECT 
	customer_id,
	loyalty_level
FROM customers; 