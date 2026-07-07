# ⚡ Guía Rápida de Servicios de GCP (Conceptos de Examen)

Esta guía recopila definiciones, palabras clave ("triggers") y casos de uso de servicios de Google Cloud que suelen aparecer en las preguntas de certificación pero no se abordan en profundidad en las guías principales.

---

## 🌐 Networking y Seguridad de Red

### 🛡️ Cloud Armor
*   **Definición:** Filtro de seguridad perimetral y Firewall de Aplicación Web (WAF) que protege servicios frente a ataques DDoS y exploits web comunes. Se integra directamente con HTTP(S) Load Balancing.
*   **Palabras Clave (Keywords):** *Protección DDoS*, *WAF*, *OWASP Top 10*, *Geobloqueo (bloquear por país)*, *Lista blanca/negra de IPs*, *Prevenir inyección SQL (SQLi) o Cross-Site Scripting (XSS)*.
*   **Caso de Uso de Examen:** Necesitas asegurar que tu aplicación web detrás de un balanceador de carga global HTTPS solo sea accesible desde IPs corporativas de tu país y bloquear cualquier intento de ataque de inyección de código.

### 🌐 Cloud NAT (Network Address Translation)
*   **Definición:** Permite que instancias de VM sin direcciones IP públicas accedan a internet para actualizaciones o parches, bloqueando conexiones entrantes no deseadas desde el exterior.
*   **Palabras Clave (Keywords):** *VM sin IP pública accede a internet*, *Conexiones salientes (outbound only)*, *Seguridad de VMs privadas*, *Actualizaciones de software en red privada*.
*   **Caso de Uso de Examen:** Tienes un grupo de instancias de Compute Engine privadas que no deben ser accesibles desde internet, pero requieren descargar dependencias externas y actualizaciones periódicas del sistema operativo de manera segura.

### 🔒 VPC Service Controls
*   **Definición:** Define un perímetro de seguridad alrededor de los recursos de servicios gestionados de GCP (como Cloud Storage, BigQuery o Cloud SQL) para mitigar el riesgo de exfiltración de datos.
*   **Palabras Clave (Keywords):** *Perímetro de seguridad*, *Mitigar exfiltración de datos*, *Acceso privado a APIs de Google*, *Bloquear acceso a recursos fuera del perímetro*.
*   **Caso de Uso de Examen:** Tu empresa maneja datos extremadamente sensibles en BigQuery y debes garantizar que ningún empleado pueda copiar o mover esos datos a un dataset o bucket externo de Cloud Storage fuera de la organización de GCP, incluso si tienen permisos de IAM.

### 🔑 Cloud IAP (Identity-Aware Proxy)
*   **Definición:** Controla el acceso a aplicaciones web y máquinas virtuales ejecutadas en GCP verificando la identidad del usuario y el contexto de su solicitud, sin necesidad de usar una VPN corporativa tradicional.
*   **Palabras Clave (Keywords):** *Acceso sin VPN*, *Verificación basada en identidad y contexto*, *Acceso SSH/RDP seguro (IAP Desktop)*, *Acceso condicional*.
*   **Caso de Uso de Examen:** Deseas permitir que tus desarrolladores accedan de forma segura por SSH a máquinas virtuales privadas en Compute Engine sin exponer los puertos a internet ni configurar una VPN compleja.

---

## 🔒 Criptografía y Gestión de Secretos

### 🔑 Cloud KMS (Key Management Service)
*   **Definición:** Servicio gestionado que permite crear, rotar, usar y destruir claves criptográficas para encriptar datos en GCP (claves de cifrado administradas por el cliente - Customer-Managed Encryption Keys / CMEK).
*   **Palabras Clave (Keywords):** *Administración de llaves criptográficas*, *CMEK*, *Rotación de llaves*, *Sobres de encriptación (Envelope Encryption)*.
*   **Caso de Uso de Examen:** Las políticas de cumplimiento de tu empresa exigen que los datos almacenados en Cloud Storage estén encriptados con llaves bajo tu propio control y que estas llaves se roten automáticamente cada 90 días.

### 🤫 Secret Manager
*   **Definición:** Almacenamiento seguro para datos sensibles como contraseñas de bases de datos, llaves de API, tokens y certificados.
*   **Palabras Clave (Keywords):** *Guardar contraseñas/credenciales*, *API keys*, *Certificados SSL*, *Evitar credenciales en código*.
*   **Caso de Uso de Examen:** Tu aplicación desplegada en App Engine necesita conectarse a una base de datos MySQL externa. Debes evitar escribir la contraseña en texto plano en los archivos de configuración o en el código fuente.

---

## ⚙️ Integración de Aplicaciones y DevOps

### ⏱️ Cloud Tasks
*   **Definición:** Servicio de colas de tareas diseñado para ejecutar tareas asíncronas fuera del flujo principal de la aplicación. Permite controlar la velocidad de ejecución y programar reintentos de forma precisa.
*   **Palabras Clave (Keywords):** *Cola de tareas asíncronas (Queue)*, *Control de tasa de ejecución (Rate limiting)*, *Reintentos automáticos con retraso exponencial*, *Peticiones dirigidas a backends HTTP/App Engine*.
*   **Caso de Uso de Examen:** Después de que un usuario compra un producto, necesitas generar una factura en formato PDF y enviársela por correo. Deseas procesar esta tarea en segundo plano sin ralentizar la respuesta HTTP de compra del usuario.

### 📅 Cloud Scheduler
*   **Definición:** Cron job corporativo totalmente gestionado que permite programar ejecuciones de tareas a intervalos de tiempo definidos.
*   **Palabras Clave (Keywords):** *Cron job serverless*, *Programar tareas periódicas*, *Disparar funciones o Pub/Sub a una hora específica*, *Formato unix-cron*.
*   **Caso de Uso de Examen:** Necesitas automatizar un script de limpieza de base de datos para que se ejecute todas las noches a las 2:00 AM disparando una Cloud Function.

### 📨 Cloud Pub/Sub
*   **Definición:** Servicio de mensajería asíncrona estructurado bajo el patrón publicador-suscriptor para la integración de microservicios y flujos de análisis de datos en tiempo real (ingesta de datos).
*   **Palabras Clave (Keywords):** *Desacoplamiento de microservicios*, *Mensajería asíncrona*, *Ingesta de datos a gran escala (IoT)*, *Event-driven (arquitectura basada en eventos)*.
*   **Caso de Uso de Examen:** Estás diseñando una arquitectura donde miles de dispositivos IoT envían telemetría constantemente y necesitas recibir e ingresar estos datos de forma asíncrona y confiable antes de procesarlos en BigQuery.

---

## 📊 Operaciones y Monitoreo (Cloud Operations Suite)

### 📝 Cloud Logging
*   **Definición:** Servicio centralizado de almacenamiento, búsqueda y análisis de logs generados por los servicios y aplicaciones de GCP.
*   **Palabras Clave (Keywords):** *Almacenamiento de logs*, *Auditoría de accesos*, *Exportar logs a BigQuery/Cloud Storage (Log Sinks)*, *Filtros de logs*.
*   **Caso de Uso de Examen:** Necesitas conservar todos los logs de auditoría de tu VPC durante un periodo de 7 años por normativas de cumplimiento legales (Log Sink hacia Cloud Storage en clase Archive).

### 📈 Cloud Monitoring
*   **Definición:** Proporciona visibilidad del rendimiento, la disponibilidad y la salud general de las aplicaciones y la infraestructura mediante métricas, tableros y alertas.
*   **Palabras Clave (Keywords):** *Métricas de rendimiento*, *Uso de CPU/Memoria*, *Alertas (Alerting Policies)*, *Dashboard*, *Sondeo de uptime (Uptime checks)*.
*   **Caso de Uso de Examen:** Deseas recibir una notificación por correo electrónico y Slack inmediatamente si la utilización de CPU de tu grupo de instancias supera el 85% durante más de 5 minutos continuos.

### ⚠️ Error Reporting
*   **Definición:** Agrupa y centraliza los errores y excepciones crash de tus aplicaciones en ejecución, notificando cuando se detecta una nueva excepción.
*   **Palabras Clave (Keywords):** *Excepciones de aplicaciones*, *Crash reporting*, *Agrupación de errores de código*.
*   **Caso de Uso de Examen:** Tu aplicación web en producción está experimentando fallos intermitentes de código y necesitas un panel centralizado que agrupe estas excepciones por tipo e identifique qué líneas de código las causaron.

### ⏱️ Cloud Trace
*   **Definición:** Sistema de rastreo distribuido que recopila métricas de latencia de las aplicaciones, ayudando a identificar cuellos de botella en arquitecturas de microservicios.
*   **Palabras Clave (Keywords):** *Latencia de peticiones*, *Rastreo distribuido*, *Análisis de rendimiento de API*, *Cuellos de botella*.
*   **Caso de Uso de Examen:** Un usuario se queja de que una petición web tarda más de 10 segundos en completarse. Necesitas rastrear la petición a través de los múltiples microservicios que atraviesa para ver cuál de ellos está causando el retraso.

### 🔎 Cloud Profiler
*   **Definición:** Monitorea continuamente el consumo de recursos de CPU y memoria de tu aplicación en producción para identificar funciones de código ineficientes que incrementan los costos.
*   **Palabras Clave (Keywords):** *Consumo de CPU/Memoria en código*, *Optimización de código*, *Llamadas a funciones costosas*.
*   **Caso de Uso de Examen:** Quieres optimizar el código de tu servidor para reducir el consumo de recursos y ahorrar costos, localizando las líneas y funciones específicas que más memoria consumen durante su ejecución ordinaria.
