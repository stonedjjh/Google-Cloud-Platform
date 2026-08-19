# Dedicated Interconnect (Interconexión Dedicada)

Conexión física directa mediante un cable de fibra óptica dedicado entre tu red local y la red perimetral de Google (instalación de colocación).

*   **Caso de uso:** Cargas de trabajo fundamentales que requieren transferencia masiva de datos con el nivel más alto de rendimiento y confiabilidad, y la latencia y *jitter* más bajos posibles. Es ideal cuando el Internet público o una VPN no son suficientes debido a la sobrecarga de la encriptación y falta de rendimiento garantizado. Permite habilitar aislamiento estricto del Internet público y encriptación sólida.
*   **SLA:** Hasta 99.99 % de disponibilidad (requiere topología redundante).
*   **Requisitos:** Espacio en un colocation de Google y fibra propia.

---

## 1. Funcionamiento (VLAN y BGP)

La interconexión dedicada utiliza **[Cloud Router](../../vpc/cloud-router.md)** para establecer un intercambio de rutas bidireccional mediante el protocolo BGP:
1.  Se crea un **adjunto de VLAN (VLAN Attachment)** que se asocia a un Cloud Router en Google Cloud.
2.  El Cloud Router inicia una sesión de BGP con el router local (on-premise) del cliente.
3.  A través de esta sesión, las rutas anunciadas por el router local se integran en la red VPC como rutas dinámicas personalizadas.
4.  Al mismo tiempo, el Cloud Router anuncia las rutas de los recursos de Google Cloud hacia el router local.

## 2. Topología para Alta Disponibilidad (99.99% SLA)

Para asegurar la máxima redundancia y protegerse ante mantenimientos o caídas regionales, se debe implementar la siguiente topología estricta:

*   **4 Conexiones Físicas:** Se deben crear al menos 4 conexiones Interconnect distribuidas en pares.
*   **2 Áreas Metropolitanas y Dominios de Disponibilidad:** Los dos pares de conexiones deben estar en dos áreas metropolitanas distintas. Dentro de cada área, las conexiones deben situarse en **dominios de disponibilidad perimetral** distintos. 
    > [!NOTE] 
    > Los dominios proporcionan aislamiento durante mantenimientos programados. Tener conexiones en distintos dominios garantiza que ambas no estarán inactivas al mismo tiempo por mantenimiento. (A estas zonas también se les llama *nombre de ubicación de interconexión* en la documentación).
*   **Routers en Múltiples Regiones:** Se deben implementar un mínimo de **dos Cloud Routers en al menos dos regiones distintas** de Google Cloud. Cada región aloja su propio Cloud Router manteniendo sesiones BGP independientes.
    > [!TIP]
    > **Regla Crítica:** Esto es obligatorio incluso si todas tus máquinas virtuales están en una sola región. Si ocurre una interrupción masiva en una región completa, Google Cloud puede redireccionar el tráfico a través de la región no afectada para asegurar el acceso continuo.

## 3. Proceso de Aprovisionamiento (LOA-CFA)

Crear una Interconexión Dedicada implica coordinación física en el centro de datos:

1.  **Solicitud:** Solicitas la conexión desde la consola de Google Cloud.
2.  **Generación de LOA-CFA:** Google te envía una **Carta de Autorización y Asignación de Instalación de Conexión (LOA-CFA)**. Este documento especifica los puertos asignados y da permiso legal para que el proveedor se conecte a ellos.
3.  **Cross-Connect:** Envías la LOA-CFA al centro de colocación para que realicen el cableado físico. El proveedor te avisa al terminar.
4.  **Pruebas de Conexión Automáticas:** Google envía configuraciones IP para realizar 2 pruebas:
    *   Prueba de **niveles de luz** de cada circuito de fibra.
    *   Prueba de **conectividad IP** final de cada conexión.
5.  **Activación de BGP:** Una vez superadas las pruebas, creas los adjuntos de VLAN y configuras tus routers locales para establecer BGP usando el ID de VLAN, la IP de interfaz y la IP de intercambio proporcionadas.

## 4. Ancho de Banda y Capacidad

El ancho de banda se reserva mediante "circuitos". No es posible tener circuitos de 10 Gbps y 100 Gbps combinados dentro de una misma conexión.

*   **Capacidades de los Circuitos:** 10 Gbps o 100 Gbps.
*   **Límites por Conexión:**
    *   Hasta **8 circuitos** si son de 10 Gbps (Capacidad máxima: 80 Gbps).
    *   Hasta **2 circuitos** si son de 100 Gbps (Capacidad máxima: 200 Gbps).
