# Reglas de firewall de VPC (Firewall Rules)

## Descripción general
Las **reglas de firewall de VPC** controlan el tráfico de red que entra y sale de las instancias y subredes de una VPC en Google Cloud. Cada regla especifica un conjunto de atributos (direcciones IP, puertos, protocolos, etiquetas de recursos, etc.) y una acción (allow / deny). Las reglas se evalúan en orden de prioridad, del número más bajo al más alto.

## Componentes clave
- **Prioridad** (0‑65535): valor numérico; a menor número, mayor precedencia. Las reglas predeterminadas tienen prioridad 1000.
- **Dirección**: `INGRESS` (entrada) o `EGRESS` (salida).
- **Acción**: `allow` o `deny`.
- **Protocolos y puertos**: TCP, UDP, ICMP, ESP, AH, o todos (`all`).
- **Rangos de IP de origen/destino**: CIDR o rangos de direcciones de Google (`0.0.0.0/0` para cualquier IP).
- **Objetivo**: se aplican a instancias mediante **etiquetas** (`targetTags`) o a todas las instancias de la red (`targetServiceAccounts`).
- **Logueo**: opción para registrar tráfico que coincide con la regla (`logConfig`).

## Tipos de reglas habituales
| Tipo | Uso típico |
|------|------------|
| **Regla predeterminada de ingreso** | Permite tráfico SSH (`tcp:22`) y RDP (`tcp:3389`) desde cualquier IP a instancias sin etiquetas. Se puede restringir o eliminar según políticas de seguridad. |
| **Regla de ingreso para servicios internos** | Permite tráfico entre instancias de la misma VPC (por ejemplo, `tcp:0-65535` desde `10.0.0.0/8`). |
| **Regla de salida global** | Permite que todas las instancias accedan a Internet (`0.0.0.0/0`) en los puertos necesarios (por ejemplo, `tcp:443` para actualizaciones). |
| **Regla de denegación** | Bloquea puertos críticos (por ejemplo, `tcp:25` para evitar envío de correo no autorizado). |

## Buenas prácticas
## Reglas predeterminadas de la VPC

| Nombre | Dirección | Acción | Prioridad | Rango de origen/destino | Puertos/Protocolos | Comentario |
|--------|-----------|--------|-----------|------------------------|--------------------|------------|
| default-allow-icmp | INGRESS | allow | 65534 | 0.0.0.0/0 | icmp | Permite tráfico ICMP (ping) |
| default-allow-rdp | INGRESS | allow | 65534 | 0.0.0.0/0 | tcp:3389 | Permite acceso RDP |
| default-allow-ssh | INGRESS | allow | 65534 | 0.0.0.0/0 | tcp:22 | Permite acceso SSH |
| default-allow-internal | INGRESS | allow | 65534 | 10.0.0.0/8 | all | Permite tráfico interno entre instancias de la VPC |

- **Principio de menor privilegio**: crear reglas lo más restrictivas posible y añadir excepciones únicamente cuando sea necesario.
- **Usar etiquetas**: asignar etiquetas a grupos de instancias y basar las reglas en esas etiquetas en lugar de direcciones IP estáticas.
- **Prioridades claras**: reservar rangos de prioridades (por ejemplo, 100‑199 para reglas críticas, 200‑399 para reglas de aplicación, 400‑600 para reglas de desarrollo). 
- **Auditar y registrar**: habilitar `logConfig` en reglas de alta sensibilidad y revisar los logs en Cloud Logging.
- **Eliminar reglas predeterminadas** que no sean necesarias (por ejemplo, la regla `allow-icmp-ingress` si no se usa ping). 
- **Versionado**: mantener un archivo de control de versiones (por ejemplo, en Cloud Source Repositories) que describa cada regla y su propósito.

## Ejemplos de reglas comunes (Terraform)
```hcl
resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  network = "default"
  direction = "INGRESS"
  priority  = 1000
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh-access"]
  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_firewall" "deny-all-egress" {
  name    = "deny-all-egress"
  network = "default"
  direction = "EGRESS"
  priority  = 1000
  deny {
    protocol = "all"
  }
  destination_ranges = ["0.0.0.0/0"]
}
```

## Procedimiento para crear/actualizar una regla (gcloud)
1. **Definir la necesidad** (p. ej., abrir puerto 443 para servidores web).
2. **Seleccionar prioridad** que no entre en conflicto con reglas existentes.
3. **Ejecutar el comando**:
   ```bash
   gcloud compute firewall-rules create allow-https \
     --network=default \
     --direction=INGRESS \
     --priority=1000 \
     --action=allow \
     --rules=tcp:443 \
     --source-ranges=0.0.0.0/0 \
     --target-tags=web-server \
     --enable-logging
   ```
4. **Verificar** la regla con:
   ```bash
   gcloud compute firewall-rules describe allow-https
   ```
5. **Auditar** mediante Cloud Logging y ajustar según hallazgos.

## Enlaces relacionados
- **[Documentación oficial de firewall de VPC](https://cloud.google.com/vpc/docs/firewalls)** – guía completa, conceptos y ejemplos.
- **[Ejemplos de Terraform para firewall](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall)**
- **[Políticas de organización para firewall (VPC Service Controls)](https://cloud.google.com/vpc-service-controls/docs/configure-firewall-rules)**

## Resumen rápido (cheatsheet)
- **Crear regla ingress**: `gcloud compute firewall-rules create NAME --direction=INGRESS --action=ALLOW --rules=PROTO:PORTS --source-ranges=IP_RANGE --target-tags=TAG`
- **Crear regla egress**: cambia `--direction=EGRESS` y usa `--destination-ranges`.
- **Listar reglas**: `gcloud compute firewall-rules list`
- **Eliminar regla**: `gcloud compute firewall-rules delete NAME`
- **Actualizar prioridad**: `gcloud compute firewall-rules update NAME --priority=NEW_VALUE`

## Datos Clave

- **Regla por defecto:** Si una regla no está definida, el tráfico se niega por defecto (default deny).
- **Prioridad:** Si dos reglas se contradicen, se aplica la que tenga mayor prioridad (número menor).
- **Orden de evaluación:** Las reglas se evalúan en orden ascendente de prioridad; la primera coincidencia se aplica.
- **Acción allow/deny:** Cada regla especifica si permite o deniega el tráfico según los criterios definidos.
- **Capas de Operación (L3/L4):** Las reglas de firewall operan estrictamente en las **Capas 3 (Red) y 4 (Transporte)** del modelo OSI. Filtran por IP de origen/destino, protocolo y puertos; no pueden inspeccionar el contenido del paquete ni filtrar en la Capa 7 (Aplicación).


