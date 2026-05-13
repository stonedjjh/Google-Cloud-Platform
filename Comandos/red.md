# Comandos de red (Network)

## IP

### Crear una dirección

Para crear una dirección `ip` se usa el comando `gcloud compute addresses create` para mas información documetación

**Ejemplo:**

```bash
# Crea una dirección IP estática externa regional para ser usada por un balanceador de carga de red (L4)
gcloud compute addresses create network-lb-ip-1 \
   --region Region
```

En este ejemplo:

- `network-lb-ip-1` es el nombre de la dirección

- `--region` es el flag que permite establecer la región

```bash
# Crea una dirección IP estática global para ser usada por un balanceador de carga de red (L4)
gcloud compute addresses create lb-ipv4-1 \
  --ip-version=IPV4 \
  --global
```

En este ejemplo:

- `lb-ipv4-1` es el nombre de la dirección

- `--ip-version` es el flag que permite establecer la versión de IP

- `--global` es el flag que permite establecer la dirección global

## Firewall

### Crear una regla de firewall

Para crear una regla de firewall se usa el comando `gcloud compute firewall-rules create` para mas información

**Ejemplo:**

```bash
# Crea una regla de firewall para permitir el tráfico externo (HTTP) hacia las instancias de VM
gcloud compute firewall-rules create www-firewall-network-lb \
    --target-tags network-lb-tag --allow tcp:80
```

En este ejemplo:

- `www-firewall-network-lb` es el nombre de la regla de firewall

- `--target-tags` es el flag que permite establecer las etiquetas de destino

- `--allow` es el flag que permite establecer el puerto y el protocolo

```bash
# Crea una regla de firewall para permitir el tráfico de los sistemas de verificación de estado de Google Cloud a los backends del balanceador de carga de aplicaciones (L7)
gcloud compute firewall-rules create fw-allow-health-check \
  --network=default \
  --action=allow \
  --direction=ingress \
  --source-ranges=130.211.0.0/22,35.191.0.0/16 \
  --target-tags=allow-health-check \
  --rules=tcp:80
```

En este ejemplo:

- `fw-allow-health-check` es el nombre de la regla de firewall

- `--network` es el flag que permite establecer la red

- `--action` es el flag que permite establecer la acción

- `--direction` es el flag que permite establecer la dirección del tráfico

- `--source-ranges` es el flag que permite establecer los rangos de IP de origen

- `--target-tags` es el flag que permite establecer las etiquetas de destino

- `--rules` es el flag que permite establecer el puerto y el protocolo

## Verificador de Estado (health check)

### Crear un verificador de estado heredado

Para crear un verificador de estado heredado se usa el comando `gcloud compute http-health-checks create` para mas información documentación

**Ejemplo:**

```bash
gcloud compute http-health-checks create basic-check
```

En este ejemplo:

- `basic-check` es el nombre del verificador de estado

## Reglas de Reenvio (forwarding rule)

### Crear una regla de reenvio

Para crear una regla de reenvio se usa el comando `gcloud compute forwarding-rules create`

**Ejemplo:**

```bash
# Crea una regla de reenvío regional para un balanceador de carga de red (L4) usando un Target Pool
gcloud compute forwarding-rules create www-rule \
    --region  Region \
    --ports 80 \
    --address network-lb-ip-1 \
    --target-pool www-pool
```

En este ejemplo:

- `www-rule` es el nombre de la regla de reenvio

- `--region` es el flag que permite establecer la región

- `--ports` es el flag que permite establecer los puertos

- `--address` es el flag que permite establecer la dirección ip

- `--target-pool` es el flag que permite establecer el target pool al cual se le asignará la regla de reenvio

```bash
## Crear una regla de reenvio global para enrutar las solicitudes entrantes al proxy HTTP de destino

gcloud compute forwarding-rules create http-content-rule \
   --address=lb-ipv4-1\
   --global \
   --target-http-proxy=http-lb-proxy \
   --ports=80
```

En este ejemplo:

- `http-content-rule` es el nombre de la regla de reenvio

- `--address` es el flag que permite establecer la dirección ip

- `--global` es el flag que permite establecer la regla de reenvio global

- `--target-http-proxy` es el flag que permite establecer el proxy HTTP de destino al cual se le asignará la regla de reenvio

- `--ports` es el flag que permite establecer los puertos

### Obtener información de la regla de reenvio

Para obtener información de la regla de reenvio se usa el comando `gcloud compute forwarding-rules describe`

**Ejemplo:**

```bash
gcloud compute forwarding-rules describe www-rule --region Region
```

En este ejemplo:

- `www-rule` es el nombre de la regla de reenvio

- `--region` es el flag que permite establecer la región

## Proxy HTTP de destino

### Crear un proxy HTTP de destino

Para crear un proxy HTTP de destino se usa el comando `gcloud compute target-http-proxies create`

Para mas información documentación

**Ejemplo:**

```bash
gcloud compute target-http-proxies create http-lb-proxy \
    --url-map web-map-http
```

En este ejemplo:

- `http-lb-proxy` es el nombre del proxy HTTP de destino

- `--url-map` es el flag que permite establecer el mapa de URLs asociado al proxy HTTP de destino
