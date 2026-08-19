# Cloud VPN (Virtual Private Network)

Google Cloud VPN conecta de forma segura tu red local (On-Premise) a tu red de Nube Privada Virtual (VPC) a través de una conexión IPsec. El tráfico se encripta por una puerta de enlace de VPN y se desencripta en la otra, protegiendo tus datos mientras viajan por la Internet pública.

> [!TIP]
> **¿Cuándo usar Cloud VPN en lugar de Interconnect?**
> Cloud VPN es **más económica y sencilla de configurar**. Es la opción ideal cuando tienes un **volumen bajo de datos (bajo ancho de banda)**, cuando tu infraestructura de red no admite conexiones de fibra exclusivas, o cuando simplemente prefieres el menor costo de un túnel IPsec sobre Internet frente al alto rendimiento de Cloud Interconnect.

## Tipos de Cloud VPN

Google Cloud ofrece dos tipos de puertas de enlace de VPN, siendo la de Alta Disponibilidad la recomendada para enrutamiento dinámico y mayor confiabilidad:

### 1. HA VPN (High Availability VPN / VPN de Alta Disponibilidad)
Es la solución de VPN de última generación de Google Cloud, diseñada para cargas de trabajo críticas que exigen redundancia, conmutación por error (failover) automática y mejor rendimiento.
- **SLA del 99.99%:** Garantiza una alta disponibilidad cuando se configura correctamente con dos túneles.
- **Doble Interfaz:** El gateway de HA VPN en GCP se aprovisiona automáticamente con **dos direcciones IP externas públicas** (interfaz 0 e interfaz 1) en hardware físicamente separado.
- **Requisito Obligatorio (BGP):** Requiere obligatoriamente el uso de **Enrutamiento Dinámico** mediante **Cloud Router** y el protocolo **BGP (Border Gateway Protocol)**. No admite enrutamiento estático.

### 2. Classic VPN (VPN Clásica)
Es la opción legada de Google Cloud, útil solo para casos de uso específicos.
- **SLA del 99.9%:** Ofrece una menor disponibilidad en comparación con HA VPN.
- **Interfaz Única:** Utiliza una sola dirección IP externa pública en el gateway de GCP.
- **Enrutamiento Estático:** Es la opción a elegir si dependes de enrutamiento estático (basado en rutas o políticas), aunque también soporta dinámico.
- *Nota: Carece de las características de redundancia nativas de HA VPN y se desaconseja para arquitecturas nuevas de alta criticidad.*

---

## Requisitos de Implementación

Para establecer una conexión exitosa con Cloud VPN se necesita:
- **Puerta de Enlace Local compatible con IPsec:** El dispositivo en tu centro de datos local debe soportar el protocolo IPsec y BGP (en el caso de HA VPN).
- **Clave Compartida (Shared Secret / Pre-shared Key):** Una contraseña criptográfica que debe coincidir en ambos extremos para establecer el túnel cifrado.
- **Sin Solapamiento de IPs:** Las subredes locales de tu centro de datos no pueden superponerse con los rangos CIDR de tu red VPC de GCP.

---

## Datos Clave y Notas de Examen

- **VPN vs VPC Peering (Anuncio de Rutas):** Con Cloud VPN (y BGP) puedes anunciar rutas de forma **selectiva** entre redes VPC. En contraste, cuando estableces un VPC Peering, por diseño se anuncian *todas* las rutas de las subredes de ambas redes conectadas.
- **SLA de Disponibilidad:** El examen de certificación suele preguntar por el SLA. Recuerda que para **HA VPN es de 99.99%** y para **Classic VPN es de 99.9%**.
- **Canal de Comunicación:** El tráfico cifrado de Cloud VPN viaja a través de la **Internet pública**. Si necesitas una conexión física dedicada sin pasar por Internet por motivos normativos o de latencia, el servicio correcto es **Cloud Interconnect**.
- **Enrutamiento Dinámico en HA VPN:** HA VPN te obliga a usar **Cloud Router** para propagar las rutas automáticamente por BGP; no se pueden escribir rutas estáticas manuales.
