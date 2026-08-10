# Cross-Cloud Interconnect (Interconexión Multi-Nube)

Google Cloud aprovisiona una conexión física dedicada directamente entre la red de Google y la red de otro proveedor de servicios en la nube admitido.

*   **Proveedores Admitidos:** Amazon Web Services (AWS), Microsoft Azure, Oracle Cloud Infrastructure (OCI) y Alibaba Cloud.
*   **Caso de uso:** Estrategia integral de múltiples nubes (Multi-Cloud). Permite evitar depender de un solo proveedor (vendor lock-in), almacenar datos en una nube y alojar la lógica empresarial en otra, recuperación ante desastres y transferencias masivas eficaces sin las limitaciones de latencia del Internet público.
*   **Capacidades Típicas:** Opciones de circuitos de alto ancho de banda (10 Gbps o 100 Gbps).

---

## 1. Funcionamiento y Aprovisionamiento

A diferencia de otras interconexiones, con Cross-Cloud Interconnect no tienes que implementar hardware propio ni trabajar con intermediarios o instalaciones de colocación físicas:

1.  Identificas las ubicaciones admitidas donde quieres la conexión.
2.  Compras puertos principales y redundantes de Cross-Cloud Interconnect directamente a Google.
3.  Compras los puertos principales y redundantes correspondientes a tu otro proveedor de nube.
4.  Google aprovisiona físicamente el enlace entre su red y la del otro proveedor. 
5.  Usas la conexión para establecer el intercambio de tráfico (mediante **[Cloud Router](../../vpc/cloud-router.md)**) entre tu red VPC de Google y la red en la otra nube.

> [!WARNING]
> **Límites de Soporte (Regla Crítica):** Google brinda soporte a la conexión **solo hasta el punto en el que alcanza la red del otro proveedor**. Google no garantiza el tiempo de actividad de la otra nube y **no puede crear tickets de asistencia técnica en tu nombre** ante AWS, Azure u OCI.

## 2. Topología para Alta Disponibilidad (99.99% SLA)

Para asegurar la continuidad empresarial y alcanzar el máximo SLA (99.99%) en cargas esenciales, debes usar una configuración idéntica a la de la interconexión dedicada:

*   **4 Conexiones Físicas:** Dos pares de conexiones (total de 4 enlaces).
*   **2 Áreas Metropolitanas:** Cada par debe estar ubicado en un área metropolitana diferente.
*   **2 Dominios de Disponibilidad Perimetral:** Dentro de cada área metropolitana, las dos conexiones de ese par deben conectarse a distintos dominios de disponibilidad (para garantizar que los mantenimientos de Google no desconecten ambos enlaces).

## 3. Seguridad Avanzada: MACsec para Cloud Interconnect

Para requisitos de encriptación de datos sólida, Google ofrece soporte para **MACsec**, el cual encripta el tráfico a nivel de hardware (Capa 2 del modelo OSI):

*   **Alcance de la encriptación:**
    *   *Cross-Cloud Interconnect:* Encripta entre el router perimetral de Google y el router de la nube remota.
    *   *(Como recordatorio)* *Dedicated Interconnect:* Encripta entre el router perimetral de Google y tu router on-premise.
    *   *(Como recordatorio)* *Partner Interconnect:* Encripta entre el router de Google y el router del proveedor asociado.
*   **Limitación de MACsec:** **NO** proporciona encriptación en tránsito una vez que el tráfico entra y viaja *dentro* de la red interna de Google.
*   **Mejor Práctica de Seguridad:** Para lograr seguridad de extremo a extremo, te recomendamos combinar la encriptación de enlace de MACsec con protocolos de capa superior, como **IPsec** o **TLS**.

## 4. Integración con Network Connectivity Center (NCC)

Puedes utilizar Cross-Cloud Interconnect como parte de una estrategia integral de transferencia de datos **sitio a sitio** gracias al **Network Connectivity Center**. Esto te permite usar la inmensa red de fibra óptica global de Google como tu propia red de área extensa (WAN) para transitar tráfico de forma privada entre tus diferentes nubes y centros de datos físicos.
