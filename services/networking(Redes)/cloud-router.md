# Cloud Router

Google Cloud Router es un servicio de conectividad de red totalmente administrado y basado en software. Utiliza el protocolo **BGP (Border Gateway Protocol)** para intercambiar rutas dinámicamente entre tu red VPC de Google Cloud y redes externas (como tu centro de datos local o redes en otras nubes).

## ¿Cómo Funciona? (El Concepto Clave)

- **Solo Plano de Control (Control Plane Only):** Una de las preguntas más frecuentes del examen es entender que Cloud Router **no maneja el tráfico de datos real (data plane)**. Es decir, las películas, archivos o peticiones HTTP de tus usuarios no pasan físicamente a través de Cloud Router.
- **Propagador de Direcciones:** Su única función es intercambiar información de enrutamiento (las rutas). Le dice a tu router local qué IPs existen en GCP y viceversa. Una vez que las rutas son aprendidas, el tráfico real viaja directamente por la red física de Google (VPC, VPN o Interconnect) sin pasar por el router de nube.
- **Alta Disponibilidad de Rutas:** Si Cloud Router llega a reiniciarse o fallar momentáneamente por mantenimiento de Google, **el tráfico de datos no se detiene**, ya que las tablas de enrutamiento de la VPC se mantienen activas.

---

## Características y Parámetros Principales

### 1. Número de Sistema Autónomo (ASN - Autonomous System Number)
Para configurar las sesiones BGP, Cloud Router requiere un identificador ASN:
- Se utilizan números de **ASN privados** definidos por la IANA (típicamente del rango `64512` al `65534`, o del `4200000000` al `4294967294`).
- Debes configurar un ASN para el Cloud Router de GCP y otro ASN diferente para tu router local On-Premise.

### 2. Rutas Anunciadas Personalizadas (Custom Advertised Routes)
Por defecto, Cloud Router anuncia automáticamente todas las subredes de tu VPC a tu red local. Sin embargo, puedes personalizar este comportamiento para:
- Ocultar ciertas subredes de producción para que no sean visibles desde la oficina local.
- Anunciar rangos de IP personalizados (como prefijos que representen a toda la VPC de forma agrupada) para optimizar las tablas del router local.

### 3. Integración con Cloud NAT
Cloud NAT es el servicio que permite a VMs sin IP pública salir a Internet de forma segura.
- Cloud NAT no utiliza máquinas virtuales virtuales.
- En su lugar, requiere asociarse a un **Cloud Router** para que este actúe como el motor y gestor de enrutamiento que asigna las IPs de NAT a los recursos correspondientes.

---

## Datos Clave

- **No procesa Datos:** Recuerda que Cloud Router **solo maneja el plano de control (rutas)** y no el plano de datos (tráfico).
- **Protocolo Utilizado:** El único protocolo de enrutamiento dinámico que soporta es **BGP**.
- **Asociación Regional:** Cloud Router es un recurso **regional** (se crea en una región específica). Sin embargo, si configuras el *Dynamic Routing Mode* de la VPC en **Global**, ese Cloud Router regional podrá propagar rutas a todas las subredes de la VPC a nivel mundial.
- **Servicios que lo requieren:** Es obligatorio para **HA VPN**, **Cloud Interconnect** y **Cloud NAT**.
