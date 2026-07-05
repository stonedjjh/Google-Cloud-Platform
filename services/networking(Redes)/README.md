# Networking (Redes)

Este directorio contiene la documentación de los servicios de red de Google Cloud Platform organizados en dos sub‑carpetas para mejorar la **visibilidad** y la **navegación**.

## 📂 Estructura propuesta

networking(Redes)/
├─ conectividad/          # Conectividad externa (peering, VPN, Interconnect)
│   ├─ [direct-peering.md](file:///c:/cloud/GCP%20LAB/Google-Cloud-Platform/services/networking(Redes)/conectividad/direct-peering.md)
│   ├─ [carrier-peering.md](file:///c:/cloud/GCP%20LAB/Google-Cloud-Platform/services/networking(Redes)/conectividad/carrier-peering.md)
│   ├─ [conectividad-hibrida.md](file:///c:/cloud/GCP%20LAB/Google-Cloud-Platform/services/networking(Redes)/conectividad-hibrida.md)
│   ├─ vpn/                # Classic VPN y HA VPN
│   │   └─ [cloud-vpn.md](file:///c:/cloud/GCP%20LAB/Google-Cloud-Platform/services/networking(Redes)/conectividad/vpn/cloud-vpn.md)
│   └─ interconnect/       # Dedicated & Partner 
│       ├─ [dedicated-interconnect.md](file:///c:/cloud/GCP%20LAB/Google-Cloud-Platform/services/networking(Redes)/conectividad/interconnect/dedicated-interconnect.md)
│       └─ [partner-interconnect.md](file:///c:/cloud/GCP%20LAB/Google-Cloud-Platform/services/networking(Redes)/conectividad/interconnect/partner-interconnect.md)

├─ vpc/                  # Componentes internos de la VPC
│   ├─ [VPC.md](file:///c:/cloud/GCP%20LAB/Google-Cloud-Platform/services/networking(Redes)/vpc/VPC.md)
│   ├─ [subnetwork.md](file:///c:/cloud/GCP%20LAB/Google-Cloud-Platform/services/networking(Redes)/vpc/subnetwork.md)
│   ├─ [firewall-rules.md](file:///c:/cloud/GCP%20LAB/Google-Cloud-Platform/services/networking(Redes)/vpc/firewall-rules.md)
│   └─ [cloud-router.md](file:///c:/cloud/GCP%20LAB/Google-Cloud-Platform/services/networking(Redes)/vpc/cloud-router.md)

├─ [load-balancing.md](file:///c:/cloud/GCP%20LAB/Google-Cloud-Platform/services/networking(Redes)/load-balancing.md)
├─ [cloud-cdn.md](file:///c:/cloud/GCP%20LAB/Google-Cloud-Platform/services/networking(Redes)/cloud-cdn.md)
├─ [cloud-dns.md](file:///c:/cloud/GCP%20LAB/Google-Cloud-Platform/services/networking(Redes)/cloud-dns.md)
├─ [Health-Checks-Legacy-vs-Global.md](file:///c:/cloud/GCP%20LAB/Google-Cloud-Platform/services/networking(Redes)/Health-Checks-Legacy-vs-Global.md)

## 📖 Guías rápidas

- **Conectividad externa**: consulta la carpeta *conectividad* para Direct Peering, Carrier Peering, VPN y Interconnect.
- **Componentes VPC**: todo lo que afecta a la VPC interna (subredes, firewalls, rutas y Cloud Router) está bajo *vpc*.
- **Balanceo de carga**: permanece en la raíz porque se aplica a nivel de arquitectura global.

---

> **Nota:** Los archivos originales siguen existiendo en su ubicación anterior para mantener compatibilidad, pero la nueva estructura es la referencia recomendada.
