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
/*"category"	"region"	"profit_pct"
"Furniture"	"East"	12.27
"Electronics"	"West"	10.89
"Furniture"	"North"	10.84
"Electronics"	"North"	10.03
"Furniture"	"West"	9.87
"Furniture"	"South"	9.38
"Electronics"	"East"	8.20
"Electronics"	"South"	7.53
"Accessories"	"North"	6.93
"Accessories"	"West"	6.79
"Accessories"	"South"	3.68
"Accessories"	"East"	3.60*/

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
/*"category"	"region"	"margin"
"Electronics"	"West"	61.13
"Electronics"	"East"	58.36
"Electronics"	"North"	54.33
"Electronics"	"South"	51.25
"Furniture"	"West"	45.30
"Accessories"	"West"	43.81
"Furniture"	"South"	43.05
"Furniture"	"East"	39.49
"Furniture"	"North"	37.64
"Accessories"	"North"	36.44
"Accessories"	"East"	30.05
"Accessories"	"South"	27.34*/

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
/*"loyalty_level"	"category"	"revenue_pct"
"Gold"	"Furniture"	23.95
"Gold"	"Electronics"	13.71
"Bronze"	"Furniture"	10.79
"Silver"	"Furniture"	10.55
"Gold"	"Accessories"	9.88
"Silver"	"Accessories"	9.23
"Silver"	"Electronics"	8.22
"Bronze"	"Accessories"	7.13
"Bronze"	"Electronics"	6.54*/

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
/*"loyalty_level"	"category"	"margin"
"Silver"	"Electronics"	60.20
"Bronze"	"Electronics"	58.28
"Gold"	"Electronics"	53.15
"Gold"	"Furniture"	44.85
"Bronze"	"Furniture"	43.70
"Silver"	"Accessories"	41.00
"Bronze"	"Accessories"	32.10
"Gold"	"Accessories"	31.55
"Silver"	"Furniture"	29.28*/
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
/*"channel"	"category"	"revenue_pct"
"Store"	"Furniture"	23.79
"Online"	"Furniture"	21.50
"Store"	"Electronics"	14.24
"Online"	"Electronics"	14.23
"Online"	"Accessories"	13.60
"Store"	"Accessories"	12.64*/
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
/*"channel"	"category"	"profit_pct"
"Store"	"Furniture"	21.64
"Online"	"Furniture"	20.71
"Online"	"Electronics"	18.59
"Store"	"Electronics"	18.06
"Store"	"Accessories"	11.56
"Online"	"Accessories"	9.43*/
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
/*"channel"	"category"	"margin"
"Online"	"Electronics"	57.21
"Store"	"Electronics"	55.53
"Online"	"Furniture"	42.19
"Store"	"Accessories"	40.04
"Store"	"Furniture"	39.83
"Online"	"Accessories"	30.36*/

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
