# Conectividad Híbrida (Conexión de Redes a la VPC)

Google Cloud ofrece múltiples opciones para conectar tus redes locales (On-Premise), oficinas u otras nubes públicas a tu red Nube Privada Virtual (VPC). Estas opciones varían según los requisitos de seguridad, rendimiento, costo y ancho de banda.

A continuación se muestra la clasificación de las opciones de conectividad externa a la VPC:

```mermaid
graph LR
    A["Cloud VPN"]
    B["Direct Peering"]
    C["Carrier Peering"]
    D["Dedicated Interconnect"]
    E["Partner Interconnect"]
    F["Cross-Cloud Interconnect"]

    A ~~~ B ~~~ C ~~~ D ~~~ E ~~~ F

    style A fill:#4285F4,color:#fff
    style B fill:#EA4335,color:#fff
    style C fill:#FBBC05,color:#333
    style D fill:#34A853,color:#fff
    style E fill:#4285F4,color:#fff
    style F fill:#EA4335,color:#fff
```

---

## Opciones de Conectividad

### 1. [Cloud VPN](./vpn/cloud-vpn.md)
Conexión segura y cifrada a través de la **Internet pública** utilizando túneles IPsec.
- **Caso de uso:** Ideal para conexiones iniciales, entornos de desarrollo/pruebas o anchos de banda bajos/moderados (hasta 3 Gbps por túnel).
- **Ventaja:** Despliegue rápido y bajo costo.

### 2. [Direct Peering](./direct-peering.md) (Intercambio de Tráfico Directo)
Conecta tu red local directamente con los puntos de presencia perimetrales (Edge Points of Presence) de Google.
- **Caso de uso:** Ideal para empresas que consumen masivamente servicios de Google Workspace o APIs públicas de Google Cloud y ya cuentan con red propia en un colocation de Google.
- **Nota:** No corre dentro de una VPC y no ofrece garantías de SLA.

### 3. [Carrier Peering](./carrier-peering.md) (Intercambio de Tráfico mediante Proveedor)
Similar a Direct Peering, pero la conexión a la red perimetral de Google se realiza a través de un proveedor de servicios de telecomunicaciones asociado (Carrier).
- **Caso de uso:** Cuando tu empresa no tiene presencia física en un punto de intercambio de tráfico de Google, pero tu proveedor de internet sí.

### 4. [Dedicated Interconnect](./interconnect/dedicated-interconnect.md) (Interconexión Dedicada)
Conexión física directa mediante un cable de fibra óptica dedicado entre tu red local y la red perimetral de Google.
- **Caso de uso:** Empresas con demandas masivas de transferencia de datos con velocidades de **10 Gbps o 100 Gbps** por enlace.
- **SLA:** Ofrece hasta un 99.99% de disponibilidad (requiere topologías redundantes).
- **Tránsito:** Es un enlace físico privado y exclusivo que **no pasa por la Internet pública**.

### 5. [Partner Interconnect](./interconnect/partner-interconnect.md) (Interconexión de Socios)
Conexión física privada a Google Cloud a través de un proveedor de servicios local asociado (partner).
- **Caso de uso:** Cargas de trabajo críticas que necesitan una conexión privada pero no requieren los anchos de banda masivos de 10 Gbps (admite capacidades de **50 Mbps a 10 Gbps**).
- **SLA:** Ofrece hasta un 99.99% de disponibilidad.

### 6. [Cross-Cloud Interconnect](./interconnect/cross-cloud-interconnect.md) (Interconexión Multi-Nube)
Establece conexiones físicas directas y privadas desde Google Cloud hacia otras nubes públicas como AWS o Azure.
- **Caso de uso:** Arquitecturas multi-nube críticas que transfieren grandes cantidades de datos entre proveedores de nube pública de forma privada y sin pasar por Internet.

---

| Característica | Destino | ¿Pasa por la Internet pública? | ¿Quién pone el enlace físico? | Ancho de banda disponible | ¿Ofrece SLA de Google? | Requisitos técnicos clave |
|---|---|---|---|---|---|---|
| Dedicated Interconnect | Interno: A tus VPCs privadas (Rangos RFC 1918) | No. Es un cable físico dedicado. | Tú llevas tu fibra a un centro de datos de Google (Colocation). | Enorme: 10‑100 Gbps. | Sí, hasta 99.99 % (con topología correcta). | Requiere espacio en un Colocation de Google. |
| Partner Interconnect | Interno: A tus VPCs privadas (Rangos RFC 1918) | No. Es un canal privado a través de un socio. | Un socio autorizado (ej. Equinix, AT&T) ya conectado a Google. | Flexible: 50 Mbps‑10 Gbps. | Sí, hasta 99.99 % (con topología correcta). | No requiere infraestructura física propia en el Colocation. |
| Cross-Cloud Interconnect | Interno: A tus VPCs privadas (Rangos RFC 1918) | No. Es un cable físico directo entre nubes. | Google tira el cable directo al centro de datos de otra nube (AWS/Azure). | Enorme: 10‑100 Gbps. | Sí, hasta 99.99 % (con topología correcta). | Las cargas de trabajo deben estar en nubes soportadas (AWS, Azure, OCI). |
| Direct Peering | Público: A Google Workspace, APIs públicas de GCP, YouTube | No. Es una conexión BGP directa en un punto de intercambio. | Tú te conectas directamente en un Punto de Presencia (PoP) de Google. | Variable: depende del contrato con el Carrier. | No. Google no da SLA para Peering. | Requiere ASN propio, IPs públicas registradas y presencia en su PoP. |
| Carrier Peering | Público: A Google Workspace, APIs públicas de GCP, YouTube | No. Es a través de la red privada de un proveedor (Carrier). | Un proveedor de internet (Carrier) hace el puente por ti. | Variable: depende del contrato con el Carrier. | No. Google no da SLA (el contrato es con tu Carrier). | No necesitas ASN propio ni IPs públicas; el Carrier te los gestiona. |

---



---

## Datos Clave

- **¿Pasa por Internet?** 
  - **Sí:** [Cloud VPN](./vpn/cloud-vpn.md) viaja encriptado sobre la Internet pública.
  - **No:** Dedicated Interconnect, Partner Interconnect y Cross-Cloud Interconnect son **enlaces físicos privados y dedicados**.
- **Requisito de Cloud Router:** Tanto para **HA VPN** como para **Cloud Interconnect** (Dedicated, Partner y Cross-Cloud), es estrictamente obligatorio el uso de [Cloud Router](../vpc/cloud-router.md) para gestionar el intercambio dinámico de rutas BGP.
- **¿Cuál elegir?** 
  - Si el volumen de datos es bajo/medio y el costo es un factor limitante: [Cloud VPN](./vpn/cloud-vpn.md).
  - Si requieres alto rendimiento y tu red física coincide con un colocation de Google: **Dedicated Interconnect**.
  - Si requieres conexión privada dedicada pero menor ancho de banda (ej: 200 Mbps): **Partner Interconnect**.
