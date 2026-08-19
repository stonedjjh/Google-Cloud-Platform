# Partner Interconnect (Interconexión de Socios)

Conexión física privada a Google Cloud a través de un proveedor de servicios local asociado (partner). 

*   **Caso de uso:** Tu centro de datos está muy lejos o fuera del alcance de una instalación de colocación de interconexión dedicada, pero necesitas una conexión privada, segura, de baja latencia y aislada del Internet público. Utiliza la infraestructura subyacente de un tercero (proveedor de servicios) para conectarte a Google Cloud.
*   **Ancho de banda:** Ideal para requerimientos entre **50 Mbps y 50 Gbps**. *(Nota de examen: Si requieres menos de 50 Mbps, considera usar Cloud VPN)*.
*   **SLA y Paridad Técnica:** Tiene paridad técnica con Dedicated Interconnect y puede alcanzar SLAs del 99.99%. Su gran ventaja es el **rápido aprovisionamiento**, ya que la configuración e infraestructura física inicial ya existe del lado del proveedor.

---

## 1. Tipos de Conexión y BGP (Capa 2 vs Capa 3)

Al depender de un proveedor de servicios, el comportamiento de la red varía en función del servicio que te entregue:

### Conexiones de Capa 2 (Layer 2)
El proveedor de servicios actúa esencialmente como una extensión física (un conducto transparente) de tu red.
*   Debes configurar y establecer la **sesión BGP directamente entre tus routers locales y el [Cloud Router](../../vpc/cloud-router.md)** en la red de VPC de Google.
*   Al crear el adjunto de VLAN (VLAN Attachment), Google te proporciona automáticamente un ID de VLAN y direcciones IP de intercambio de tráfico de BGP que usarás para configurar tu equipo on-premise.

### Conexiones de Capa 3 (Layer 3)
El proveedor de servicios se encarga activamente de enrutar el tráfico hacia su destino.
*   Tu proveedor **establece la sesión BGP entre sus routers y tu [Cloud Router](../../vpc/cloud-router.md)** para cada adjunto de VLAN.
*   **Diferencia Crítica:** NO necesitas configurar BGP hacia Google en tu router local. Google y el proveedor lo hacen automáticamente. Dependiendo del proveedor, solo te pedirán una ruta estática predeterminada hacia su red o una sesión BGP básica directamente con ellos.

## 2. Redundancia

Para lograr la redundancia y protegerse ante eventos de mantenimiento, debes colocar tu Partner Interconnect en múltiples **dominios de disponibilidad perimetral** e implementar **dos Cloud Routers en distintas regiones**, asegurando disponibilidad ante cortes regionales completos (mismo principio que en Dedicated Interconnect).

## 3. Proceso de Aprovisionamiento (Pairing Key)

En Partner Interconnect, en lugar de solicitar cableado físico con una LOA-CFA, el aprovisionamiento es lógico y más rápido:

1.  **Solicitud al Proveedor:** Contactas y solicitas la conexión desde un proveedor de servicios admitido.
2.  **Generación de Llave:** Creas un adjunto de VLAN en Google Cloud. Esta acción genera una **Clave de Vinculación (Pairing Key)** única que identifica a tu Cloud Router.
3.  **Vinculación:** Envías la Pairing Key, la capacidad requerida y tu ubicación al proveedor.
4.  **Configuración:** El proveedor usa esta clave para configurar su extremo y conectarse al adjunto de VLAN. Se te notificará (vía correo) cuando esto esté completo.
5.  **Activación:** Activas la conexión en el adjunto de VLAN dentro de la consola de Google Cloud para que comience a pasar el tráfico.
6.  **Configurar BGP:** Si estás en Capa 2, estableces la sesión BGP en tus routers locales. Si es Capa 3, ya debería estar enrutando de forma automatizada por el proveedor.
