-- ==========================================
-- DAY 2 - BUSINESS QUESTIONS
-- SALES TABLE
-- ==========================================

-- ==========================================
-- STEP 1 - REVENUE, PROFIT AND MARGIN BY CHANNEL
-- ==========================================

-- Step 1.1: Calculation of revenue by channel
WITH revenue AS (SELECT
	ROUND(SUM((quantity * unit_price)*(1-COALESCE(discount,0))),2) AS total_revenue
FROM sales
)
SELECT channel, 
		ROUND(
			SUM(
				quantity * unit_price*(1-COALESCE(discount,0))
				) * 100.0 / MAX(total_revenue)
			,2) AS revenue_ratio
FROM sales
CROSS JOIN revenue
GROUP BY channel
ORDER BY revenue_ratio DESC;

/*El revenue se distribuye de forma equilibrada entre Store (50.67%) y Online (49.33%),
lo que evidencia un balance comercial saludable entre ambos canales y reduce el riesgo de dependencia
crítica sobre una sola fuente de ingresos*/ 

-- Step 1.2: Calculation of profit by channel
WITH total_profit AS(
	SELECT ROUND(SUM(
			quantity * unit_price * (1-COALESCE(discount,0)) - (quantity * p.cost)
	),2) AS general_profit
	FROM sales s
	LEFT JOIN products p 
	ON s.product_id = p.product_id 
)
SELECT channel,
	ROUND(SUM(
			quantity * unit_price * (1-COALESCE(discount,0)) - (quantity * p.cost)
		)*100.0 / MAX(general_profit),2) AS profit_pct
FROM sales s
LEFT JOIN products p 
	ON s.product_id = p.product_id
CROSS JOIN total_profit
GROUP BY channel
ORDER BY 2 DESC;
/*El profit se distribuye de forma equilibrada entre Store (51.26%) y Online (48.74%),
resaltando una utilidad de 2 puntos porcentuales en el canal Store, lo que sugiere una eficiencia comercial superior
en el canal físico*/

-- Step 1.3: Calculation of margin by channel
SELECT channel,
	ROUND(
		SUM(
			quantity * unit_price*(1-COALESCE(discount,0))-(quantity * p.cost)
		)
		/SUM(
			quantity * unit_price*(1-COALESCE(discount,0))
		) 
		* 100.0
	,2) AS margin_pct
FROM sales s 
LEFT JOIN products p 
	ON s.product_id = p.product_id
GROUP BY channel
ORDER BY margin_pct;
/*El margen esta equilibrado en los dos canales Online (43.26%) y Store (44.30%),
lo que sugiere una eficiencia operativa consistente y una capacidad comparable de conversión de ingresos en utilidad.*/
/*No existe dependencia estructural ni desequilibrio financiero relevante entre canales.*/

-- ==========================================
-- STEP 2 - REVENUE, PROFIT, MARGIN BY PRODUCT CATEGORY
-- ==========================================

-- Step 2.1: Calculation of Revenue by product category
WITH total_revenue AS(
	SELECT ROUND(SUM(
			quantity * unit_price * (1-COALESCE(discount,0))
	),2) AS general_revenue
	FROM sales s
)
SELECT 
	p.category, 
	ROUND(SUM(	
		quantity * unit_price * (1-COALESCE(discount,0))
	)*100.0/MAX(general_revenue),2) AS revenue_by_category
FROM sales AS s 
LEFT JOIN products AS p 
	ON s.product_id = p.product_id
CROSS JOIN total_revenue
GROUP BY p.category
ORDER BY 2 DESC;
/*Distribución revenue por categorías: Furniture (45.28%), Electronics(28.47%), Accessories(26.24%)*/
/*Furniture concentra el 45.28% del revenue total, lo que sugiere que es la principal categoría
generadora de ingresos, probablemente asociada a productos de mayor valor transaccional o alta demanda.*/

-- Step 2.2: Calculation of profit by product category
WITH total_profit AS(
	SELECT ROUND(SUM(
			quantity * unit_price * (1-COALESCE(discount,0)) - (quantity * p.cost)
	),2) AS general_profit
	FROM sales s
	LEFT JOIN products p 
	ON s.product_id = p.product_id 
)
SELECT 
	p.category, 
	ROUND(SUM(	
		quantity * unit_price * (1-COALESCE(discount,0)) - (quantity * p.cost)
	)*100.0/MAX(general_profit),2) AS profit_by_category
FROM sales AS s 
LEFT JOIN products AS p 
	ON s.product_id = p.product_id
CROSS JOIN total_profit
GROUP BY p.category
ORDER BY 2 DESC; 
/*La distribución de la utilidad entre las categorias: Furniture (42.35%), Electronics (36.65%) y Accessories(20.99%)*/
/*Accessories presenta una participación en profit inferior a su peso en revenue,
lo que evidencia menor eficiencia en conversión de ingresos en utilidad frente a otras categorías, esto sugiere 
revisar costos o pricing*/

-- Step 2.3: Calculation of margin by product category
SELECT p.category,
	ROUND(SUM(	
		quantity * unit_price * (1-COALESCE(discount,0)) - (quantity * p.cost)
	) / SUM(	
		quantity * unit_price * (1-COALESCE(discount,0))
	) * 100.0,2) AS margin_pct
FROM sales s
LEFT JOIN products p
ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY margin_pct DESC;

/*La distribución del margen entre las categorías: Electronics (56.37%), Furniture(40.95%), Accessories(35.02%)*/
/*Electronics presenta el margen más alto (56.37%), convirtiéndose en la categoría más eficiente financieramente,
aunque no sea la principal generadora de ingresos.*/

/* RECOMENDACIONES
 Impulsar Electronics por su alta eficiencia marginal.
 Usar Furniture como categoría ancla.
 combinar Electronics + Furniture en bundles.*/

 /*Furniture lidera en revenue y profit, consolidándose como la categoría principal del negocio.
Electronics destaca como la categoría con mayor margen, evidenciando mejor eficiencia financiera.
Accessories presenta menor conversión relativa de revenue en profit, por lo que requiere revisión 
de su estructura comercial.*/

-- ==========================================
-- STEP 3 - REVENUE, PROFIT, MARGIN BY LOYALTY LEVEL
-- ==========================================

-- Step 3.1: Calculation of revenue by loyalty level
WITH total_revenue AS(
	SELECT ROUND(SUM(
			quantity * unit_price * (1-COALESCE(discount,0))
	),2) AS general_revenue
	FROM sales s
)
SELECT 
	c.loyalty_level, 
	ROUND(SUM(	
		quantity * unit_price * (1-COALESCE(discount,0))
	)*100.0/MAX(general_revenue),2) AS revenue_by_loyalty_level
FROM sales AS s 
LEFT JOIN customers AS c 
	ON s.customer_id = c.customer_id
CROSS JOIN total_revenue
GROUP BY 1
ORDER BY 2 DESC;

/*La distribución del revenue: Gold (47.54%), Silver (28.00%) y Bronze (24.46%)*/
/*Gold concentra casi la mitad del revenue total, lo que evidencia alta 
dependencia del segmento de clientes de mayor valor y lo convierte en el principal motor comercial del negocio.*/

-- Step 3.2: Calculation of profit by loyalty level
WITH total_profit AS(
	SELECT ROUND(SUM(
			quantity * unit_price * (1-COALESCE(discount,0)) - (quantity * p.cost)
	),2) AS general_profit
	FROM sales s
	LEFT JOIN products p 
	ON s.product_id = p.product_id 
)
SELECT 
	c.loyalty_level, 
	ROUND(SUM(	
		quantity * unit_price * (1-COALESCE(discount,0)) - (quantity * p.cost)
	)*100.0/MAX(general_profit),2) AS profit_by_loyalty_level
FROM sales AS s 
LEFT JOIN products AS p 
	ON s.product_id = p.product_id
LEFT JOIN customers AS c
	ON s.customer_id = c.customer_id
CROSS JOIN total_profit
GROUP BY c.loyalty_level
ORDER BY 2 DESC; 
/*La distribución del profit: Gold (48.29%), Silver (27.01%) y Bronze (24.70%)*/
/*Gold mantiene coherencia entre participación en revenue y profit,
lo que indica un comportamiento financieramente saludable y rentable.
Silver y Bronze muestran una ligera reducción relativa en profit frente a revenue,
aunque sin diferencias significativas, manteniendo un comportamiento financiero estable.*/

-- Step 3.3: Calculation of margin by loyalty level
SELECT c.loyalty_level,
	ROUND(SUM(	
		quantity * unit_price * (1-COALESCE(discount,0)) - (quantity * p.cost)
	) / SUM(	
		quantity * unit_price * (1-COALESCE(discount,0))
	) * 100.0,2) AS margin_pct
FROM sales s
LEFT JOIN products p
ON s.product_id = p.product_id
LEFT JOIN customers c
ON s.customer_id = c.customer_id
GROUP BY c.loyalty_level
ORDER BY margin_pct DESC;
/*La distribución del margin: Gold (44.48%), Silver (44.22%) y Bronze (42.22%)*/
/*Los márgenes entre niveles de fidelización presentan una estructura
altamente homogénea, lo que indica consistencia comercial en la monetización de cada segmento de cliente*/

/*RECOMENDACIONES
1. Mantener priorización de fidelización en el nivel Gold
2. Diseñar estrategias para la migración de clientes Silver -> Gold
3. Diseñar bundles de productos para aumentar el Revenue en el nivel Bronze*/

/*El segmento Gold no solo concentra el mayor revenue, sino que mantiene el margen más alto,
consolidándose como el segmento estratégico prioritario para crecimiento rentable.*/

-- ==========================================
-- STEP 4 - REVENUE, PROFIT, MARGIN BY REGION
-- ==========================================

-- Step 4.1: Calculation of revenue by region
WITH total_revenue AS(
	SELECT ROUND(SUM(
			quantity * unit_price * (1-COALESCE(discount,0))
	),2) AS general_revenue
	FROM sales s
)
SELECT 
	region, 
	ROUND(SUM(	
		quantity * unit_price * (1-COALESCE(discount,0))
	)*100.0/MAX(general_revenue),2) AS revenue_by_region
FROM sales
CROSS JOIN total_revenue
GROUP BY 1
ORDER BY 2 DESC;
/*Revenue: North (29.01%), East (25.00%), West (24.12%), South(21.86%)*/
/*North concentra el mayor revenue total (29.01%), lo que evidencia mayor
capacidad comercial relativa frente a las demás regiones,
posiblemente asociado a mayor ticket promedio, frecuencia o mix de productos.
Por otra parte la region South refleja el revenue más bajo, lo cual indica que tiene potencial de crecimiento comercial*/

-- Step 4.2: Calculation of profit by region
WITH total_profit AS(
	SELECT ROUND(SUM(
			quantity * unit_price * (1-COALESCE(discount,0)) - (quantity * p.cost)
	),2) AS general_profit
	FROM sales s
	LEFT JOIN products p 
	ON s.product_id = p.product_id 
)
SELECT 
	region, 
	ROUND(SUM(	
		quantity * unit_price * (1-COALESCE(discount,0)) - (quantity * p.cost)
	)*100.0/MAX(general_profit),2) AS profit_by_region
FROM sales AS s 
LEFT JOIN products AS p 
	ON s.product_id = p.product_id
CROSS JOIN total_profit
GROUP BY region
ORDER BY 2 DESC; 
/*Profit: North (27.80%), West (27.55%), East (24.06%), South(20.59%)*/
/*Las regiones mantienen coherencia entre su particiáción de revenue y profit, evidenciando 
una estabilidad financiera, resalta la region West con menos participación Revenue logra tener un profit mayor*/

-- Step 4.3: Calculation of margin by region
SELECT region,
	ROUND(SUM(	
		quantity * unit_price * (1-COALESCE(discount,0)) - (quantity * p.cost)
	) / SUM(	
		quantity * unit_price * (1-COALESCE(discount,0))
	) * 100.0,2) AS margin_pct
FROM sales s
LEFT JOIN products p
ON s.product_id = p.product_id
GROUP BY region
ORDER BY 2 DESC;
/*Margin:  West (50.00%), East (42.15%), North (41.95%), South(41.23%)*/
/*West presenta el margen más alto (50%), superando claramente al resto
de regiones, lo que evidencia una estructura comercial altamente eficiente y la
convierte en la principal zona estratégica para escalar crecimiento rentable.*/

/*RECOMENDACIONES
1. Escalar West como región prioritaria de crecimiento rentable.
2. Escalar West como región prioritaria de crecimiento rentable.
3. Desarrollar South sin sacrificar margen.*/

/*West representa la región más eficiente del negocio, combinando participación
media en revenue con el margen más alto, lo que la convierte en el principal motor de rentabilidad potencial. */