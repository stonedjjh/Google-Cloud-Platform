# 🗂️ GCP Services Index (Índice de Servicios de GCP)

Este directorio contiene apuntes, guías conceptuales y documentación técnica de los diferentes servicios de Google Cloud Platform (GCP), organizados por categorías.

---

## 🌐 General (Conceptos Globales)
* [GCP General Concepts (Conceptos de Google Cloud Platform)](./GCP.md)  
  Detalles sobre la infraestructura global de Google, regiones y zonas, seguridad por diseño y conceptos de computación en la nube (IaaS, PaaS, SaaS).

## 🖥️ Compute (Cómputo)
* [Compute Engine (Máquinas Virtuales)](./compute(Computo)/compute-engine.md)  
  Creación y administración de máquinas virtuales (VMs), tipos de máquinas, discos y escalamiento.
* [GKE - Google Kubernetes Engine (Motor de Kubernetes de Google)](./compute(Computo)/GKE.md)  
  Notas sobre la orquestación, administración y escalado de contenedores en GKE.


## 🌐 Networking (Redes)
* [VPC - Virtual Private Cloud (Nube Privada Virtual)](./networking(Redes)/VPC.md)  
  Estructura de red en GCP, subredes regionales, firewalls y enrutamiento.
* [Subnetworks (Subredes)](./networking(Redes)/subnetwork.md)  
  Segmentación regional de la red, direccionamiento IP, rangos secundarios y acceso privado.
* [Firewall Rules (Reglas de Firewall)](./networking(Redes)/firewall-rules.md)  
  Control de tráfico entrante y saliente, prioridades, targets y configuraciones de seguridad.
* [Cloud Load Balancing (Balanceadores de Carga)](./networking(Redes)/load-balancing.md)  
  Distribución de tráfico global y regional, balanceadores L4 y L7, y configuraciones de backend.
* [Health Checks - Legacy vs. Global (Verificaciones de Estado)](./networking(Redes)/Health-Checks-Legacy-vs-Global.md)  
  Diferencias entre los tipos de verificaciones de estado heredados y modernos en balanceadores de carga.
* [Cloud DNS (Sistema de Nombres de Dominio)](./networking(Redes)/cloud-dns.md)  
  Zonas públicas y privadas, DNS de horizonte dividido, DNSSEC y resoluciones en entornos híbridos.
* [Cloud CDN (Content Delivery Network)](./networking(Redes)/cloud-cdn.md)  
  Almacenamiento en caché en puntos perimetrales, integración con balanceadores de carga, URLs firmadas e invalidación.
* [Cloud VPN (Virtual Private Network)](./networking(Redes)/cloud-vpn.md)  
  Conectividad híbrida cifrada sobre internet, diferencias entre HA VPN (99.99%) y Classic VPN (99.9%).
* [Cloud Router (Enrutador de Nube)](./networking(Redes)/cloud-router.md)  
  Enrutamiento dinámico mediante intercambio de rutas con BGP para VPN, Interconnect y Cloud NAT.
* [Conectividad Híbrida (Conexiones a la VPC)](./networking(Redes)/conectividad-hibrida.md)  
  Opciones para conectar redes locales y multi-nube a GCP (VPN, Peering e Interconnect).
* [Direct Peering (Intercambio de Tráfico Directo)](./networking(Redes)/direct-peering.md)  
  Intercambio de tráfico BGP público y directo con el borde de Google, requisitos y casos de uso.


## 🔒 Security (Seguridad)
* [IAM - Identity and Access Management (Administración de Accesos)](./security(Seguridad)/IAM.md)  
  Conceptos clave sobre control de accesos, roles básicos/predefinidos/personalizados, cuentas de servicio y Cloud Identity.
* [Service Accounts (Cuentas de Servicio)](./security(Seguridad)/service-accounts.md)  
  Uso de identidades programáticas para aplicaciones, administración de llaves, e impersonación de cuentas.


