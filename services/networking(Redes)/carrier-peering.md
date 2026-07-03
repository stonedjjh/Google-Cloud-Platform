# Carrier Peering (Intercambio de Tráfico mediante Proveedor)

Carrier Peering permite a una organización conectar su red empresarial a la red perimetral (Edge Network) de Google a través de un proveedor de servicios de telecomunicaciones asociado (Carrier).

## Características Principales

- **Acceso a Servicios Públicos:** Al igual que Direct Peering, está diseñado exclusivamente para acceder a servicios con endpoints públicos de Google, como **Google Workspace (G Suite)**, APIs de Google Cloud o servicios de GCP públicos.
- **Para Empresas sin Co-ubicación:** Se utiliza cuando la organización no cuenta con infraestructura propia ni routers físicamente instalados en las mismas ubicaciones de colocation de Google.
- **Fuera de la VPC:** **No proporciona acceso privado a los recursos internos de tu VPC**. Las conexiones se realizan utilizando direcciones IP públicas.
- **SLA del Proveedor:** Google no ofrece un Acuerdo de Nivel de Servicio (SLA) para este enlace, pero el proveedor de servicios (Carrier) que contrates suele ofrecer su propio SLA para la conectividad del circuito.

---

## Diferencias con Direct Peering

| Característica | Direct Peering | Carrier Peering |
| :--- | :--- | :--- |
| **Conexión Física** | Directa entre tu router y el de Google. | A través de la red del proveedor (Carrier). |
| **Ubicación** | Debes estar en el mismo datacenter que Google. | Puedes estar en cualquier lugar (el Carrier te conecta). |
| **Requisitos de IP/ASN** | Obligatorio tener ASN propio e IPs públicas. | No es necesario; el Carrier gestiona el enrutamiento. |
| **SLA** | Sin SLA de Google. | Sin SLA de Google (pero sí del Carrier asociado). |

---

## Datos Clave

- **Uso de IPs Públicas:** Recuerda que todo el tráfico intercambiado a través de Carrier Peering utiliza direccionamiento público, por lo que **no sirve para conectar bases de datos privadas** en tu VPC de forma directa.
- **Alternativa Híbrida:** Si tu objetivo es conectar tu oficina a tu VPC privada de GCP mediante un proveedor de servicios, el servicio correcto a contratar no es Carrier Peering, sino **Partner Interconnect**.
- **Infraestructura Simplificada:** Es la mejor opción para organizaciones medianas o grandes que quieren optimizar su tráfico hacia Google Workspace pero no tienen un equipo de red capaz de administrar un peering BGP directo con Google.
