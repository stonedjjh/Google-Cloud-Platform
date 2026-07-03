# Cloud VPN (Virtual Private Network)

Google Cloud VPN conecta de forma segura tu red local (On-Premise) a tu red de Nube Privada Virtual (VPC) a través de una conexión IPsec con cifrado de tráfico, viajando a través de la Internet pública.

## Tipos de Cloud VPN

Google Cloud ofrece dos tipos de puertas de enlace de VPN, siendo la de Alta Disponibilidad la recomendada y el estándar moderno:

### 1. HA VPN (High Availability VPN / VPN de Alta Disponibilidad)
Es la solución de VPN de última generación de Google Cloud, diseñada para cargas de trabajo críticas que exigen cero interrupciones.
- **SLA del 99.99%:** Garantiza una disponibilidad del 99.99% cuando se configura correctamente.
- **Doble Interfaz:** El gateway de HA VPN en GCP se aprovisiona automáticamente con **dos direcciones IP externas públicas** (interfaz 0 e interfaz 1) en hardware físicamente separado.
- **Requisito Obligatorio:** Requiere obligatoriamente el uso de **Enrutamiento Dinámico** mediante **Cloud Router** y el protocolo **BGP (Border Gateway Protocol)**. No admite enrutamiento estático.
- **Túneles Activos:** Debes configurar dos túneles IPsec independientes (uno desde cada interfaz externa de GCP) hacia tu gateway local para cumplir con el SLA del 99.99%.

### 2. Classic VPN (VPN Clásica)
Es la opción legada de Google Cloud.
- **SLA del 99.9%:** Ofrece una menor disponibilidad en comparación con HA VPN.
- **Interfaz Única:** Utiliza una sola dirección IP externa pública en el gateway de GCP.
- **Flexibilidad de Enrutamiento:** Soporta enrutamiento estático (basado en rutas o políticas) y enrutamiento dinámico (con Cloud Router).
- *Nota: Carece de las características de redundancia nativas de HA VPN y se desaconseja para nuevas implementaciones.*

---

## Requisitos de Implementación

Para establecer una conexión exitosa con Cloud VPN se necesita:
- **Puerta de Enlace Local compatible con IPsec:** El dispositivo en tu centro de datos local debe soportar el protocolo IPsec y BGP (en el caso de HA VPN).
- **Clave Compartida (Shared Secret / Pre-shared Key):** Una contraseña criptográfica que debe coincidir en ambos extremos para establecer el túnel cifrado.
- **Sin Solapamiento de IPs:** Las subredes locales de tu centro de datos no pueden superponerse con los rangos CIDR de tu red VPC de GCP.

---

## Datos Clave

- **SLA de HA VPN:** El examen de certificación suele preguntar por el SLA de disponibilidad. Recuerda que para **HA VPN es de 99.99%** y para **Classic VPN es de 99.9%**.
- **Canal de Comunicación:** El tráfico cifrado de Cloud VPN viaja a través de la **Internet pública**. Si necesitas una conexión física privada sin pasar por Internet, el servicio correcto es **Cloud Interconnect**.
- **Enrutamiento Dinámico:** HA VPN te obliga a usar **Cloud Router** para propagar las rutas automáticamente por BGP; no se pueden escribir rutas estáticas manuales en HA VPN.
