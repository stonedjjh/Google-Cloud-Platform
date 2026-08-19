# Guia Rapida de Servicios de GCP (Conceptos de Examen)

Esta guia recopila definiciones, palabras clave ("triggers") y casos de uso de servicios de Google Cloud que suelen aparecer en las preguntas de certificacion pero no se abordan en profundidad en las guias principales.

---

## Networking y Seguridad de Red

### Cloud Armor
*   **Definicion:** Filtro de seguridad perimetral y Firewall de Aplicacion Web (WAF) que protege servicios frente a ataques DDoS y exploits web comunes. Se integra directamente con HTTP(S) Load Balancing.
*   **Palabras Clave (Keywords):** *Proteccion DDoS*, *WAF*, *OWASP Top 10*, *Geobloqueo (bloquear por pais)*, *Lista blanca/negra de IPs*, *Prevenir inyeccion SQL (SQLi) o Cross-Site Scripting (XSS)*.
*   **Caso de Uso de Examen:** Necesitas asegurar que tu aplicacion web detras de un balanceador de carga global HTTPS solo sea accesible desde IPs corporativas de tu pais y bloquear cualquier intento de ataque de inyeccion de codigo.
*   **Restricción de Examen:** Cloud Armor **no** se puede asociar directamente a instancias de Compute Engine (VMs). Se debe aplicar en el perímetro a través de un balanceador de carga (HTTP/S Load Balancer) o Cloud CDN.


### Cloud NAT (Network Address Translation)
*   **Definicion:** Permite que instancias de VM sin direcciones IP publicas accedan a internet para actualizaciones o parches, bloqueando conexiones entrantes no deseadas desde el exterior.
*   **Palabras Clave (Keywords):** *VM sin IP publica accede a internet*, *Conexiones salientes (outbound only)*, *Seguridad de VMs privadas*, *Actualizaciones de software en red privada*.
*   **Caso de Uso de Examen:** Tienes un grupo de instancias de Compute Engine privadas que no deben ser accesibles desde internet, pero requieren descargar dependencias externas y actualizaciones periodicas del sistema operativo de manera segura.

### Network Endpoint Group (NEG)

* **Definición:** Conjunto de endpoints (instancias de VM, contenedores o direcciones IP) que sirven como destino para un balanceador de carga, permitiendo agrupar y gestionar servicios sin necesidad de direcciones IP estáticas.

* **Palabras Clave (Keywords):** *Endpoint Group*, *NEG*, *Balanceador de carga HTTP(S)*, *Backend service*, *IP sin estado*, *Autoscaling*.

* **Caso de Uso de Examen:** Necesitas exponer un conjunto de instancias de Compute Engine que se escalan automáticamente como backend de un balanceador HTTP(S) sin asignar IPs públicas a cada instancia.


### VPC Service Controls
*   **Definicion:** Define un perimetro de seguridad alrededor de los recursos de servicios gestionados de GCP (como Cloud Storage, BigQuery o Cloud SQL) para mitigar el riesgo de exfiltracion de datos.
*   **Palabras Clave (Keywords):** *Perimetro de seguridad*, *Mitigar exfiltracion de datos*, *Acceso privado a APIs de Google*, *Bloquear acceso a recursos fuera del perimetro*.
*   **Caso de Uso de Examen:** Tu empresa maneja datos extremadamente sensibles en BigQuery y debes garantizar que ningun empleado pueda copiar o mover esos datos a un dataset o bucket externo de Cloud Storage fuera de la organizacion de GCP, incluso si tienen permisos de IAM.

### Cloud IAP (Identity-Aware Proxy)
*   **Definicion:** Controla el acceso a aplicaciones web y maquinas virtuales ejecutadas en GCP verificando la identidad del usuario y el contexto de su solicitud, sin necesidad de usar una VPN corporativa tradicional.
*   **Palabras Clave (Keywords):** *Acceso sin VPN*, *Verificacion basada en identidad y contexto*, *Acceso SSH/RDP seguro (IAP Desktop)*, *Acceso condicional*.
*   **Caso de Uso de Examen:** Deseas permitir que tus desarrolladores accedan de forma segura por SSH a maquinas virtuales privadas en Compute Engine sin exponer los puertos a internet ni configurar una VPN compleja.

---

## Criptografia y Gestion de Secretos

### Cloud KMS (Key Management Service)
*   **Definicion:** Servicio gestionado que permite crear, rotar, usar y destruir claves criptograficas para encriptar datos en GCP (claves de cifrado administradas por el cliente - Customer-Managed Encryption Keys / CMEK).
*   **Palabras Clave (Keywords):** *Administracion de llaves criptograficas*, *CMEK*, *Rotacion de llaves*, *Sobres de encriptacion (Envelope Encryption)*.
*   **Caso de Uso de Examen:** Las politicas de cumplimiento de tu empresa exigen que los datos almacenados en Cloud Storage esten encriptados con llaves bajo tu propio control y que estas llaves se roten automaticamente cada 90 dias.

### Secret Manager
*   **Definicion:** Almacenamiento seguro para datos sensibles como contraseñas de bases de datos, llaves de API, tokens y certificados.
*   **Palabras Clave (Keywords):** *Guardar contraseñas/credenciales*, *API keys*, *Certificados SSL*, *Evitar credenciales en codigo*.
*   **Caso de Uso de Examen:** Tu aplicacion desplegada en App Engine necesita conectarse a una base de datos MySQL externa. Debes evitar escribir la contraseña en texto plano en los archivos de configuracion o en el codigo fuente.

---

## Identidad y Acceso

### Workload Identity Federation
*   **Definicion:** Permite que cargas de trabajo externas a GCP (como servidores locales, AWS o Azure) se autentiquen de forma segura en Google Cloud utilizando sus identidades existentes, eliminando la necesidad de descargar llaves JSON de cuentas de servicio.
*   **Palabras Clave (Keywords):** *Eliminar llaves JSON externas*, *Autenticar AWS/Azure/On-Premises en GCP*, *Federacion OIDC/SAML*, *Acceso seguro de maquina a maquina fuera de GCP*.
*   **Caso de Uso de Examen:** Un pipeline de despliegue en GitHub Actions o un servidor en tu data center local necesita subir archivos a un bucket de Cloud Storage, pero las politicas de seguridad prohiben estrictamente la creacion y descarga de llaves JSON manuales.

### Google Cloud Directory Sync (GCDS)
*   **Definicion:** Herramienta de sincronización unidireccional que copia usuarios, grupos y datos de contacto desde un directorio Active Directory o LDAP local hacia Cloud Identity o Google Workspace.
*   **Palabras Clave (Keywords):** *Sincronización unidireccional (local a la nube)*, *Active Directory / LDAP*, *Sincronizar usuarios y grupos*, *No sincroniza contraseñas (requiere SAML/SSO para login)*.
*   **Caso de Uso de Examen:** Tienes una infraestructura local con miles de identidades gestionadas en Active Directory corporativo. Deseas automatizar la creación y actualización diaria de estas cuentas en Cloud Identity sin cambiar la fuente de verdad (Active Directory local).

### Políticas de la Organización (Organization Policies / Restricciones)
*   **Definicion:** Reglas de cumplimiento y gobernanza aplicadas a nivel de Organización, Carpeta o Proyecto que imponen restricciones de configuración sobre los recursos de GCP (ej. deshabilitar IPs públicas, limitar la ubicación de creación de recursos).
*   **Palabras Clave (Keywords):** *Restricciones organizacionales (Constraints)*, *Gobernanza corporativa*, *Garantizar cumplimiento de seguridad*, *Heredado/Sobrescrito (Inherit/Override)*, *Impedir el uso de recursos específicos*.
*   **Caso de Uso de Examen:** El departamento de seguridad de tu empresa requiere garantizar que ningún desarrollador pueda crear máquinas virtuales con direcciones IP externas públicas en ningún proyecto de la compañía, o restringir la creación de recursos únicamente en la región `us-east1` y `us-central1`.

---

## Integracion de Aplicaciones y DevOps

### Cloud Tasks
*   **Definicion:** Servicio de colas de tareas diseñado para ejecutar tareas asincronas fuera del flujo principal de la aplicacion. Permite controlar la velocidad de ejecucion y programar reintentos de forma precisa.
*   **Palabras Clave (Keywords):** *Cola de tareas asincronas (Queue)*, *Control de tasa de ejecucion (Rate limiting)*, *Reintentos automaticos con retraso exponencial*, *Peticiones dirigidas a backends HTTP/App Engine*.
*   **Caso de Uso de Examen:** Despues de que un usuario compra un producto, necesitas generar una factura en formato PDF y enviarsela por correo. Deseas procesar esta tarea en segundo plano sin ralentizar la respuesta HTTP de compra del usuario.

### Cloud Scheduler
*   **Definicion:** Cron job corporativo totalmente gestionado que permite programar ejecuciones de tareas a intervalos de tiempo definidos.
*   **Palabras Clave (Keywords):** *Cron job serverless*, *Programar tareas periodicas*, *Disparar funciones o Pub/Sub a una hora especifica*, *Formato unix-cron*.
*   **Caso de Uso de Examen:** Necesitas automatizar un script de limpieza de base de datos para que se ejecute todas las noches a las 2:00 AM disparando una Cloud Function.

### Cloud Pub/Sub
*   **Definicion:** Servicio de mensajeria asincrona estructurado bajo el patron publicador-suscriptor para la integracion de microservicios y flujos de analisis de datos en tiempo real (ingesta de datos).
*   **Palabras Clave (Keywords):** *Desacoplamiento de microservicios*, *Mensajeria asincrona*, *Ingesta de datos a gran escala (IoT)*, *Event-driven (arquitectura basada en eventos)*.
*   **Caso de Uso de Examen:** Estas diseñando una arquitectura donde miles de dispositivos IoT envian telemetria constantemente y necesitas recibir e ingresar estos datos de forma asincrona y confiable antes de procesarlos en BigQuery.

---

## Operaciones y Monitoreo (Cloud Operations Suite)

### Cloud Logging
*   **Definicion:** Servicio centralizado de almacenamiento, busqueda y analisis de logs generados por los servicios y aplicaciones de GCP.
*   **Palabras Clave (Keywords):** *Almacenamiento de logs*, *Auditoria de accesos*, *Exportar logs a BigQuery/Cloud Storage (Log Sinks)*, *Filtros de logs*.
*   **Caso de Uso de Examen:** Necesitas conservar todos los logs de auditoria de tu VPC durante un periodo de 7 años por normativas de cumplimiento legales (Log Sink hacia Cloud Storage en clase Archive).

### Cloud Audit Logs
*   **Definicion:** Registro de auditoría integrado que documenta de forma inmutable quién hizo qué, dónde y cuándo en tus proyectos de Google Cloud.
*   **Palabras Clave (Keywords):** *Admin Activity Logs (Gratis, retención 400 días)*, *Data Access Logs (De pago, deshabilitados por defecto, retención 30 días)*, *System Event Logs*, *Policy Denied Logs*, *Inmutabilidad y Auditoría*.
*   **Caso de Uso de Examen:** Ocurrió un incidente de seguridad donde un bucket privado se volvió público y se eliminaron archivos confidenciales. Debes identificar exactamente qué cuenta de usuario o cuenta de servicio realizó la llamada a la API que cambió los permisos y borró los archivos (usando Admin Activity Logs).

### Cloud Monitoring
*   **Definicion:** Proporciona visibilidad del rendimiento, la disponibilidad y la salud general de las aplicaciones y la infraestructura mediante metricas, tableros y alertas.
*   **Palabras Clave (Keywords):** *Metricas de rendimiento*, *Uso de CPU/Memoria*, *Alertas (Alerting Policies)*, *Dashboard*, *Sondeo de uptime (Uptime checks)*.
*   **Caso de Uso de Examen:** Deseas recibir una notificacion por correo electronico y Slack inmediatamente si la utilizacion de CPU de tu grupo de instancias supera el 85% durante mas de 5 minutos continuos.

### Ops Agent (Agente de Operaciones)
*   **Definicion:** Telemetría y agente unificado que se instala dentro de los sistemas operativos de las máquinas virtuales de Compute Engine para recolectar logs del sistema, logs de aplicaciones de terceros y métricas detalladas del sistema operativo (como uso de memoria RAM o espacio de almacenamiento en disco).
*   **Palabras Clave (Keywords):** *Instalar en VMs de Compute Engine*, *Recopilar logs internos*, *Recopilar métricas de memoria RAM y espacio de disco*, *Logs del sistema operativo*, *Agente unificado (sustituye a los agentes antiguos de Logging y Monitoring)*.
*   **Caso de Uso de Examen:** Compute Engine no reporta por defecto el uso de la memoria RAM ni el espacio libre en los discos de tus VMs a Cloud Monitoring. Necesitas instalar y configurar el **Ops Agent** en cada una de tus instancias para poder monitorizar estas métricas internas del sistema operativo y definir políticas de escalado o alertas basadas en ellas.

### Error Reporting
*   **Definicion:** Agrupa y centraliza los errores y excepciones crash de tus aplicaciones en ejecucion, notificando cuando se detecta una nueva excepcion.
*   **Palabras Clave (Keywords):** *Excepciones de aplicaciones*, *Crash reporting*, *Agrupacion de errores de codigo*.
*   **Caso de Uso de Examen:** Tu aplicacion web en produccion esta experimentando fallos intermitentes de codigo y necesitas un panel centralizado que agrupe estas excepciones por tipo e identifique que lineas de codigo las causaron.

### Cloud Trace
*   **Definicion:** Sistema de rastreo distribuido que recopila metricas de latencia de las aplicaciones, ayudando a identificar cuellos de botella en arquitecturas de microservicios.
*   **Palabras Clave (Keywords):** *Latencia de peticiones*, *Rastreo distribuido*, *Analisis de rendimiento de API*, *Cuellos de botella*.
*   **Caso de Uso de Examen:** Un usuario se queja de que una peticion web tarda mas de 10 segundos en completarse. Necesitas rastrear la peticion a través de los multiples microservicios que atraviesa para ver cual de ellos esta causando el retraso.

### Cloud Profiler
*   **Definicion:** Monitorea continuamente el consumo de recursos de CPU y memoria de tu aplicacion en produccion para identificar funciones de codigo ineficientes que incrementan los costos.
*   **Palabras Clave (Keywords):** *Consumo de CPU/Memoria en codigo*, *Optimizacion de codigo*, *Llamadas a funciones costosas*.
*   **Caso de Uso de Examen:** Quieres optimizar el codigo de tu servidor para reducir el consumo de recursos y ahorrar costos, localizando las lineas y funciones especificas que mas memoria consumen durante su ejecucion ordinaria.

---

## Bases de Datos

### AlloyDB for PostgreSQL
*   **Definicion:** Servicio de base de datos relacional totalmente gestionado y 100 % compatible con PostgreSQL, diseñado para las cargas de trabajo empresariales mas exigentes. Combina lo mejor de Google (escalabilidad y almacenamiento desacoplado) con motores optimizados que multiplican el rendimiento transaccional (hasta 4 veces mas rapido) y analitico (hasta 100 veces mas rapido) frente a un PostgreSQL estandar.
*   **Palabras Clave (Keywords):** *PostgreSQL empresarial de alto rendimiento*, *HTAP (Hibrido Transaccional y Analitico)*, *Almacenamiento columnar en memoria*, *Compatibilidad completa con PostgreSQL*, *Auto-escalabilidad de almacenamiento sin downtime*.
*   **Caso de Uso de Examen:** Tienes una aplicacion critica basada en PostgreSQL local con alta carga de lecturas transaccionales y analisis en tiempo real. Deseas migrarla a un servicio administrado en la nube que ofrezca un rendimiento masivamente superior pero que mantenga compatibilidad absoluta con tus consultas y extensiones actuales de PostgreSQL.

### Cloud Filestore
*   **Definicion:** Servidor de almacenamiento de archivos de red (NAS) completamente gestionado que expone un sistema de archivos compatible con NFSv3 para ser montado de forma compartida por múltiples VMs de Compute Engine o clústeres de GKE.
*   **Palabras Clave (Keywords):** *Almacenamiento compartido NFS (NFSv3)*, *Montaje en múltiples VMs simultáneas (ReadWriteMany)*, *Capacidad provisionada*.
*   **Caso de Uso de Examen:** Tienes una aplicación de gestión de contenido web (como Drupal o WordPress) ejecutándose sobre un grupo de instancias de Compute Engine. Necesitas que todos los servidores web tengan acceso inmediato de lectura y escritura al mismo directorio compartido de imágenes y assets de forma síncrona.
*   **Restricción de Examen:** Se paga por **capacidad reservada/aprovisionada** (no por uso real). En los tiers **Básicos (Basic HDD / Basic SSD)** la capacidad solo se puede incrementar y **no es posible decrementarla (reducirla)** en caliente; para reducir capacidad se requiere aprovisionar un nuevo Filestore. Los tiers **Enterprise y High Scale** sí permiten reducción dinámica de capacidad.

---

## Procesamiento y Análisis de Datos (Big Data)

### Cloud Dataflow
*   **Definicion:** Servicio de procesamiento de datos completamente gestionado y serverless basado en Apache Beam. Permite ejecutar tuberías (pipelines) de datos a gran escala automatizando el aprovisionamiento y el escalado de los recursos de cómputo.
*   **Palabras Clave (Keywords):** *Unified Stream and Batch*, *Procesamiento en tiempo real (Streaming)*, *Serverless Big Data*, *Apache Beam*, *Transformación de datos al vuelo (ETL)*.
*   **Caso de Uso de Examen:** Necesitas construir un pipeline completamente serverless que reciba datos de telemetria en tiempo real desde Cloud Pub/Sub, limpie y transforme los datos JSON al vuelo, y los envíe inmediatamente a un modelo de Machine Learning y a una base de datos NoSQL sin administrar servidores.

### Cloud Dataproc
*   **Definicion:** Servicio administrado para ejecutar clústeres de Apache Hadoop y Apache Spark. Permite migrar entornos tradicionales de Big Data a la nube de forma rápida, delegando la creación, gestión y apagado de las máquinas virtuales a GCP.
*   **Palabras Clave (Keywords):** *Hadoop / Spark*, *Hive / Pig / Flink*, *Migración Lift-and-Shift de Big Data*, *Ecosistema de código abierto (OSS)*, *Procesamiento por lotes (Batch) heredado*.
*   **Caso de Uso de Examen:** Tu equipo de ciencia de datos tiene un entorno local con clústeres de Hadoop y procesos masivos escritos en Apache Spark para análisis histórico. Debes migrar estos flujos de trabajo a GCP antes del fin de semana minimizando el esfuerzo de reescritura de código y manteniendo las mismas herramientas.

### Looker Studio (Anteriormente Data Studio)
*   **Definicion:** Herramienta de visualización de datos y generación de informes (Business Intelligence - BI) completamente gratuita y basada en la web que permite crear dashboards interactivos y reportes a partir de múltiples fuentes de datos.
*   **Palabras Clave (Keywords):** *Visualización de datos gratuita*, *Creación de dashboards interactivos*, *Reportes de BI web*, *Conectores nativos (BigQuery, Google Analytics, Sheets)*.
*   **Caso de Uso de Examen:** Necesitas proporcionar al departamento de marketing y ventas un panel interactivo y visual en tiempo real que muestre las métricas clave de rendimiento y ventas extraídas directamente de las tablas analíticas en BigQuery, sin incurrir en costes de licencias de BI complejas.

---

## Transferencia y Migración de Datos

### Storage Transfer Service
*   **Definicion:** Servicio gestionado para transferir datos de forma rápida y segura a Cloud Storage desde otras nubes (como AWS S3 o Azure Blob Storage), ubicaciones locales (mediante agentes) o entre buckets de GCP.
*   **Palabras Clave (Keywords):** *Transferencia online a Cloud Storage*, *Migración desde AWS S3 / Azure*, *Agentes locales*, *Sincronización programada*, *Ancho de banda superior a 20 Gbps* (para escalas menores a 20 TB funciona bien con conexiones normales de internet).
*   **Caso de Uso de Examen:** Tu empresa tiene 15 TB de backups de datos almacenados en buckets de Amazon S3 y necesitas migrarlos todos de manera automatizada y programada hacia un bucket de Cloud Storage en GCP a través de internet pública.

### Transfer Appliance
*   **Definicion:** Servidor de almacenamiento robusto y de alta capacidad que Google te envía físicamente para que cargues tus datos locales de forma offline y los envíes por mensajería a un centro de datos de GCP para subirlos a Cloud Storage.
*   **Palabras Clave (Keywords):** *Transferencia física/offline*, *Dispositivo robusto (hardware)*, *Más de 20 TB de datos*, *Conexión a internet lenta o limitada*, *Tiempo de transferencia de red inviable (semanas/meses)*.
*   **Caso de Uso de Examen:** Tienes un centro de datos local con 120 TB de imágenes y videos históricos que debes subir a Cloud Storage. Tu ancho de banda de subida a internet es de solo 10 Mbps, por lo que la transferencia por red tardaría años.

### Offline Media Import (Importación de Medios Offline)
*   **Definicion:** Servicio que permite enviar tus propios discos duros físicos (HDD/SSD) o cintas directamente a un proveedor externo asociado de Google para que carguen los datos en tus buckets de Cloud Storage.
*   **Palabras Clave (Keywords):** *Enviar tus propios discos físicos*, *Terceros asociados (partners)*, *Cargas offline con hardware propio*.
*   **Caso de Uso de Examen:** Tu empresa tiene discos duros físicos encriptados listos para ser retirados y deseas que esos datos exactos se carguen en GCP sin tener que alquilar un Transfer Appliance de Google.

---

## Administración de Recursos y Gobernanza

### Cuotas (Quotas)
*   **Definicion:** Límites impuestos por Google Cloud sobre el consumo de recursos (como número de CPU virtuales, direcciones IP estáticas o cuotas de peticiones API por minuto) para evitar picos de costes inesperados y prevenir abusos de recursos en el sistema.
*   **Palabras Clave (Keywords):** *Límites de recursos en GCP*, *Prevenir picos de costos*, *Rate Limits (cuotas de API)*, *Allocation Quotas (límites físicos)*, *Solicitar incremento de cuota*.
*   **Caso de Uso de Examen:** Estás aprovisionando un clúster de cómputo masivo y la creación de VMs se detiene repentinamente con un error de límite de CPUs en la región. Debes navegar al panel de Cuotas en la consola de IAM & Admin y enviar una solicitud formal de incremento a Google para poder continuar.

### Etiquetas de Recursos (Labels)
*   **Definicion:** Parejas de clave-valor asociadas directamente a los recursos individuales (VMs, buckets, discos) utilizadas principalmente para organizar de forma lógica y realizar el seguimiento de la facturación detallada.
*   **Palabras Clave (Keywords):** *Clave-valor para facturación*, *Organización interna*, *Filtrado de costes en informes de facturación (Billing)*, *Metadatos del recurso*.
*   **Caso de Uso de Examen:** El departamento de finanzas necesita desglosar y agrupar el costo mensual de almacenamiento y cómputo que consume específicamente el entorno de "desarrollo" versus el de "producción" para optimizar el presupuesto.
*   **Restricción de Examen:** Existe un límite físico estricto de **un máximo de 64 etiquetas (labels)** que se pueden asociar a un único recurso en Google Cloud.


### Etiquetas de Red / Seguridad (Tags)
*   **Definicion:** Identificadores simples basados en cadenas de texto plano que se aplican a recursos específicos (como Compute Engine) para asociarles reglas de firewall o rutas de red específicas de forma dinámica.
*   **Palabras Clave (Keywords):** *Target Tags en reglas de firewall*, *Rutas personalizadas basadas en tags*, *Redirección de tráfico*.
*   **Caso de Uso de Examen:** Quieres permitir que solo un grupo selecto de servidores web de Compute Engine reciban tráfico en el puerto 80. Asignas a estas instancias el tag `web-server` y creas una regla de firewall de ingreso que apunte a ese tag.



