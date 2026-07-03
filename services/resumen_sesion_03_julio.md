# Resumen de Sesión de Estudio - 03 de Julio de 2026

Este documento resume todos los temas clave de Google Cloud Platform (GCP) estudiados el día de hoy. Úsalo como contexto para la próxima sesión cuando solicites un cuestionario de repaso (trivia/entrenamiento de examen).

---

## 🔒 1. IAM y Cuentas de Servicio (Service Accounts)
- **Autenticación:** No usan contraseñas tradicionales; se autentican mediante **claves criptográficas RSA** (administradas por Google o por el usuario).
- **Doble Naturaleza:** Actúan como una **identidad** (tienen roles para acceder a recursos) y como un **recurso** (los usuarios pueden recibir permisos como `Service Account User` para actuar en su nombre).
- **Riesgo por Defecto:** Las cuentas predeterminadas de Compute Engine vienen con el rol básico de **Editor** por defecto.
- **Buenas Prácticas:**
  - Evitar su uso en producción (usar cuentas personalizadas de privilegio mínimo).
  - En lugar de eliminarlas, es mejor **deshabilitarlas** o retirarles el rol de Editor.
  - Usar la política de organización `constraints/iam.automaticIamGrantsForDefaultServiceAccounts` para prevenir la asignación automática del rol de Editor en proyectos nuevos.

---

## 🖥️ 2. Computación (Compute Engine)
- **Componentes:**
  - **Machine Types:** Familias predefinidas (E2 para costo, C3 para cómputo, M3 para memoria, A3 para ML con GPU H100) y **Custom Machine Types** (personalización exacta de vCPU/RAM).
  - **Imágenes (S.O.):** Equivalente directo a las **AMIs de AWS**.
  - **Discos:** Persistent Disks (almacenamiento de red, persistente) vs. **Local SSDs** (físicamente conectados, alto IOPS, pero **temporales** - pierden datos al detener la VM).
- **Facturación:** Por segundo, con un cobro mínimo de **1 minuto (60 segundos)**.
- **Descuentos:**
  - **Sustained Use Discounts (SUD):** Automáticos, sin contrato, si la VM corre más del 25% del mes (hasta 30% de descuento).
  - **Committed Use Discounts (CUD):** Por contrato de 1 o 3 años (descuentos de hasta 57% - 70%). Equivalente a las Reserved Instances/Savings Plans de AWS.
- **Spot VMs (Instancias Interrumpibles):**
  - Descuento masivo (60%-91%), pero Google puede interrumpirlas en cualquier momento con aviso previo de **30 segundos**.
  - **Spot vs. Preemptible (Legado):** Las legacy (`--preemptible`) limitaban la ejecución a 24 horas máximo. Las Spot (`--provisioning-model=SPOT`) no tienen límite de ejecución y pueden durar días.
  - **Requisito de Carga:** El software debe ser **tolerante a fallos y sin estado (stateless)**.

---

## 🌐 3. Conceptos de Red VPC (Direccionamiento y Rutas)
- **Matemáticas de IPs en GCP:** Google reserva exactamente **4 direcciones IP por subred** (`.0` red, `.1` default gateway, `.254` futuro/reservado, `.255` broadcast).
- **Límite Mínimo de Subred:** La máscara de subred mínima permitida en GCP es **`/29`** (8 IPs totales - 4 reservadas = **4 IPs usables**).
- **Trampa del Examen:** Para alojar exactamente **5 nodos**, no te alcanza un `/29` (4 usables). Tienes que usar obligatoriamente un **`/28`** (12 usables).
- **Tipos de Rutas:**
  - *System-Generated:* Ruta por defecto (`0.0.0.0/0` al Internet Gateway) y rutas de subred (permiten comunicación interna global nativa entre todas las subredes de una VPC).
  - *Estáticas:* Rutas manuales (ej. para desviar tráfico a un Virtual Appliance/Firewall virtual).
  - *Dinámicas:* Intercambiadas por BGP mediante **Cloud Router**.
- **Dynamic Routing Mode:** *Regional* (Cloud Router solo propaga en su región) vs. *Global* (Cloud Router propaga a toda la VPC a nivel mundial).

---

## 🤝 4. Interconexión entre Redes
- **VPC Peering vs. Shared VPC (Diferencia crítica de examen):**
  - **Shared VPC (Centralizado):** Hay **1 sola red física** en un *Proyecto Host* que comparte subredes con *Proyectos de Servicio*. El control es del administrador de red del Host. Solo se puede usar en la **misma organización**. Sin riesgo de solapamiento (es la misma red).
  - **VPC Peering (Descentralizado):** Conecta **2 redes VPC independientes**. Cada red mantiene sus propios administradores, rutas y firewalls. No es transitivo (`A ➔ B` y `B ➔ C` no conecta `A ➔ C`). No permite solapamiento de IPs. Puede conectar **diferentes organizaciones**.

---

## ⚖️ 5. Balanceo de Carga (Cloud Load Balancing)
- **Arquitectura:** Es un servicio definido por software (SDN), completamente administrado y distribuido. No corre en VMs del usuario, por lo que no hay que preocuparse por su mantenimiento o escalado.
- **Failover automático:** Utiliza una **IP Anycast global única** que redirige el tráfico al backend sano más cercano y hace failover automático multirregional en fracciones de segundo si falla una región.
- **Clasificaciones:**
  - **Application Load Balancers (L7 - Capa de aplicación):** Actúan como **Proxys inversos** (terminan la conexión TCP del cliente y abren una nueva al backend). Especializados en HTTP/HTTPS. Pueden ser externos o internos, globales o regionales.
  - **Network Load Balancers (L4 - Capa de transporte):** Especializados en TCP/UDP/SSL. Se dividen en:
    - *Proxy:* Termina la conexión TCP del cliente (soportan cobertura global/regional).
    - *Passthrough (Paso Directo):* Envía el paquete intacto al backend (la VM ve la IP real del cliente nativamente). **Es estrictamente Regional**.

---

## 🌍 6. Servicios de Entrega de Contenido y Nombres (DNS / CDN)
- **Cloud DNS:**
  - Zonas públicas (internet) y zonas privadas (internas VPC).
  - Soporte de **DNSSEC** contra cache poisoning.
  - **Split-Horizon DNS:** Mismo dominio (ej. `app.com`) resuelve a una IP pública en internet y a una IP privada dentro de la VPC.
  - **DNS Forwarding:** *Inbound* (servidor local consulta a GCP) y *Outbound* (GCP consulta a servidor local) para entornos híbridos.
  - **DNS Peering:** Compartir zonas DNS privadas entre VPCs.
- **Cloud CDN:**
  - Almacena en caché contenido estático/dinámico en los puntos perimetrales de Google.
  - **Requisito Obligatorio:** Requiere obligatoriamente un **Global External Application Load Balancer**.
  - Características: URLs Firmadas (acceso premium restringido) e Invalidación de Caché (limpieza instantánea de archivos obsoletos).

---

## 🔌 7. Conectividad Híbrida y Cloud Router
- **Cloud Router:**
  - **Solo plano de control (Control Plane):** No procesa el tráfico de datos real (si se cae por mantenimiento, el tráfico sigue fluyendo).
  - Utiliza **BGP** para el intercambio de rutas. Requiere configurar un **ASN privado**.
  - Requerido para HA VPN, Cloud Interconnect y Cloud NAT.
- **Cloud VPN:**
  - Cifra el tráfico de forma segura viajando a través de la **Internet pública**.
  - **HA VPN (99.99% SLA):** Dos interfaces con IPs públicas activas en GCP, requiere BGP dinámico (Cloud Router) y dos túneles IPsec activos obligatorios.
  - **Classic VPN (99.9% SLA):** Una sola IP externa, admite enrutamiento estático o dinámico. Obsoleto para nuevos diseños.
- **Opciones de Conexión Física (Híbrida):**
  - **Direct Peering:** Conexión pública BGP en un colocation de Google. **Fuera de la VPC** (solo para Workspace, APIs públicas). Sin SLA de Google. Requiere ASN propio e IPs públicas.
  - **Carrier Peering:** Igual que Direct Peering pero a través de la infraestructura de un proveedor (Carrier) porque tú no estás en el colocation de Google.
  - **Dedicated Interconnect:** Enlace físico privado dedicado (fibra de 10G/100G). No pasa por internet. SLA del 99.99%.
  - **Partner Interconnect:** Enlace físico privado a través de un partner para menores anchos de banda (50 Mbps a 10 Gbps). SLA del 99.99%.
  - **Cross-Cloud Interconnect:** Conexión física privada directa de GCP a AWS/Azure.
