# Business Analysis SQL + Power BI

![SQL](https://img.shields.io/badge/SQL-PostgreSQL-blue?logo=postgresql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-Analytics-F2C811?logo=powerbi&logoColor=black)
![Business Analysis](https://img.shields.io/badge/Business-Analysis-green)
![Status](https://img.shields.io/badge/Status-In%50Progress-orange)

[English](#english) | [Español](#español)

# English
## Tools Used

* PostgreSQL
* SQL
* Business Analysis

---

## Project Objective

This project analyzes sales transactions to identify how categories, products, discounts, and customer loyalty impact revenue, profit, and margin.

The analysis focuses on transforming raw transactional data into actionable business insights through structured SQL exploration.

---

## Business Questions

* Which categories generate the highest revenue?
* Which categories are financially more efficient?
* How do discounts affect profitability?
* Which products create the strongest margin contribution?
* Which products generate losses?
* How does customer loyalty influence product profitability?

---

## Dataset Overview

Tables used in the project:

* `sales`
* `products`
* `customers`

Main business variables analyzed:

* `quantity`
* `unit_price`
* `discount`
* `cost`
* `category`
* `loyalty_level`

---

# Analysis Roadmap

## Day 1 — Data Understanding & Validation

Initial exploration focused on validating table consistency and identifying anomalies before starting business analysis.

### Main validations

* Null values detected in `discount`
* Null discounts treated as `0` using `COALESCE()` for revenue calculations
* Null discounts also preserved as a business anomaly for interpretation

### Key insight

Discount null records represented an important revenue share, so they were incorporated analytically instead of removed.

---

## Day 2 — Revenue, Profit & Discount Analysis

### Revenue by Category

Furniture showed the strongest commercial weight with multiple high-revenue products.

### Profit by Category

Electronics achieved the strongest profit efficiency despite lower revenue dominance.

### Margin by Discount Status

Discounted sales produced strong volume but lower efficiency:

* Discount Applied → **38.28% margin**
* No Discount → **50.44% margin**

### Strategic finding

Discounts increase commercial traction but materially reduce margin performance.

---

## Day 3 — Product & Customer Strategic Analysis

### Product Leaders

* Product_19 = highest portfolio margin (**87.29%**)
* Product_14 = strong premium profitability
* Product_15 = consistent cross-segment performance

### Profitability Alerts

* Product_7 = most critical negative margin (**-34.74%**)

### Customer Behavior

Gold customers generate the highest profit concentration in strategic products.

Bronze customers frequently achieve stronger margins in premium combinations.

---

# Executive Summary

## Revenue Insights

Furniture dominates product presence in revenue ranking, while Accessories reveal unexpected product-level strength.

## Profitability Insights

Electronics and Furniture concentrate the strongest financial efficiency.

## Discount Risks

Discount policies improve volume but weaken structural profitability.

## Product Opportunities

Product_19 emerges as the strongest strategic asset in the portfolio.

## Customer Insight

Customer profitability changes materially depending on loyalty level and product mix.

---

# Business Recommendations

* Review discount policies in Furniture and Accessories
* Prioritize Product_19, Product_14 and Product_15 in strategic campaigns
* Reassess Product_7 pricing and cost structure
* Improve Silver segment conversion in high-margin products
* Replicate efficient Bronze purchasing patterns

---

# SQL Techniques Applied

* CTEs
* CASE WHEN
* COALESCE
* LEFT JOIN
* Aggregations
* Margin calculations
* Profit contribution analysis
* Customer segmentation

---

# Repository Structure

```plaintext
sql-sales-analysis/
│── README.md
│── queries/
│   ├── day0_DDL.sql
│   ├── day1_data_validation.sql
│   ├── day2_profitability_analysis.sql
│   ├── day3_cross_tabulation_analysis.sql
│── dataset/
│   ├── sales.csv
│   ├── products.csv
│   ├── customers.csv
```

---

# Project Value

This project demonstrates how SQL can be used not only to query data, but to support commercial interpretation and business decision-making.

# Español
## Herramientas utilizadas

* PostgreSQL
* SQL
* Análisis de negocio

---

## Objetivo del proyecto

Este proyecto analiza las transacciones de venta para identificar cómo las categorías, los productos, los descuentos y la fidelización de clientes impactan en los ingresos, las ganancias y el margen.

El análisis se centra en transformar los datos transaccionales brutos en información útil para la toma de decisiones empresariales mediante la exploración estructurada con SQL.

---

## Preguntas de negocio

* ¿Qué categorías generan los mayores ingresos?

* ¿Qué categorías son financieramente más eficientes?

* ¿Cómo afectan los descuentos a la rentabilidad?

* ¿Qué productos generan el mayor margen de beneficio?

* ¿Qué productos generan pérdidas?

* ¿Cómo influye la fidelización de clientes en la rentabilidad del producto?

---

## Resumen del conjunto de datos

Tablas utilizadas en el proyecto:

* `ventas`
* `productos`
* `clientes`

Principales variables de negocio analizadas:

* `cantidad`
* `precio_unitario`
* `descuento`
* `costo`
* `categoría`
* `nivel_fidelidad`

---

# Hoja de ruta del análisis

## Día 1: Comprensión y validación de datos

La exploración inicial se centró en validar la consistencia de las tablas e identificar anomalías antes de comenzar el análisis de negocio.

### Validaciones principales

* Se detectaron valores nulos en `descuento`.
* Los descuentos nulos se trataron como `0` utilizando `COALESCE()` para el cálculo de ingresos.
* Los descuentos nulos también se conservaron como una anomalía de negocio para su interpretación.

### Conclusiones clave

Los registros de descuento nulos representaban una parte importante de los ingresos, por lo que se incorporaron analíticamente en lugar de eliminarse.

---

## Día 2 — Análisis de Ingresos, Ganancias y Descuentos

### Ingresos por Categoría

El sector de Muebles mostró el mayor peso comercial, con múltiples productos de alta rentabilidad.

### Ganancias por Categoría

El sector de Electrónica logró la mayor eficiencia en las ganancias, a pesar de un menor dominio en los ingresos.

### Margen según el Estado del Descuento

Las ventas con descuento generaron un alto volumen, pero menor eficiencia:

* Descuento Aplicado → **38,28% de margen**

* Sin Descuento → **50,44% de margen**

### Conclusión Estratégica

Los descuentos aumentan la demanda comercial, pero reducen significativamente el margen de beneficio.

---

## Día 3 — Análisis Estratégico de Producto y Cliente

### Productos Líderes

* Producto_19 = mayor margen de cartera (**87,29%**)
* Producto_14 = alta rentabilidad premium
* Producto_15 = rendimiento consistente en todos los segmentos

### Alertas de Rentabilidad

* Producto_7 = margen negativo más crítico (**-34,74%**)

### Comportamiento del Cliente

Los clientes Oro generan la mayor concentración de ganancias en productos estratégicos.

Los clientes Bronce suelen obtener márgenes más altos en combinaciones premium.

--

# Resumen Ejecutivo

## Análisis de Ingresos

El mobiliario domina la presencia de productos en el ranking de ingresos, mientras que los accesorios revelan una fortaleza inesperada a nivel de producto.

## Análisis de Rentabilidad

Electrónica y Mobiliario concentran la mayor eficiencia financiera.

## Riesgos de Descuento

Las políticas de descuento mejoran el volumen, pero debilitan la rentabilidad estructural.

## Oportunidades de Producto

El Producto_19 emerge como el activo estratégico más sólido de la cartera.

## Información sobre el cliente

La rentabilidad del cliente varía significativamente según su nivel de fidelización y la combinación de productos.

---

# Recomendaciones comerciales

* Revisar las políticas de descuento en Muebles y Accesorios
* Priorizar los productos 19, 14 y 15 en campañas estratégicas
* Reevaluar el precio y la estructura de costos del producto 7
* Mejorar la conversión del segmento Plata en productos de alto margen
* Replicar patrones de compra eficientes del segmento Bronce

---

# Técnicas SQL aplicadas

* CTE
* CASE WHEN
* COALESCE
* LEFT JOIN
* Agregaciones
* Cálculos de margen
* Análisis de contribución a las ganancias
* Segmentación de clientes

---

# Estructura del repositorio

```plaintext
sql-sales-analysis/
│── README.md
│── queries/
│ ├── day0_DDL.sql
│ ├── day1_data_validation.sql
│ ├── day2_profitability_analysis.sql
│ ├── day3_cross_tabulation_analysis.sql
│── dataset/
│ ├── sales.csv
│ ├── products.csv
│ ├── customers.csv
```

---

# Valor del proyecto

Este proyecto demuestra cómo SQL puede utilizarse no solo para consultar datos, sino también para respaldar la interpretación comercial y la toma de decisiones empresariales.