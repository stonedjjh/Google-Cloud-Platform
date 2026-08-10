# Network Connectivity Center (NCC)

A medida que las empresas se expanden a nivel global, gestionar múltiples conexiones de red (VPCs, VPNs, Interconnects, routers de terceros) puede volverse una malla caótica y difícil de mantener con configuraciones manuales en cada región.

**Network Connectivity Center (NCC)** es la solución a este problema: funciona como un **concentrador (hub) centralizado** para administrar y escalar todas las conexiones de red de Google Cloud desde un único lugar.

## Beneficios Principales

- **Administración Simplificada:** Elimina la complejidad de los procesos manuales descentralizados, centralizando la gestión de topologías de red complejas (Hub-and-Spoke).
- **Visibilidad y Monitoreo:** Ofrece visibilidad integral (de extremo a extremo) del tráfico de red y métricas de rendimiento, lo que facilita enormemente la identificación y resolución de problemas (*troubleshooting*).
- **Escalabilidad:** Te permite agregar sin inconvenientes nuevas conexiones de VPC a medida que tu red o negocio crece, manteniendo la topología sólida.

---

## Casos de Uso y Funcionalidades Clave

### 1. Conexión Global de Redes VPC
Si tienes redes VPC distribuidas en varias regiones de Google Cloud, NCC te permite usar su modelo de "concentrador" para unir todas estas VPCs fácilmente y facilitar la expansión global.

### 2. Transferencia de Datos Sitio a Sitio (Data Transfer)
Esta es una de las funciones de red más poderosas de Google. NCC te permite conectar dos o más sitios externos (por ejemplo, tu centro de datos en Nueva York y tu oficina en Tokio) a Google Cloud mediante VPN o Interconnect, y **usar la red de fibra óptica global de Google como tu propia WAN (Wide Area Network)** para que esos sitios se comuniquen entre sí, reduciendo drásticamente la latencia.

### 3. Integración de Dispositivos de Red de Terceros (Router Appliances)
NCC te permite integrar dispositivos virtuales de red (NVA - Network Virtual Appliances, como firewalls o routers Cisco, Palo Alto, Fortinet) directamente en el centro de tu red. Puedes usar estos dispositivos para enrutar el tráfico entre sitios externos, o incluso para inspeccionar el tráfico entre tus propias redes VPC.

### 4. Gestión Centralizada de Parámetros Multisitio
NCC facilita la administración central de configuraciones de enrutamiento y políticas entre todos tus sitios locales externos (On-Prem) y la infraestructura de Google Cloud.
