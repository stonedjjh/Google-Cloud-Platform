# Cloud DNS

Google Cloud DNS es un servicio de Sistema de Nombres de Dominio (DNS) global, administrado, altamente disponible y de baja latencia que traduce nombres de dominio (como `ejemplo.com`) en direcciones IP.

## Características Principales

- **Servicio Global de Alta Disponibilidad:** Cloud DNS utiliza la red global de servidores Anycast de Google para responder a las consultas DNS desde la ubicación más cercana, ofreciendo un 100% de disponibilidad de SLA para su resolución autoritativa pública.
- **Zonas DNS:**
  - **Zonas Públicas (Public Zones):** Son visibles en la Internet pública. Se utilizan para publicar tus sitios web y servicios hacia todo el mundo.
  - **Zonas Privadas (Private Zones):** Solo son visibles dentro de las redes VPC que especifiques. Te permiten asignar nombres lógicos internos (ej. `base-datos.interna.local`) a tus recursos sin exponer esas IPs o nombres a Internet.
- **DNSSEC (DNS Security Extensions):** Protege tus dominios de ataques como la falsificación de DNS (DNS spoofing) y el envenenamiento de caché mediante firmas criptográficas en las respuestas DNS.

---

## Funcionalidades Avanzadas de Redes

### 1. Split-Horizon DNS (DNS de Horizonte Dividido)
Permite configurar una zona pública y una zona privada utilizando el **mismo nombre de dominio** (ej. `app.miempresa.com`), pero resolviendo a diferentes direcciones IP según de dónde provenga la consulta:
- Si la consulta viene desde Internet (pública), resuelve a la IP externa del balanceador de carga.
- Si la consulta viene desde dentro de la VPC (privada), resuelve a la IP interna de la VM de base de datos.

### 2. Reenvío de DNS (DNS Forwarding)
Permite la integración híbrida entre tu centro de datos local (On-Premise) y tu VPC de Google Cloud:
- **Inbound Forwarding (Reenvío de Entrada):** Permite que tus servidores On-Premise envíen consultas a Cloud DNS para resolver nombres de recursos internos en la nube.
- **Outbound Forwarding (Reenvío de Salida):** Permite que tus VMs en la VPC envíen consultas a tus servidores de DNS locales para resolver nombres de dominios privados locales.

### 3. DNS Peering (Intercambio de DNS)
Permite que una red VPC comparta su zona DNS privada con otra red VPC. De esta manera, los recursos de ambas VPCs pueden resolver los mismos nombres internos sin necesidad de duplicar registros o usar reenvíos complejos.

---

## Datos Clave

- **SLA del 100%:** Google Cloud DNS ofrece un acuerdo de nivel de servicio del 100% para la resolución de nombres públicos, garantizando que el servicio de DNS autoritativo nunca fallará gracias a su infraestructura global.
- **Asociación de Zonas Privadas:** Las zonas DNS privadas no son globales en su visibilidad; están estrictamente limitadas a las redes VPC que autorices explícitamente en su configuración.
- **Tipos de Registros Soportados:** Soporta todos los registros estándar de la industria, incluyendo A, AAAA, CNAME, MX, TXT, SRV, PTR, CAA y NS.
