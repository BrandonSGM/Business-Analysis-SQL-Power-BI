-- ==========================================
-- DAY 3 - BUSINESS QUESTIONS
-- CROSS TABLES
-- ==========================================
-- Assumption: NULL discount treated as 0 for analytical continuity
-- ==========================================
-- STEP 1 - REVENUE, PROFIT AND MARGIN BY REGION AND CATEGORY
-- ==========================================
WITH total_revenue AS (SELECT
	ROUND(SUM((quantity * unit_price)*(1-COALESCE(discount,0))),2) AS general_revenue
FROM sales)
SELECT 
	p.category,
	s.region,
	ROUND(
		SUM(
			quantity * unit_price * (1-COALESCE(discount,0))
			) / MAX(general_revenue) * 100.0
	,2) AS revenue_pct
FROM sales s
LEFT JOIN products p
ON s.product_id = p.product_id
CROSS JOIN total_revenue
GROUP BY 1,2
ORDER BY 3 DESC;
/*"category"	"region"	"revenue_pct"
"Furniture"	"East"	13.60
"Furniture"	"North"	12.61
"Furniture"	"South"	9.54
"Furniture"	"West"	9.54
"Accessories"	"North"	8.32
"Electronics"	"North"	8.09
"Electronics"	"West"	7.80
"Accessories"	"West"	6.78
"Electronics"	"South"	6.43
"Electronics"	"East"	6.15
"Accessories"	"South"	5.89
"Accessories"	"East"	5.25*/
/*
Furniture continúa siendo la categoría dominante en todas las regiones, confirmando su rol 
como principal generador de revenue del negocio.

La combinación más fuerte se presenta en East (13.60%), lo que evidencia una alta concentración
de ingresos en Furniture dentro de esta región.

North destaca como la región más equilibrada comercialmente, ya que mantiene participación 
relevante en las tres categorías, lo que sugiere menor dependencia de una sola línea de producto y 
mayor estabilidad comercial.

South mantiene los porcentajes más bajos en casi todas las categorías, lo que confirma una menor
tracción comercial y potencial de crecimiento mediante estrategias de incremento de ticket promedio
y expansión de categorías.
*/

-- Step 1.2: Quantity by Region and Category
SELECT p.category,
	s.region,
	SUM(quantity) AS quantity
FROM sales s 
LEFT JOIN products p
ON s.product_id = p.product_id
GROUP BY 1,2
ORDER BY 3 DESC;
/*"category"	"region"	"quantity"
"Furniture"	"East"	401
"Furniture"	"North"	351
"Furniture"	"West"	284
"Furniture"	"South"	275
"Accessories"	"North"	236
"Electronics"	"West"	210
"Electronics"	"North"	206
"Electronics"	"East"	188
"Electronics"	"South"	188
"Accessories"	"West"	178
"Accessories"	"South"	171
"Accessories"	"East"	144*/
/*
Furniture mantiene liderazgo en cantidad de unidades vendidas en todas las regiones,
confirmando que su participación en revenue está sustentada principalmente por escala comercial y alta rotación.

North y East concentran el mayor volumen de Furniture, reforzando su papel como 
regiones estratégicas para esta categoría.

Electronics presenta la distribución más equilibrada entre regiones, evidenciando 
una demanda estable y homogénea, lo que la convierte en una categoría predecible comercialmente.

Accessories mantiene menor volumen relativo, pero con participación consistente en todas las regiones,
especialmente en North y West, lo que sugiere oportunidad de crecimiento mediante estrategias comerciales focalizadas.
*/

-- Step 1.3: Profit by Region + Category
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
	s.region,
	ROUND(SUM(	
		quantity * unit_price * (1-COALESCE(discount,0)) - (quantity * p.cost)
	)*100.0/MAX(general_profit),2) AS profit_pct
FROM sales AS s 
LEFT JOIN products AS p 
	ON s.product_id = p.product_id
CROSS JOIN total_profit
GROUP BY 1,2
ORDER BY 3 DESC;

/*
Furniture mantiene liderazgo consistente en generación de utilidad, especialmente en East, donde también
concentra el mayor revenue, confirmando una combinación sólida de volumen y rentabilidad.

Electronics en West representa uno de los hallazgos más relevantes del análisis, alcanzando 10.89% del profit
total y posicionándose como una de las combinaciones más eficientes del negocio.

North confirma ser la región más equilibrada financieramente, al mantener alta participación en profit tanto en
Furniture como en Electronics, lo que reduce dependencia de una sola categoría.

Accessories presenta baja contribución en South y East, evidenciando necesidad de revisar estructura de costos,
política de descuentos y posicionamiento comercial.
*/

-- Step 1.4 Margin by region + category
SELECT 
	p.category,
	s.region,
	ROUND(SUM(
		quantity * unit_price * (1-COALESCE(discount,0)) - (quantity * p.cost)
	)/SUM(
		quantity * unit_price * (1-COALESCE(discount,0))
	) * 100.0,2) AS margin
FROM sales s
LEFT JOIN products p 
ON s.product_id = p.product_id
GROUP BY 1,2
ORDER BY 3 DESC;

/*
Electronics se consolida como la categoría más eficiente del negocio, liderando el margin en todas
las regiones y destacando especialmente en West (61.13%), lo que confirma una estructura comercial altamente rentable.

West demuestra superioridad financiera transversal al mantener altos márgenes en las tres categorías,
posicionándose como la región más eficiente del negocio.

Furniture mantiene liderazgo en revenue y profit, pero con márgenes inferiores frente a Electronics,
especialmente en North, donde su eficiencia relativa disminuye.

Accessories presenta la mayor variabilidad regional en rentabilidad, con desempeño sólido en West pero
márgenes bajos en South y East, lo que evidencia necesidad de revisar estrategia comercial
y estructura de costos según región.
*/

-- ==========================================
-- STEP 2 - REVENUE, PROFIT AND MARGIN BY LOYALTY LEVEL AND CATEGORY
-- ==========================================

-- Step 2.1: Revenue by Loyalty level + category
WITH total_revenue AS (SELECT
	ROUND(SUM((quantity * unit_price)*(1-COALESCE(discount,0))),2) AS general_revenue
FROM sales)
SELECT 
	c.loyalty_level,
	p. category,
	ROUND(
		SUM(
			quantity * unit_price*(1-COALESCE(discount,0))
		)/MAX(general_revenue)*100.0,2) AS revenue_pct
FROM sales s 
LEFT JOIN products p 
ON s.product_id = p.product_id
LEFT JOIN customers c
ON s.customer_id = c.customer_id
CROSS JOIN total_revenue
GROUP BY 1,2
ORDER BY 3 DESC;

/*
Gold representa la combinación comercial más fuerte del negocio, especialmente en Furniture (23.95%),
concentrando casi una cuarta parte del revenue total en una sola relación cliente-categoría.

Furniture mantiene liderazgo en todos los niveles de fidelización, confirmando una demanda transversal
y consolidándose como la principal fuente de ingresos del negocio.

Bronze muestra menor participación en Electronics, 
lo que sugiere menor penetración de una categoría altamente rentable dentro de este segmento.

Accessories mantiene presencia en los tres niveles de fidelización,
aunque con mayor contribución de Gold, evidenciando una participación comercial relativamente distribuida.
*/
-- Step 2.2: Profit by Loyalty level + Category
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
	p.category,
	ROUND(SUM(	
		quantity * unit_price * (1-COALESCE(discount,0)) - (quantity * p.cost)
	)*100.0/MAX(general_profit),2) AS profit_pct
FROM sales AS s 
LEFT JOIN products AS p 
	ON s.product_id = p.product_id
LEFT JOIN customers AS c
	ON s.customer_id = c.customer_id
CROSS JOIN total_profit
GROUP BY 1,2
ORDER BY 3 DESC;
/*"loyalty_level"	"category"	"profit_pct"
"Gold"	"Furniture"	24.53
"Gold"	"Electronics"	16.64
"Silver"	"Electronics"	11.31
"Bronze"	"Furniture"	10.77
"Bronze"	"Electronics"	8.70
"Silver"	"Accessories"	8.65
"Gold"	"Accessories"	7.12
"Silver"	"Furniture"	7.05
"Bronze"	"Accessories"	5.23*/

/*
Gold y Furniture concentran 24.53% del profit total, consolidándose como la relación cliente-categoría
más relevante del negocio y confirmando alta consistencia entre revenue y utilidad.

Electronics demuestra mayor eficiencia transversal en utilidad, destacando especialmente en Gold y Silver,
donde supera el desempeño de otras categorías dentro de esos niveles.

Silver presenta uno de los hallazgos más relevantes: Electronics genera 11.31% del profit total,
superando ampliamente a Furniture dentro del mismo segmento, lo que evidencia una mejor conversión financiera.

Silver + Furniture muestra caída significativa frente a su participación en revenue, sugiriendo necesidad de
revisar descuentos, costos o composición comercial.

Bronze mantiene mejor desempeño relativo en Furniture y Electronics, mientras Accessories continúa siendo
la categoría menos eficiente dentro de este segmento.
*/
-- Step 2.3: Margin by Loyalty level + category 
SELECT 
	c.loyalty_level,
	p.category,
	ROUND(SUM(
		quantity * unit_price * (1-COALESCE(discount,0)) - (quantity * p.cost)
	)/SUM(
		quantity * unit_price * (1-COALESCE(discount,0))
	) * 100.0,2) AS margin
FROM sales s
LEFT JOIN products p 
ON s.product_id = p.product_id
LEFT JOIN customers c 
ON s.customer_id = c.customer_id
GROUP BY 1,2
ORDER BY 3 DESC;

/*
Electronics se consolida como la categoría más eficiente financieramente en todos los niveles de fidelización,
destacando especialmente en Silver (60.20%), donde alcanza el mayor margin de toda la matriz analizada.

Silver representa uno de los hallazgos más estratégicos del análisis: aunque no lidera revenue,
muestra la mejor eficiencia financiera en Electronics, lo que lo posiciona como segmento ideal para escalar 
categorías rentables.

Gold mantiene alto desempeño en Electronics, pero con menor eficiencia relativa frente a Silver, evidenciando
que mayor volumen no siempre implica mejor rentabilidad.

Silver + Furniture presenta el margin más bajo dentro del segmento Silver, indicando necesidad de revisar
estructura comercial, costos o descuentos.

Accessories muestra alta variabilidad entre segmentos, con márgenes bajos especialmente en Gold y Bronze,
lo que confirma menor eficiencia estructural de esta categoría.
*/

-- ==========================================
-- STEP 3 - REVENUE, PROFIT AND MARGIN BY CHANNEL AND CATEGORY
-- ==========================================

-- Step 3.1: Revenue by channel + category 
WITH total_revenue AS (SELECT
	ROUND(SUM((quantity * unit_price)*(1-COALESCE(discount,0))),2) AS general_revenue
FROM sales)
SELECT 
	s.channel, 
	p.category, 
	ROUND(
		SUM(quantity * unit_price*(1-COALESCE(discount,0))
		)/MAX(general_revenue)*100.0,2) AS revenue_pct
FROM sales AS s
LEFT JOIN products AS p
ON s.product_id = p.product_id
CROSS JOIN total_revenue
GROUP BY 1,2
ORDER BY 3 DESC;

/*
Los canales muestran una distribución comercial equilibrada entre categorías,
sin concentraciones críticas de ingreso en un solo canal.

Furniture se consolida como la categoría de mayor generación de revenue en ambos canales,
con ligera ventaja en Store, confirmando fuerte tracción transversal.

Electronics presenta el comportamiento más estable del análisis,
con participación prácticamente idéntica entre Store y Online, lo que evidencia alta adaptabilidad comercial al canal.

Accessories muestra mejor desempeño en Online, sugiriendo afinidad natural de esta categoría
con dinámicas de compra digital.
*/

-- Step 3.2: Profit by channel + category
WITH total_profit AS(
	SELECT ROUND(SUM(
			quantity * unit_price * (1-COALESCE(discount,0)) - (quantity * p.cost)
	),2) AS general_profit
	FROM sales s
	LEFT JOIN products p 
	ON s.product_id = p.product_id 
)
SELECT 
	s.channel,
	p.category,
	ROUND(SUM(	
		quantity * unit_price * (1-COALESCE(discount,0)) - (quantity * p.cost)
	)*100.0/MAX(general_profit),2) AS profit_pct
FROM sales AS s 
LEFT JOIN products AS p 
	ON s.product_id = p.product_id
CROSS JOIN total_profit
GROUP BY 1,2
ORDER BY 3 DESC;

/*
Furniture mantiene una distribución equilibrada de utilidad entre canales,
consolidándose como la categoría más estable en generación de profit.

Store + Furniture representa la combinación con mayor aporte al profit total,
confirmando consistencia financiera entre volumen e utilidad.

Electronics muestra un hallazgo relevante: Online supera ligeramente a Store en utilidad,
indicando mejor conversión financiera del canal digital en esta categoría.

Accessories cambia su lectura frente al revenue: aunque Online tiene mayor participación en ingresos,
Store genera mejor profit, evidenciando mayor eficiencia comercial en canal físico.
*/

-- Step 3.3: Margin by channel + category
SELECT 
	s.channel,
	p.category,
	ROUND(SUM(
		quantity * unit_price * (1-COALESCE(discount,0)) - (quantity * p.cost)
	)/SUM(
		quantity * unit_price * (1-COALESCE(discount,0))
	) * 100.0,2) AS margin
FROM sales s
LEFT JOIN products p 
ON s.product_id = p.product_id
GROUP BY 1,2
ORDER BY 3 DESC;

/*
Electronics se consolida como la categoría más rentable transversal entre canales,
destacando especialmente en Online con el mayor margin de toda la matriz (57.21%).

Store + Furniture lidera revenue y profit, confirmando su rol como principal categoría
tractora del negocio; sin embargo, su margen es menor frente a categorías más eficientes,
evidenciando menor conversión relativa de ingreso en utilidad.

Online + Accessories presenta el margen más bajo del análisis, mostrando que aunque la categoría
tiene buena tracción digital, su eficiencia financiera es limitada y requiere revisión comercial.

Store + Accessories mejora claramente su rentabilidad frente a Online, indicando mejor estructura 
comercial en canal físico.

Online + Furniture muestra una eficiencia ligeramente superior a Store, lo que refuerza el potencial
del canal digital para esta categoría.
*/

-- ==========================================
-- STEP 4 - DISCOUNT IMPACT ANALYSIS 
-- ==========================================

-- Step 4.1: Revenue by Discount status
WITH total_revenue AS (
SELECT ROUND(
		SUM(
			quantity*unit_price*(1-COALESCE(discount,0))		
			)
		,2) AS general_revenue
FROM sales		
)
SELECT 
	CASE WHEN discount IS NULL OR discount = 0 THEN 'No discount'
	ELSE 'Discount Applied' END AS discount_status,
	ROUND(
		SUM(
			quantity * unit_price * (1-COALESCE(discount,0))
		) / MAX(general_revenue) *100.0
	,2) AS revenue_pct
FROM sales 
CROSS JOIN total_revenue
GROUP BY 1
ORDER BY 2 DESC;

/*Las ventas con descuento representan 54.71% del revenue total,
superando ligeramente a las ventas sin descuento.

Esto indica una dependencia relevante del descuento dentro de la generación
de ingresos, sugiriendo que el descuento forma parte estructural del comportamiento comercial.*/

-- Step 4.2: Profit by Discount status
WITH total_profit AS (
SELECT ROUND(
		SUM(
			quantity*unit_price*(1-COALESCE(discount,0))-(quantity*p.cost)		
			)
		,2) AS general_profit
FROM sales s
LEFT JOIN products p
ON s.product_id = p.product_id
)
SELECT 
	CASE WHEN discount IS NULL OR discount = 0 THEN 'No discount'
	ELSE 'Discount Applied' END AS discount_status,
	ROUND(
		SUM(
			quantity * unit_price * (1-COALESCE(discount,0))-(quantity*p.cost)
			)
		/ MAX(general_profit) *100.0
	,2) AS profit_pct
FROM sales s
LEFT JOIN products p
ON s.product_id = p.product_id
CROSS JOIN total_profit
GROUP BY 1
ORDER BY 2 DESC;

/*
Las ventas sin descuento aumentan su participación al pasar de 45.29% en revenue a 47.83% en profit,
evidenciando mejor conversión financiera.

Las ventas con descuento mantienen liderazgo en generación de utilidad (52.17%),
pero pierden participación relativa frente a su peso en revenue, mostrando menor eficiencia en
la conversión de ingreso a profit.

Esto sugiere que el descuento impulsa volumen comercial, aunque con una ligera dilución de utilidad.
*/

-- Step 4.3: Margin by Discount Analysis
SELECT 
	CASE WHEN discount IS NULL OR discount = 0 THEN 'No discount'
	ELSE 'Discount Applied' END AS discount_status,
	ROUND(
		SUM(
			quantity * unit_price * (1-COALESCE(discount,0))-(quantity*p.cost)
		) / SUM(
			quantity*unit_price*(1-COALESCE(discount,0)) 
		)* 100.0 ,2) AS margin
FROM sales s
LEFT JOIN products p
ON s.product_id = p.product_id
GROUP BY 1
ORDER BY 2 DESC;
/*"discount_status"	"margin"
"Discount Applied"	38.28
"No discount"	50.44*/

/*Las ventas sin descuento muestran la mayor eficiencia financiera del análisis, alcanzando un margin de 50.44%.

Las ventas con descuento mantienen liderazgo en revenue y profit, pero reducen significativamente su eficiencia,
con un margin de 38.28%.

La diferencia de más de 12 puntos porcentuales evidencia que el descuento impulsa volumen comercial,
aunque con una erosión relevante en rentabilidad.

Esto sugiere que el descuento debe evaluarse de forma selectiva según su impacto real en utilidad.*/

-- Step 4.4: Margin by Discount + Category
SELECT 
	p.category,
	CASE WHEN discount IS NULL OR discount = 0 THEN 'No discount'
	ELSE 'Discount Applied' END AS discount_status,
	ROUND(
		SUM(
			quantity * unit_price * (1-COALESCE(discount,0))-(quantity*p.cost)
		) / SUM(
			quantity*unit_price*(1-COALESCE(discount,0)) 
		)* 100.0 ,2) AS margin
FROM sales s
LEFT JOIN products p
ON s.product_id = p.product_id
GROUP BY 1,2
ORDER BY 3 DESC;

/*
Electronics mantiene la mayor solidez financiera incluso bajo descuento, 
conservando un margin de 51.85%, lo que evidencia alta capacidad estructural 
para absorber estrategias promocionales.

Furniture muestra una caída relevante de más de 10 puntos porcentuales bajo descuento,
indicando una sensibilidad moderada en su rentabilidad.

Accessories presenta la mayor erosión financiera del análisis:
el margin cae de 44.59% a 28.56%, confirmando alta vulnerabilidad de esta categoría frente al descuento.

Esto sugiere que la política de descuentos debería ser más selectiva,
especialmente en Furniture y Accessories, donde el impacto sobre la rentabilidad es considerable.
*/

-- ==========================================
-- STEP 5 - PRODUCT PERFORMANCE ANALYSIS 
-- ========================================== 

-- Step 5.1: Revenue by product + category
WITH total_revenue AS (
SELECT ROUND(
		SUM(
			quantity*unit_price*(1-COALESCE(discount,0))		
			)
		,2) AS general_revenue
FROM sales		
)
SELECT
	p.product_name,
	p.category,
	ROUND(
		SUM(
			quantity * unit_price * (1-COALESCE(discount,0))
		) / MAX(general_revenue) *100.0
	,2) AS revenue_pct
FROM sales s 
LEFT JOIN products p 
ON s.product_id = p.product_id
CROSS JOIN total_revenue
GROUP BY 1,2
ORDER BY 3 DESC;

/*
Furniture domina el revenue por profundidad de portafolio,
concentrando múltiples productos dentro del Top 10 y confirmando consistencia comercial transversal.

Electronics presenta el producto con mayor aporte individual al revenue (Product_5),
consolidándolo como activo estratégico premium dentro de la categoría más rentable del negocio.

Accessories revela un hallazgo relevante: dos productos se posicionan dentro del Top 3,
mostrando que aunque la categoría no lidera globalmente, sí contiene productos altamente
competitivos de forma individual.

Esto sugiere estructuras comerciales distintas por categoría: Furniture por amplitud,
Electronics por concentración premium y Accessories por productos estrella específicos.
*/

-- Step 5.2: Profit by Product + category
WITH total_profit AS (
SELECT ROUND(
		SUM(
			quantity*unit_price*(1-COALESCE(discount,0))-(quantity*p.cost)		
			)
		,2) AS general_profit
FROM sales s
LEFT JOIN products p
ON s.product_id = p.product_id
)
SELECT 
	p.product_name,
	p.category,
	ROUND(
		SUM(
			quantity * unit_price * (1-COALESCE(discount,0))-(quantity*p.cost)
			)
		/ MAX(general_profit) *100.0
	,2) AS profit_pct
FROM sales s
LEFT JOIN products p
ON s.product_id = p.product_id
CROSS JOIN total_profit
GROUP BY 1,2
ORDER BY 3 DESC;

/*
Furniture y Electronics concentran varios de los productos con mayor margin del portafolio,
confirmando alta capacidad de generación de utilidad en productos estratégicos.

Product_19 alcanza el mayor margin del análisis (87.29%), posicionándose como el producto más
eficiente financieramente del negocio.

Electronics confirma fortaleza estructural con múltiples productos sobre 84% de margin, 
consolidando una categoría de alto valor financiero.

Accessories presenta un caso destacado con Product_17, que mantiene alta rentabilidad y
se consolida como producto estratégico dentro de una categoría más heterogénea.

El análisis identifica productos con margen negativo en todas las categorías, destacando
Product_7 con -34.74%, lo que representa una alerta crítica y justifica revisión inmediata de pricing, costos y política comercial.
*/

-- Step 5.4: Margin by Product + Category
SELECT 
	p.product_name,
	p.category,
	ROUND(
		SUM(
			quantity * unit_price * (1-COALESCE(discount,0))-(quantity*p.cost)
		) / SUM(
			quantity*unit_price*(1-COALESCE(discount,0)) 
		)* 100.0 ,2) AS margin
FROM sales s
LEFT JOIN products p
ON s.product_id = p.product_id
GROUP BY 1,2
ORDER BY 3 DESC;

/*
Furniture y Electronics concentran varios de los productos con mayor margin del portafolio,
confirmando alta capacidad de generación de utilidad en productos estratégicos.

Product_19 alcanza el mayor margin del análisis (87.29%), posicionándose como el producto más
eficiente financieramente del negocio.

Electronics confirma fortaleza estructural con múltiples productos sobre 84% de margin,
consolidando una categoría de alto valor financiero.

Accessories presenta un caso destacado con Product_17, que mantiene alta rentabilidad y
se consolida como producto estratégico dentro de una categoría más heterogénea.

El análisis identifica productos con margen negativo en todas las categorías, destacando
Product_7 con -34.74%, lo que representa una alerta crítica y justifica revisión inmediata de pricing,
costos y política comercial.
*/

-- ==========================================
-- STEP 6 - Customer Behavior vs Product Profitability 
-- ========================================== 

-- Step 6.1: Customer Behavior vs Product Profitability
WITH total_profit AS (
SELECT ROUND(
		SUM(
			quantity*unit_price*(1-COALESCE(discount,0))-(quantity*p.cost)		
			)
		,2) AS general_profit
FROM sales s
LEFT JOIN products p
ON s.product_id = p.product_id
)
SELECT 
	c.loyalty_level,
	p.product_name,
	ROUND(
		SUM(
			quantity * unit_price * (1-COALESCE(discount,0))
			-
			(quantity * p.cost)
		)/ MAX(general_profit) * 100.0,2
	) AS profit_pct
FROM sales s
LEFT JOIN products p
ON s.product_id = p.product_id
LEFT JOIN customers c
ON s.customer_id = c.customer_id
CROSS JOIN total_profit
WHERE p.product_name IN ('Product_15','Product_14','Product_19','Product_17')
GROUP BY 1,2
ORDER BY 3 DESC;

/*
Gold concentra el mayor aporte de profit en todos los productos estratégicos analizados,
confirmando que este segmento combina alto valor comercial con mejor conversión hacia utilidad.

Product_14 lidera dentro de Gold con 6.16%, consolidándose como el producto
de mayor impacto rentable dentro del segmento premium.

Product_15 muestra fortaleza transversal al mantener aportes consistentes en Gold, Silver y Bronze,
lo que lo posiciona como un producto estable comercialmente entre distintos niveles de cliente.

Product_19 evidencia una caída significativa en Silver (0.53%), lo que sugiere una oportunidad
comercial para revisar posicionamiento o incentivos específicos en este segmento.

El comportamiento general confirma que los clientes Gold no solo generan mayor volumen, sino que
concentran productos de mejor desempeño financiero. 
*/

-- Step 6.2: Products with loss of profitability
WITH total_profit AS (
SELECT ROUND(
		SUM(
			quantity*unit_price*(1-COALESCE(discount,0))-(quantity*p.cost)		
			)
		,2) AS general_profit
FROM sales s
LEFT JOIN products p
ON s.product_id = p.product_id
)
SELECT 
	c.loyalty_level,
	p.product_name,
	ROUND(
		SUM(
			quantity * unit_price * (1-COALESCE(discount,0))
			-
			(quantity * p.cost)
		)/ MAX(general_profit) * 100.0,2
	) AS profit_pct
FROM sales s
LEFT JOIN products p
ON s.product_id = p.product_id
LEFT JOIN customers c
ON s.customer_id = c.customer_id
CROSS JOIN total_profit
WHERE p.product_name IN ('Product_10','Product_3','Product_4','Product_11','Product_7')
GROUP BY 1,2
ORDER BY 3 ASC;

/*
Los productos con pérdida de utilidad aparecen en todos los niveles de loyalty,
confirmando que el deterioro financiero no está concentrado en un único segmento de clientes.

Gold presenta las pérdidas más profundas, especialmente en Product_7 (-1.73%) y Product_3 (-1.49%),
lo que evidencia que incluso clientes premium pueden amplificar pérdidas cuando el producto presenta debilidad estructural.

Silver y Bronze muestran patrones similares en Product_10 y Product_11, sugiriendo una estructura comercial homogénea en estos
productos dentro de ambos segmentos.

Se observa además que algunos productos cambian de comportamiento según loyalty level, como Product_3,
que pasa de pérdida en Gold a utilidad positiva en Silver, indicando oportunidades de ajuste comercial segmentado.*/

-- Step 6.3: Margin by Loyalty + Selected Products
SELECT 
	c.loyalty_level,
	p.product_name,
	ROUND(
		SUM(
			quantity * unit_price * (1-COALESCE(discount,0))
			-
			(quantity * p.cost)
		)/ SUM(quantity * unit_price * (1-COALESCE(discount,0))) *100.0,2
	) AS margin
FROM sales s
LEFT JOIN products p
ON s.product_id = p.product_id
LEFT JOIN customers c
ON s.customer_id = c.customer_id
WHERE p.product_name IN ('Product_15','Product_14','Product_19','Product_17')
GROUP BY 1,2
ORDER BY 3 DESC;
/*
"loyalty_level"	"product_name"	"margin"
"Gold"	"Product_19"	88.42
"Bronze"	"Product_19"	86.87
"Bronze"	"Product_14"	86.50
"Bronze"	"Product_15"	85.44
"Silver"	"Product_15"	84.49
"Silver"	"Product_14"	84.05
"Gold"	"Product_14"	84.01
"Gold"	"Product_15"	83.02
"Silver"	"Product_17"	81.93
"Silver"	"Product_19"	81.09
"Bronze"	"Product_17"	79.10
"Gold"	"Product_17"	73.36
*/
/*
Product_19 confirma el comportamiento más sólido del análisis, manteniendo márgenes superiores al 81% en
todos los niveles de loyalty y alcanzando su mejor desempeño en Gold (88.42%), lo que lo posiciona como un producto estructuralmente premium.

Bronze presenta márgenes excepcionalmente altos en varios productos premium, especialmente
Product_14 (86.50%) y Product_15 (85.44%), sugiriendo una menor erosión comercial en este segmento.

Product_14 y Product_15 mantienen alta consistencia en todos los niveles de fidelización,
consolidándose como productos transversalmente eficientes dentro del portafolio.

Product_17 presenta la mayor variabilidad entre segmentos, con una caída relevante en Gold (73.36%)
frente a Silver (81.93%), lo que indica una posible oportunidad de optimización comercial en clientes premium.
*/
