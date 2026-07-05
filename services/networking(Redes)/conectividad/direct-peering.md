# Direct Peering (Intercambio de Tráfico Directo)

Direct Peering permite a una organización establecer una conexión de enrutamiento directa entre su red empresarial y la red perimetral (Edge Network) de Google en un punto de presencia (PoP) de Google, utilizando el protocolo BGP.

## Características Principales

- **Acceso a Servicios Públicos de Google:** Está diseñado principalmente para acceder de forma rápida y eficiente a servicios públicos de Google, como **Google Workspace (G Suite)**, APIs de Google Cloud públicas, YouTube y servicios de Google Cloud Platform que tengan endpoints públicos.
- **Conexión Fuera de la VPC:** A diferencia de Cloud Interconnect o Cloud VPN, **Direct Peering no se conecta directamente al espacio privado de tu red VPC**. El intercambio se realiza utilizando direcciones IP públicas.
- **Sin Garantía de SLA:** Google **no ofrece un Acuerdo de Nivel de Servicio (SLA)** para Direct Peering. La estabilidad de la conexión recae en el diseño de enlaces redundantes que configure la propia organización.
- **Requisitos Físicos:** La organización debe tener presencia física en la misma instalación de colocation (punto de intercambio de tráfico) donde se encuentra el Edge de Google.

---

## Requisitos de Google para Direct Peering

Google tiene requisitos estrictos para permitir Direct Peering con una empresa:
1. **Presencia en un Punto de Intercambio:** Debes estar presente en una de las ubicaciones donde Google hace peering (peering locations).
2. **Número de Sistema Autónomo (ASN):** Debes poseer un ASN público registrado.
3. **Direcciones IP Públicas:** Debes tener tus propios bloques de direcciones IP públicas registrados en un RIR (como LACNIC, ARIN, RIPE, etc.) para anunciarlas a Google mediante BGP.
4. **Centro de Operaciones de Red (NOC):** Debes contar con un NOC disponible 24/7.

---

## Datos Clave

- **No entra a la VPC:** Direct Peering no permite que tus redes locales se comuniquen de forma privada con los recursos internos de tu VPC (como VMs con IP privada) sin pasar por configuraciones adicionales (como NAT o balanceadores externos).
- **Sin Costo de Puerto:** Google no cobra una tarifa mensual por el uso de puertos para Direct Peering, pero sí se aplican los costos de infraestructura del data center o colocation.
- **Equivalencia con Carrier Peering:** Si no cumples con los exigentes requisitos de Google o no estás en una de sus ubicaciones de borde, el servicio equivalente a utilizar es **Carrier Peering** (donde un proveedor de internet asociado hace de puente entre tu red y el Edge de Google).
