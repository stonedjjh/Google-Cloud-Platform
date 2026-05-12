# Comandos de GCP

## Comandos generales

Son comados que aplican a toda la infraestructura de GCP

### Solicitar el nombre de la cuenta activa

`gcloud auth list`

### Solicitar el od del proyecto

`gcloud config list project`

## Comandos de instancias (`VM`)

### Instancas

#### Crear una instancia

Para crear instancias se usa el comando `gcloud compute instances create`

Para [referencia](https://cloud.google.com/sdk/gcloud/reference/compute/instances/create), ejemplos y flag adicionales.

**Ejemplo:**

```bash
gcloud compute instances create www1 \
    --zone=Zone \
    --tags=network-lb-tag \
    --machine-type=e2-small \
    --image-family=debian-11 \
    --image-project=debian-cloud \
    --metadata=startup-script='#!/bin/bash
      apt-get update
      apt-get install apache2 -y
      service apache2 restart
      echo "
<h3>Web Server: www1</h3>" | tee /var/www/html/index.html'
```

Del ejercicio anterios:

- `www1` es el nombre de la instancia

- `--zone` es el flag que permite establecer la zona

- `--tags` es el flag qu permite establecer etiquetas para la instancia, lo cual facilita la agrupación de recursos de manera sencilla.

- `--machine-type` es el flag que permite establecer el tipo de máquina

- `--image-family` es el flag que permite establecer la familia de imágenes

- `--image-project` es el flag que permite establecer el proyecto de imágenes

- `--metadata` es el flag que permite establecer metadatos

gcloud compute instances describe linux-instance --zone=us-west4-b --format='get(networkInterfaces[0].accessConfigs[0].natIP)'

#### Listar las instancias

Para listar las instancias se usa el comando `gcloud compute instances list`

**Salida:**

```bash
NAME: example-instance-1
ZONE: us-central1-c
MACHINE_TYPE: e2-small
PREEMPTIBLE:
INTERNAL_IP: 10.128.0.2
EXTERNAL_IP: 34.121.97.27
STATUS: RUNNING
```

### Target Pool

#### Crear un target pool

Para crear un target pool se usa el comando `gcloud compute target-pools create`

Para [referencia](https://cloud.google.com/sdk/gcloud/reference/compute/target-pools/create)

**Ejemplo:**

```bash
gcloud compute target-pools create www-pool \
  --region Region --http-health-check basic-check
```

En este ejemplo:

- `www-pool` es el nombre del target pool

- `--region` es el flag que permite establecer la región

- `--http-health-check` es el flag que permite establecer el verificador de estado asociado al target pool

#### Agregar instancias al target pool

Para agregar instancias al target pool se usa el comando `gcloud compute target-pools add-instances`

**Ejemplo:**

```bash
gcloud compute target-pools add-instances www-pool \
    --instances www1,www2,www3
```

En este ejemplo:

- `www-pool` es el nombre del target pool

- `--instances` es el flag que permite establecer las instancias a agregar al target pool

### Plantilla de instancia

#### Crear una plantilla de instancia

Para crear una plantilla de instancia se usa el comando `gcloud compute instance-templates create`

Para [referencia](https://docs.cloud.google.com/sdk/gcloud/reference/compute/instance-templates/create)

**Ejemplo:**

```bash
gcloud compute instance-templates create lb-backend-template \
   --region=Region \
   --network=default \
   --subnet=default \
   --tags=allow-health-check \
   --machine-type=e2-medium \
   --image-family=debian-11 \
   --image-project=debian-cloud \
   --metadata=startup-script='#!/bin/bash
     apt-get update
     apt-get install apache2 -y
     a2ensite default-ssl
     a2enmod ssl
     vm_hostname="$(curl -H "Metadata-Flavor:Google" \
     http://169.254.169.254/computeMetadata/v1/instance/name)"
     echo "Page served from: $vm_hostname" | \
     tee /var/www/html/index.html
     systemctl restart apache2'
```

En este ejemplo:

- `lb-backend-template` es el nombre de la plantilla de instancia

- `--region` es el flag que permite establecer la región

- `--network` es el flag que permite establecer la red

- `--subnet` es el flag que permite establecer la subred

- `--tags` es el flag que permite establecer etiquetas para la plantilla de instancia, lo cual facilita la agrupación de recursos de manera sencilla.

- `--machine-type` es el flag que permite establecer el tipo de máquina

- `--image-family` es el flag que permite establecer la familia de imágenes

- `--image-project` es el flag que permite establecer el proyecto de imágenes

- `--metadata` es el flag que permite establecer metadatos

### Grupo de instancias administradas (MIG)

#### Crear un grupo de instancias administradas

Para crear un grupo de instancias administradas se usa el comando `gcloud compute instance-groups managed create`

Para [referencia](https://docs.cloud.google.com/sdk/gcloud/reference/compute/instance-groups/managed/create)

**Ejemplo:**

```bash
gcloud compute instance-groups managed create lb-backend-group \
   --template=lb-backend-template --size=2 --zone=Zone
```

En este ejemplo:

- `lb-backend-group` es el nombre del grupo de instancias administradas

- `--template` es el flag que permite establecer la plantilla de instancia asociada al grupo de instancias administradas

- `--size` es el flag que permite establecer el número de instancias en el grupo de instancias administradas

- `--zone` es el flag que permite establecer la zona

### Backend Services

#### Crear un backend service

Para crear un backend service se usa el comando `gcloud compute backend-services create`

Para [referencia](https://docs.cloud.google.com/sdk/gcloud/reference/compute/backend-services/create)

**Ejemplo:**

```bash
gcloud compute backend-services create web-backend-service \
  --protocol=HTTP \
  --port-name=http \
  --health-checks=http-basic-check \
  --global
```

En este ejemplo:

- `web-backend-service` es el nombre del backend service

- `--protocol` es el flag que permite establecer el protocolo

- `--port-name` es el flag que permite establecer el nombre del puerto

- `--health-checks` es el flag que permite establecer el verificador de estado asociado al backend service

- `--global` es el flag que permite establecer el backend service como global

#### Agregar instancias al backend service

Para agregar instancias al backend service se usa el comando `gcloud compute backend-services add-backend`

**Ejemplo:**

```bash
gcloud compute backend-services add-backend web-backend-service \
  --instance-group=lb-backend-group \
  --instance-group-zone=Zone \
  --global
```

En este ejemplo:

- `web-backend-service` es el nombre del backend service

- `--instance-group` es el flag que permite establecer el grupo de instancias administradas asociado al backend service

- `--instance-group-zone` es el flag que permite establecer la zona del grupo de instancias administradas asociado al backend service

- `--global` es el flag que permite establecer el backend service como global

### Mapa de URLs

#### Crear un mapa de URLs

Para crear un mapa de URLs se usa el comando `gcloud compute url-maps create`

Para [referencia](https://docs.cloud.google.com/sdk/gcloud/reference/compute/url-maps/create)

**Ejemplo:**

```bash
gcloud compute url-maps create web-map \
  --default-service web-backend-service
```

En este ejemplo:

- `web-map` es el nombre del mapa de URLs

- `--default-service` es el flag que permite establecer el backend service predeterminado para el mapa de URLs

## Comandos de red (Network)

### IP

#### Crear una dirección

Para crear una dirección `ip` se usa el comando `gcloud compute addresses create` para mas información [documetación](https://docs.cloud.google.com/sdk/gcloud/reference/compute/addresses/create)

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

### Firewall

#### Crear una regla de firewall

Para crear una regla de firewall se usa el comando `gcloud compute firewall-rules create` para mas [información](https://cloud.google.com/sdk/gcloud/reference/compute/firewall-rules/create)

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

### Verificador de Estado (health check)

#### Crear un verificador de estado heredado

Para crear un verificador de estado heredado se usa el comando `gcloud compute http-health-checks create` para mas información [documentación](https://cloud.google.com/sdk/gcloud/reference/compute/http-health-checks/create)

**Ejemplo:**

```bash
gcloud compute http-health-checks create basic-check
```

En este ejemplo:

- `basic-check` es el nombre del verificador de estado

### Reglas de Reenvio (forwarding rule)

#### Crear una regla de reenvio

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
### Crear una regla de reenvio global para enrutar las solicitudes entrantes al proxy HTTP de destino

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

#### Obtener información de la regla de reenvio

Para obtener información de la regla de reenvio se usa el comando `gcloud compute forwarding-rules describe`

**Ejemplo:**

```bash
gcloud compute forwarding-rules describe www-rule --region Region
```

En este ejemplo:

- `www-rule` es el nombre de la regla de reenvio

- `--region` es el flag que permite establecer la región

### Proxy HTTP de destino

#### Crear un proxy HTTP de destino

Para crear un proxy HTTP de destino se usa el comando `gcloud compute target-http-proxies create`

Para mas información [documentación](https://cloud.google.com/sdk/gcloud/reference/compute/target-http-proxies/create)

**Ejemplo:**

```bash
gcloud compute target-http-proxies create http-lb-proxy \
    --url-map web-map-http
```

En este ejemplo:

- `http-lb-proxy` es el nombre del proxy HTTP de destino

- `--url-map` es el flag que permite establecer el mapa de URLs asociado al proxy HTTP de destino
