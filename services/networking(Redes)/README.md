# Networking (Redes)

Este directorio contiene la documentación de los servicios de red de Google Cloud Platform organizados en dos sub‑carpetas para mejorar la **visibilidad** y la **navegación**.

## 📂 Estructura propuesta

├─ conectividad/          # Conectividad externa (peering, VPN, Interconnect)
│   ├─ [direct-peering.md](./conectividad/direct-peering.md)
│   ├─ [carrier-peering.md](./conectividad/carrier-peering.md)
│   ├─ [conectividad-hibrida.md](./conectividad/conectividad-hibrida.md)
│   ├─ vpn/                # Classic VPN y HA VPN
│   │   └─ [cloud-vpn.md](./conectividad/vpn/cloud-vpn.md)
│   └─ interconnect/       # Dedicated & Partner 
│       ├─ [dedicated-interconnect.md](./conectividad/interconnect/dedicated-interconnect.md)
│       ├─ [partner-interconnect.md](./conectividad/interconnect/partner-interconnect.md)
│       └─ [cross-cloud-interconnect.md](./conectividad/interconnect/cross-cloud-interconnect.md)
│
├─ vpc/                  # Componentes internos de la VPC
│   ├─ [VPC.md](./vpc/VPC.md)
│   ├─ [subnetwork.md](./vpc/subnetwork.md)
│   ├─ [firewall-rules.md](./vpc/firewall-rules.md)
│   └─ [cloud-router.md](./vpc/cloud-router.md)
│
├─ [load-balancing.md](./load-balancing.md)
├─ [cloud-cdn.md](./cloud-cdn.md)
├─ [cloud-dns.md](./cloud-dns.md)
├─ [Health-Checks-Legacy-vs-Global.md](./Health-Checks-Legacy-vs-Global.md)

## 📖 Guías rápidas

- **Conectividad externa**: consulta la carpeta *conectividad* para Direct Peering, Carrier Peering, VPN y Interconnect.
- **Componentes VPC**: todo lo que afecta a la VPC interna (subredes, firewalls, rutas y Cloud Router) está bajo *vpc*.
- **Balanceo de carga**: permanece en la raíz porque se aplica a nivel de arquitectura global.

---

> **Nota:** Los archivos originales siguen existiendo en su ubicación anterior para mantener compatibilidad, pero la nueva estructura es la referencia recomendada.
