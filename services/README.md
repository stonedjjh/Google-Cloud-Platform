# 🗂️ GCP Services Index (Índice de Servicios de GCP)

Este directorio contiene apuntes, guías conceptuales y documentación técnica de los diferentes servicios de Google Cloud Platform (GCP), organizados por categorías.

---

## 🌐 General (Conceptos Globales)
* [GCP General Concepts (Conceptos de Google Cloud Platform)](./GCP.md)  
  Detalles sobre la infraestructura global de Google, regiones y zonas, seguridad por diseño y conceptos de computación en la nube (IaaS, PaaS, SaaS).

## 🖥️ Compute (Cómputo)

### 🏗️ IaaS y Orquestación (Administración de Infraestructura)
* [Compute Engine (Máquinas Virtuales)](./compute(Computo)/compute-engine.md)  
  Creación y administración de máquinas virtuales (VMs), tipos de máquinas, discos y escalamiento.
* [GKE - Google Kubernetes Engine (Motor de Kubernetes)](./compute(Computo)/GKE.md)  
  Notas sobre la orquestación, administración y escalado de contenedores en GKE.

### ☁️ Serverless (Sin Servidor - PaaS / FaaS)
* [App Engine (Plataforma para Aplicaciones - PaaS)](./compute(Computo)/app-engine.md)  
  Alojamiento y escalado automático de aplicaciones web en entornos Estándar y Flexible.
* [Cloud Run (Contenedores Serverless - PaaS)](./compute(Computo)/cloud-run.md)  
  Plataforma serverless para ejecutar contenedores y aplicaciones sin gestionar infraestructura.
* [Cloud Run Functions (Funciones sin servidor - FaaS)](./compute(Computo)/cloud-run-functions.md)  
  Servicio FaaS para ejecutar fragmentos de código basados en eventos sin gestionar infraestructura.

### 🛠️ DevOps
* [Cloud Build (CI/CD Serverless)](./compute(Computo)/devops/cloud-build.md)  
  Plataforma para compilar, probar y desplegar software de forma automática.


## 🌐 Networking (Redes)
* [VPC - Virtual Private Cloud (Nube Privada Virtual)](./networking(Redes)/vpc/VPC.md)  
  Estructura de red global en GCP, modos de creación, enrutamiento, VPC Peering y Shared VPC.
* [Subnetworks (Subredes)](./networking(Redes)/vpc/subnetwork.md)  
  Segmentación regional de la red, direccionamiento IP, rangos secundarios y acceso privado.
* [Firewall Rules (Reglas de Firewall)](./networking(Redes)/vpc/firewall-rules.md)  
  Control de tráfico entrante y saliente, prioridades, targets y configuraciones de seguridad.
* [Cloud Router (Enrutador de Nube)](./networking(Redes)/vpc/cloud-router.md)  
  Enrutamiento dinámico mediante intercambio de rutas con BGP para VPN, Interconnect y Cloud NAT.
* [Cloud NAT (Traducción de Direcciones de Red)](./networking(Redes)/vpc/cloud-nat.md)  
  Servicio administrado para dar salida segura a Internet a instancias sin dirección IP pública.
* [Cloud Load Balancing (Balanceadores de Carga)](./networking(Redes)/load-balancing.md)  
  Distribución de tráfico global y regional, balanceadores L4 y L7, y configuraciones de backend.
* [Health Checks - Legacy vs. Global (Verificaciones de Estado)](./networking(Redes)/Health-Checks-Legacy-vs-Global.md)  
  Diferencias entre los tipos de verificaciones de estado heredados y modernos en balanceadores de carga.
* [Cloud DNS (Sistema de Nombres de Dominio)](./networking(Redes)/cloud-dns.md)  
  Zonas públicas y privadas, DNS de horizonte dividido, DNSSEC y resoluciones en entornos híbridos.
* [Cloud CDN (Content Delivery Network)](./networking(Redes)/cloud-cdn.md)  
  Almacenamiento en caché en puntos perimetrales, integración con balanceadores de carga, URLs firmadas e invalidación.
* [Conectividad Híbrida (Conexiones a la VPC)](./networking(Redes)/conectividad/conectividad-hibrida.md)  
  Opciones para conectar redes locales y multi-nube a GCP (VPN, Peering e Interconnect).
* [Cloud VPN (Virtual Private Network)](./networking(Redes)/conectividad/vpn/cloud-vpn.md)  
  Conectividad híbrida cifrada sobre internet, diferencias entre HA VPN (99.99%) y Classic VPN (99.9%).
* [Direct Peering (Intercambio de Tráfico Directo)](./networking(Redes)/conectividad/direct-peering.md)  
  Intercambio de tráfico BGP público y directo con el borde de Google, requisitos y casos de uso.
* [Carrier Peering (Intercambio de Tráfico mediante Proveedor)](./networking(Redes)/conectividad/carrier-peering.md)  
  Conexión indirecta al borde de Google a través de proveedores asociados para servicios públicos.
* [Dedicated Interconnect (Interconexión Dedicada)](./networking(Redes)/conectividad/interconnect/dedicated-interconnect.md)  
  Enlace físico de fibra óptica de alta velocidad (10/100 Gbps) directo a Google Cloud.
* [Partner Interconnect (Interconexión de Socios)](./networking(Redes)/conectividad/interconnect/partner-interconnect.md)  
  Enlace privado a través de un proveedor para anchos de banda flexibles (50 Mbps a 10 Gbps).
* [Cross-Cloud Interconnect (Interconexión Multi-Nube)](./networking(Redes)/conectividad/interconnect/cross-cloud-interconnect.md)  
  Conexiones físicas dedicadas y privadas entre GCP y otras nubes (AWS/Azure).



## 💾 Storage (Almacenamiento)

- **Object Storage** – [Cloud Storage.md](./storage(Almacenamiento)/Objecto/Cloud%20Storage.md)  
  Almacenamiento de objetos y blobs.

- **Cloud SQL** – [Cloud SQL.md](./storage(Almacenamiento)/SQL/Cloud%20SQL.md)  
  Bases de datos relacionales gestionadas.

- **Spanner** – [spanner.md](./storage(Almacenamiento)/SQL/spanner.md)  
  Base de datos SQL horizontalmente escalable.

- **Bigtable** – [bigtable.md](./storage(Almacenamiento)/NOSQL/bigtable.md)  
  Base de datos NoSQL de columnas anchas.

- **Firebase** – [firebase.md](./storage(Almacenamiento)/NOSQL/firebase.md)  
  Bases de datos en tiempo real y Firestore.

## 🔒 Security (Seguridad)
* [IAM - Identity and Access Management (Administración de Accesos)](./security(Seguridad)/IAM.md)  
  Conceptos clave sobre control de accesos, roles básicos/predefinidos/personalizados, cuentas de servicio y Cloud Identity.
* [Service Accounts (Cuentas de Servicio)](./security(Seguridad)/service-accounts.md)  
  Uso de identidades programáticas para aplicaciones, administración de llaves, e impersonación de cuentas.


