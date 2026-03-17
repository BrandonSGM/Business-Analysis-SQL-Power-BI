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

# Herramientas Implementadas
 - PostgreSQL
 - SQL (Data Cleaning) 