# Comandos de instancias (VM)

## Instancas

### Crear una instancia

Para crear instancias se usa el comando `gcloud compute instances create`

Para referencia, ejemplos y flag adicionales.

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

### Listar las instancias

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

## Target Pool

### Crear un target pool

Para crear un target pool se usa el comando `gcloud compute target-pools create`

Para referencia

**Ejemplo:**

```bash
gcloud compute target-pools create www-pool \
  --region Region --http-health-check basic-check
```

En este ejemplo:

- `www-pool` es el nombre del target pool

- `--region` es el flag que permite establecer la región

- `--http-health-check` es el flag que permite establecer el verificador de estado asociado al target pool

### Agregar instancias al target pool

Para agregar instancias al target pool se usa el comando `gcloud compute target-pools add-instances`

**Ejemplo:**

```bash
gcloud compute target-pools add-instances www-pool \
    --instances www1,www2,www3
```

En este ejemplo:

- `www-pool` es el nombre del target pool

- `--instances` es el flag que permite establecer las instancias a agregar al target pool

## Plantilla de instancia

### Crear una plantilla de instancia

Para crear una plantilla de instancia se usa el comando `gcloud compute instance-templates create`

Para referencia

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

## Grupo de instancias administradas (MIG)

### Crear un grupo de instancias administradas

Para crear un grupo de instancias administradas se usa el comando `gcloud compute instance-groups managed create`

Para referencia

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

## Backend Services

### Crear un backend service

Para crear un backend service se usa el comando `gcloud compute backend-services create`

Para referencia

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

### Agregar instancias al backend service

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

## Mapa de URLs

### Crear un mapa de URLs

Para crear un mapa de URLs se usa el comando `gcloud compute url-maps create`

Para referencia

**Ejemplo:**

```bash
gcloud compute url-maps create web-map \
  --default-service web-backend-service
```

En este ejemplo:

- `web-map` es el nombre del mapa de URLs

- `--default-service` es el flag que permite establecer el backend service predeterminado para el mapa de URLs
