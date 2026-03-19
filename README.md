# Día 1. Limpieza de datos (Tabla Transaccional Sales)
La primera fase se enfocó en la limpieza y estandarización de la tabla transaccional sales antes de empezar el analisis empresarial. 

# Problemas principales detectados

- Valores nulos en quantity (1.4%)
- Valores nulos en discount (20.8%)
- Inconsistencias de valores en campos channel y región

# Decisiones de limpieza

- Imputar valores nulos de quantity con 1.
- Estandarizar campos de channel y region usando TRIM + INITCAP.
- Preservar valores nulos de discount y marcarlos como anomalías.

# Justificación empresarial
Se preservaron los valores nulos de discount para no distorsionar la estructura de precios real de la compañia, identificando y marcando los valores incosistentes como una mejora potencial en los procesos. 

# Información Clave
El principal riesgo analitico detectado fue el 20.8% de valores nulos en discount, lo cual afecta directamente el cálculo revenue, profit y margen. En cambio de una imputación artifical de valores, las anomalías fueron preservadas para una investigación posterior. 

## Impacto analítico de anomalías detectadas

Durante la fase de limpieza se identificó que el 20.8% de los registros de ventas presentan valores nulos en el campo `discount`, por lo que fueron clasificados como anomalías y marcados para seguimiento.

Posteriormente se evaluó el impacto financiero de estas anomalías y se encontró que dichos registros representan el **25.03% del revenue total**, lo que demuestra que no se trata de inconsistencias marginales sino de datos con peso económico relevante.

### Decisión analítica aplicada

Para mantener continuidad en el análisis financiero de Revenue, Profit y Margin, los valores nulos en `discount` fueron tratados temporalmente como cero mediante:

`COALESCE(discount,0)`

Esto implica asumir que la ausencia de valor corresponde a ausencia de descuento.

### Consideración metodológica

Dado que una cuarta parte del revenue depende de registros con discount nulo, los resultados financieros deben interpretarse bajo este supuesto analítico temporal.

### Recomendación de negocio

Se recomienda validar con el área operativa o con la fuente transaccional si estos valores corresponden a:

* descuentos no registrados
* errores de captura
* fallas del sistema de ventas

El objetivo es reducir estas inconsistencias a menos del 1% y fortalecer la confiabilidad del análisis financiero futuro.


# Herramientas Implementadas
 - PostgreSQL
 - SQL (Data Cleaning) 

 # Día 2. Análisis de negocio (Revenue, Profit y Margin)

En esta segunda fase se desarrolló el análisis empresarial utilizando SQL para transformar datos transaccionales en indicadores de rentabilidad y decisiones de negocio.

## Objetivo analítico

Identificar qué dimensiones del negocio generan mayor ingreso, utilidad y eficiencia financiera mediante el cálculo de:

* Revenue
* Profit
* Margin %

## Métricas construidas

### Revenue

Ingresos netos después de descuentos:

Revenue = quantity * unit_price * (1 - discount)

### Profit

Utilidad neta:

Profit = Revenue - (quantity * cost)

### Margin %

Rentabilidad relativa:

Margin = Profit / Revenue * 100

---

## Dimensiones analizadas

### 1. Canal de venta

Se evaluó el desempeño entre canal Online y Store.

**Insight de negocio:**

No existe dependencia estructural ni desequilibrio financiero relevante entre canales.

---

### 2. Categoría de producto

Se analizó Furniture, Electronics y Accessories.

**Hallazgos principales:**

* Furniture lidera revenue y profit.
* Electronics presenta el mayor margin.
* Accessories muestra menor eficiencia relativa.

**Insight de negocio:**

Electronics es la categoría más eficiente financieramente.

---

### 3. Nivel de fidelización

Se analizó Bronze, Silver y Gold.

**Hallazgos principales:**

* Gold concentra casi la mitad del revenue total.
* Gold también lidera profit y margin.

**Insight de negocio:**

Gold representa el segmento estratégico principal del negocio.

---

### 4. Región

Se analizó North, South, East y West.

**Hallazgos principales:**

* North lidera revenue.
* West presenta el mayor margin.

**Insight de negocio:**

West convierte mejor sus ingresos en utilidad y representa la región con mayor potencial rentable.

---

## Principales aprendizajes de negocio

* Revenue alto no siempre significa mayor eficiencia.
* Profit debe analizarse junto con margin.
* Algunas dimensiones venden más, pero otras generan mejor retorno.

---

## Recomendaciones estratégicas

* Escalar categorías y regiones con mayor margin.
* Revisar dimensiones con alta venta y menor eficiencia.
* Priorizar crecimiento rentable sobre crecimiento por volumen.
