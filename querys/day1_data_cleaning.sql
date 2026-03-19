-- ==========================================
-- DAY 1 - DATA CLEANING
-- SALES TABLE
-- ==========================================

-- ==========================================
-- STEP 1 - DATA QUALITY ASSESSMENT
-- ==========================================

SELECT * FROM sales LIMIT 100;

-- Step 1.1: Detect null values in quantity field 
SELECT COUNT(*) AS nulls_quantity
FROM sales
WHERE quantity IS NULL; /*7*/

-- Step 1.2: Detect null values in discount field
SELECT COUNT(*) AS nulls_discount
FROM sales
WHERE discount IS NULL; /*104*/

/*Se encontraron 2 problemas principales para la trazabilidad y analisis posterior del 
revenue, profit y margin, valores null en los campos de quantity, 7 registros representando 1.4% de los registros
y discount 104 registros representando el 20.8%*/

-- Step 1.3: Detect quantity of records by channel
SELECT channel,
	COUNT(*) AS count_sales 
FROM sales 
GROUP BY channel; /*9 online, 237 Online, 254 Store*/

-- Step 1.4: Detect quantity of records by region
SELECT region, COUNT(*) 
FROM sales 
GROUP BY region; /*12 north*/

/*Se encontraron 2 problemas principales de incosistencias y estandarización 
para la segmentación de las ventas por canal, 9 registros "online" representando 1.8% de los registros,
y por región, 12 registros "north" representando el 2.4% de los registros*/

/*En conclusión la problema principal y más grave es el de los valores nulos en el campo de discount 
debido a su proporción (20.8%) e impacto directo en los calculos y analisis posteriores, si bien se puede realizar
una imputación de valores por 0, no es lo más ideal dado que puede distorsionar la situación real de la empresa
respecto a la estructura de descuentos y como puede llegar a impactar en el margen*/

-- ==========================================
-- STEP 2 - DATA CLEANING AND STANDARIZATION
-- ==========================================

-- Step 2.1: Imputation in quantity = 1 for null values
UPDATE sales 
SET quantity = 1 
WHERE quantity IS NULL;

-- Step 2.2: Channel Standarization
UPDATE sales
SET channel = INITCAP(TRIM(channel));

-- Step 2.3: Region Standarization 
UPDATE sales
SET region = INITCAP(TRIM(region));


-- Step 2.4: Creation of the discount_status column to control discount invalid values 
ALTER TABLE sales 
ADD COLUMN discount_status VARCHAR(20);

-- Step 2.5: Assignment of values for the discount_status column
UPDATE sales 
SET discount_status =
	CASE 
		WHEN discount IS NULL THEN 'Anomaly'
		ELSE 'Valid' 
	END;

-- ==========================================
-- STEP 3 - DATA VALIDATION
-- ==========================================

-- Step 3.1: Quantity data validation
SELECT COUNT(*) AS null_quantity
FROM sales 
WHERE quantity IS NULL;

-- Step 3.2: discount_status data validation
SELECT COUNT(*)
FROM sales
WHERE discount_status = 'Anomaly';

-- Impact of anomalies on financial analysis
WITH total_revenue AS (
	SELECT SUM(quantity * unit_price * (1-COALESCE(discount,0))) AS total
	FROM sales
)

SELECT 
	ROUND(
		SUM(quantity * unit_price)
		*100.0 / MAX(total)
	,2) AS anomaly_revenue_pct
FROM sales
CROSS JOIN total_revenue
WHERE discount IS NULL;

/*Se identificó que los registros con discount nulo representan el 25.03% del
revenue total, lo que evidencia que las anomalías no son marginales y 
tienen impacto financiero relevante.

Por esta razón, el uso de COALESCE(discount,0) se mantiene como supuesto 
analítico temporal para continuidad del análisis, pero los resultados deben 
interpretarse considerando que una cuarta parte del revenue depende de 
registros con posible inconsistencia operativa.
*/

-- ==========================================
-- STEP 4 - DATA STANDARDIZATION PRODUCT TABLE
-- ==========================================

-- Step 4.1: Standardization of product_name
UPDATE products
SET product_name = INITCAP(TRIM(product_name));
-- Step 4.2: Validation of standardization product_name
SELECT * FROM products;
-- Step 4.3: Validation of category
SELECT DISTINCT category FROM products;