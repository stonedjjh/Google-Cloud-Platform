# Cloud CDN (Content Delivery Network)

Google Cloud CDN es una red de distribución de contenido administrada de alto rendimiento que utiliza los puntos de presencia perimetrales (Edge Points of Presence) de Google ubicados en todo el mundo para almacenar en caché contenido estático y dinámico cerca de tus usuarios.

## Características Principales

- **Red Perimetral de Google (Edge Network):** Aprovecha la infraestructura global de Google para entregar datos con latencia mínima, acelerando la carga de páginas web y reduciendo el consumo de ancho de banda del backend.
- **Reducción de Costos y Carga:** Al responder las solicitudes directamente desde los cachés de borde de Google, se reduce significativamente la cantidad de solicitudes y la carga de procesamiento que llega a tus servidores de origen, disminuyendo también los costos de salida de datos (egress).
- **Tipos de Orígenes Soportados:** Puede obtener contenido desde:
  - Buckets de Google Cloud Storage (GCS).
  - Grupos de instancias de Compute Engine (VMs).
  - Clústeres de GKE.
  - Orígenes externos (servidores fuera de GCP mediante *Internet Network Endpoint Groups*).

---

## Conceptos Clave de Operación

### 1. Requisito Indispensable: Balanceador de Carga
Para utilizar Cloud CDN, **es obligatorio asociarlo a un Balanceador de Carga de Aplicación Externo Global** (Global External Application Load Balancer) o un balanceador clásico equivalente. No funciona de forma independiente ni con balanceadores regionales o internos.

### 2. Control de Caché (Cache Control Headers)
Cloud CDN respeta las cabeceras HTTP estándar para determinar si un contenido debe almacenarse en caché y por cuánto tiempo:
- Cabeceras comunes analizadas: `Cache-Control`, `Expires`, `Pragma`.
- También se pueden definir políticas de caché personalizadas directamente en la configuración del balanceador de carga.

### 3. URLs Firmadas (Signed URLs)
Permite restringir el acceso a ciertos contenidos (ej. descargas de pago, vídeos premium). Cloud CDN solo entregará el archivo en caché a los usuarios que presenten una URL con una firma criptográfica válida generada por tu aplicación, garantizando que el contenido seguro se mantenga protegido a nivel de borde.

### 4. Invalidación de Caché (Cache Invalidation)
Si actualizas un archivo (como un logo o un documento) y necesitas que los usuarios vean el cambio de inmediato, puedes realizar una invalidación de caché. Esto elimina de forma instantánea el contenido de todos los servidores perimetrales de Google a nivel mundial, obligando al CDN a pedir la versión actualizada del origen en la siguiente consulta.

---

## Datos Clave

- **Requisito del Balanceador:** Recuerda para el examen que Cloud CDN requiere un **Global External Application Load Balancer** (HTTP/HTTPS) para funcionar.
- **Soporte de Anycast:** Se beneficia de la misma dirección IP Anycast global del balanceador de carga, facilitando que el tráfico llegue al borde óptimo automáticamente.
- **Contenido Dinámico:** Además de archivos estáticos (imágenes, CSS, JS), Cloud CDN puede almacenar en caché respuestas dinámicas configurando de forma adecuada las cabeceras del servidor.
