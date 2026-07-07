# Guia Rapida de Servicios de GCP (Conceptos de Examen)

Esta guia recopila definiciones, palabras clave ("triggers") y casos de uso de servicios de Google Cloud que suelen aparecer en las preguntas de certificacion pero no se abordan en profundidad en las guias principales.

---

## Networking y Seguridad de Red

### Cloud Armor
*   **Definicion:** Filtro de seguridad perimetral y Firewall de Aplicacion Web (WAF) que protege servicios frente a ataques DDoS y exploits web comunes. Se integra directamente con HTTP(S) Load Balancing.
*   **Palabras Clave (Keywords):** *Proteccion DDoS*, *WAF*, *OWASP Top 10*, *Geobloqueo (bloquear por pais)*, *Lista blanca/negra de IPs*, *Prevenir inyeccion SQL (SQLi) o Cross-Site Scripting (XSS)*.
*   **Caso de Uso de Examen:** Necesitas asegurar que tu aplicacion web detras de un balanceador de carga global HTTPS solo sea accesible desde IPs corporativas de tu pais y bloquear cualquier intento de ataque de inyeccion de codigo.

### Cloud NAT (Network Address Translation)
*   **Definicion:** Permite que instancias de VM sin direcciones IP publicas accedan a internet para actualizaciones o parches, bloqueando conexiones entrantes no deseadas desde el exterior.
*   **Palabras Clave (Keywords):** *VM sin IP publica accede a internet*, *Conexiones salientes (outbound only)*, *Seguridad de VMs privadas*, *Actualizaciones de software en red privada*.
*   **Caso de Uso de Examen:** Tienes un grupo de instancias de Compute Engine privadas que no deben ser accesibles desde internet, pero requieren descargar dependencias externas y actualizaciones periodicas del sistema operativo de manera segura.

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

### Cloud Monitoring
*   **Definicion:** Proporciona visibilidad del rendimiento, la disponibilidad y la salud general de las aplicaciones y la infraestructura mediante metricas, tableros y alertas.
*   **Palabras Clave (Keywords):** *Metricas de rendimiento*, *Uso de CPU/Memoria*, *Alertas (Alerting Policies)*, *Dashboard*, *Sondeo de uptime (Uptime checks)*.
*   **Caso de Uso de Examen:** Deseas recibir una notificacion por correo electronico y Slack inmediatamente si la utilizacion de CPU de tu grupo de instancias supera el 85% durante mas de 5 minutos continuos.

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
