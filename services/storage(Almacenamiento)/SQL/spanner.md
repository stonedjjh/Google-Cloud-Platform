# Spanner (Base de datos relacional global escalable)

## Descripción general
Google Cloud Spanner es un servicio de base de datos relacional distribuida globalmente que combina los beneficios de las bases de datos relacionales (transacciones ACID, SQL estándar) con la escalabilidad horizontal masiva de las bases de datos NoSQL. Permite mantener una consistencia estricta en escrituras e inserciones de datos en múltiples regiones.

## Características principales
- **Escalabilidad global:** Puede escalar horizontalmente a miles de nodos distribuidos en múltiples regiones, manteniendo una latencia de lectura/escritura baja.
- **Transacciones ACID y SQL estándar:** Soporta transacciones ACID a nivel global y una sintaxis SQL completa compatible con MySQL (con extensiones).
- **Alta disponibilidad y durabilidad:** Replicación síncrona en múltiples zonas y regiones con alta tolerancia a fallos y SLA del 99.999 %.
- **Consistencia estricta:** Proporciona una fuerte consistencia global con una única instancia de datos global, eliminando problemas de inconsistencia entre regiones.
- **Schema Evolvable:** Permite cambios en el esquema (como añadir columnas o tablas) sin downtime.
- **Cifrado de datos en reposo y en tránsito:** Soporta cifrado de datos en reposo con claves gestionadas por Google o por el usuario (CMEK), y TLS/SSL para transporte.
- **Integración con VPC y IAM:** Conexiones seguras mediante VPC Service Controls, IAM para autenticación y autorización, y Cloud Audit Logs.

## Tipos de instancias
- **Instancia Regional (Regional):** Datos replicados en tres zonas de una misma región. Ofrece alta disponibilidad y SLA del 99.99 %.
- **Instancia Multirregional (Multi-regional):** Datos replicados en tres regiones distintas, con un nodo principal en cada región. Ofrece SLA del 99.999 % y recuperación automática ante fallos de una región completa.

## Caso de uso
Spanner es ideal para aplicaciones críticas de negocio que requieren: disponibilidad global, escalabilidad masiva y consistencia estricta de datos. Ejemplos comunes incluyen sistemas financieros, plataformas de comercio electrónico, gestores de identidad, y aplicaciones que operan con grandes volúmenes de datos distribuidos geográficamente.

## Datos Clave
- **Tamaño máximo por instancia:** Hasta 8 TB por nodo. Se puede escalar horizontalmente añadiendo nodos.
- **Escalabilidad horizontal:** Se puede escalar añadiendo o quitando nodos, distribuyendo los datos entre ellos automáticamente.
- **SLA:** 99.999 % para instancias multirregionales y 99.99 % para instancias regionales.
- **Consistencia:** Fuerte consistencia global con transacciones ACID en múltiples zonas y regiones.
- **Conexión Segura:** Se recomienda usar Cloud SQL Auth Proxy para conexiones seguras sin exponer la IP pública de la instancia.
- **Mantenimiento:** Las actualizaciones de software y parches de sistema operativo se aplican de forma gradual para minimizar interrupciones.

## Enlaces relacionados
- **[Documentación oficial de Cloud Spanner](https://cloud.google.com/spanner)** – Guía completa y referencia.
- **[Guías de migración](https://cloud.google.com/spanner/docs/migrate)** – Pasos y herramientas para migrar bases de datos existentes.
- **[Cifrado de datos en reposo](https://cloud.google.com/spanner/docs/encryption)** – Opciones de cifrado y gestión de claves.
- **[Monitoreo y alertas](https://cloud.google.com/spanner/docs/monitoring)** – Métricas y alertas con Cloud Monitoring.