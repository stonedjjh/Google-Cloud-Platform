# Bigtable (Base de datos NoSQL de columnas anchas)

## Descripción general
Google Cloud Bigtable es un servicio de base de datos NoSQL de columnas anchas, totalmente gestionado y altamente escalable, inspirado en el diseño de Apache HBase. Está optimizado para cargas de trabajo de lectura/escritura de alta velocidad y grandes volúmenes de datos, como análisis en tiempo real, series temporales y datos de IoT.

## Características principales
- **Gestión total**: No se requiere provisionar ni mantener servidores; Google gestiona la infraestructura, replicación y actualizaciones.
- **Escalado horizontal automático**: Se pueden añadir o quitar nodos sin downtime, ajustando capacidad de procesamiento y almacenamiento.
- **Alto rendimiento**: Latencias de lectura en milisegundos y altas tasas de escritura (hasta millones de operaciones por segundo).
- **Modelo de datos basado en columnas**: Ideal para datos estructurados en filas con muchas columnas y para consultas por rango.
- **Integración con ecosistema GCP**: Compatible con Dataflow, Dataproc, BigQuery y herramientas de machine learning.
- **Seguridad**: Cifrado en reposo y en tránsito (HTTPS/TLS) y control de acceso mediante IAM.

## Datos clave
- **Tamaño**: Ilimitado; se paga por nodos y almacenamiento utilizado.
- **Tamaño máximo por celda**: 10 MiB.
- **Caché en memoria**: El cliente de Bigtable incluye un caché local que reduce la latencia, aunque la base de datos no es estrictamente "serverless".
- **Modelo de costos**: Facturación por nodo de procesamiento (CPU + memoria) y por GB‑mes almacenado.

## Casos de uso típicos
- Series temporales (monitorización, métricas, IoT).
- Almacén de datos para análisis en tiempo real.
- Catálogo de productos y motores de recomendación.
- Aplicaciones que requieren lecturas/escrituras de alta velocidad a gran escala.

## Enlaces relacionados
- **[Documentación oficial de Cloud Bigtable](https://cloud.google.com/bigtable/docs)** – Guías de inicio rápido, referencia y buenas prácticas.
- **[Bigtable en Dataflow](https://cloud.google.com/dataflow/docs/guides/bigtable)** – Integración de procesamiento de datos.
- **[Bigtable y BigQuery](https://cloud.google.com/bigquery/docs/bigtable-integration)** – Exportar datos a BigQuery para análisis.
