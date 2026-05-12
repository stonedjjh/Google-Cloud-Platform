# Configura balanceadores de cargas de red

## GSP007

![Logotipo de los labs de autoaprendizaje de Google Cloud](https://cdn.qwiklabs.com/GMOHykaqmlTHiqEeQXTySaMXYPHeIvaqa2qHEzw6Occ%3D)

## Descripción general

En este lab práctico, aprenderás a configurar un balanceador de cargas de red (NLB) de transferencia que se ejecute en máquinas virtuales (VMs) de Compute Engine. Un NLB de capa 4 (L4) controla el tráfico según la información a nivel de la red, como las direcciones IP y los números de puerto, y no inspecciona el contenido del tráfico.

Existen varias formas de [balancear cargas en Google Cloud](https://cloud.google.com/load-balancing/docs/load-balancing-overview#a_closer_look_at_cloud_load_balancers). En este lab, conocerás los pasos para configurar los siguientes balanceadores de cargas:

- [Balanceador de cargas de red](https://cloud.google.com/compute/docs/load-balancing/network/)

Es aconsejable que escribas los comandos por tu cuenta, ya que te ayudará a aprender los conceptos básicos. Muchos labs incluyen un bloque de código que contiene los comandos necesarios. Durante el lab, puedes copiar y pegar fácilmente los comandos del bloque de código en los lugares apropiados.

## Objetivos

En este lab, aprenderás a realizar las siguientes tareas:

- Configurar la región y la zona predeterminadas para tus recursos
- Crear varias instancias de servidor web
- Configurar un servicio de balanceo de cargas
- Configurar una regla de reenvío para distribuir el tráfico

## Tareas

### Tarea 1: Configura la región y la zona predeterminadas para todos los recursos

1. Configura la región predeterminada:
   `gcloud config set compute/region Region`

2. En Cloud Shell, configura la zona predeterminada:
   `gcloud config set compute/zone Zone`

Consulta la documentación [Regiones y zonas](https://cloud.google.com/compute/docs/zones) de Compute Engine para obtener más información sobre cómo elegirlas.

### Tarea 2. Crea varias instancias de servidor web

Para esta situación de balanceo de cargas, crea tres instancias de VM de Compute Engine e instala Apache en ellas. Luego, agrega una regla de firewall que permita que el tráfico HTTP llegue a las instancias.

El código proporcionado establece la zona en `Zone`. Si configuras el campo `tags`, podrás hacer referencia a estas instancias de una sola vez, por ejemplo, con una regla de firewall. Con estos comandos, también se instala Apache en cada instancia y se les otorga una página principal única:

1. Crea una máquina virtual `www1` en tu zona predeterminada con el siguiente código:

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

2. Crea una máquina virtual www2 en tu zona predeterminada con el siguiente código:

   ```bash
   gcloud compute instances create www2 \
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
   <h3>Web Server: www2</h3>" | tee /var/www/html/index.html'
   ```

3. Crea una máquina virtual www3 en tu zona predeterminada.

   ```bash
   gcloud compute instances create www3 \
     --zone=Zone  \
     --tags=network-lb-tag \
     --machine-type=e2-small \
     --image-family=debian-11 \
     --image-project=debian-cloud \
     --metadata=startup-script='#!/bin/bash
       apt-get update
       apt-get install apache2 -y
       service apache2 restart
       echo "
   <h3>Web Server: www3</h3>" | tee /var/www/html/index.html'
   ```

4. Crea una regla de firewall para permitir la entrada del tráfico externo a las instancias de VM:

   ```bash
   gcloud compute firewall-rules create www-firewall-network-lb \
     --target-tags network-lb-tag --allow tcp:80
   ```

   Ahora debes obtener las direcciones IP externas de tus instancias y verificar que se estén ejecutando.

5. Ejecuta los siguientes comandos para generar una lista de tus instancias. Encontrarás las direcciones IP en la columna `EXTERNAL_IP`:

   `gcloud compute instances list`

6. Verifica que cada instancia se esté ejecutando con curl (reemplaza **[IP_ADDRESS]** por la dirección IP externa de cada VM):

   `curl http://[IP_ADDRESS]`

Haz clic en **Revisar mi progreso** para verificar que creaste un grupo de servidores web.

### Tarea 3. Configura el servicio de balanceo de cargas

Cuando configuras el servicio de balanceo de cargas, tus instancias de máquina virtual reciben paquetes destinados a la dirección IP externa estática que configures. Las instancias creadas con una imagen de Compute Engine se configuran automáticamente para administrar esta dirección IP.

> [!NOTE]
> **Nota:** Obtén más información para configurar el balanceo de cargas de red en la guía [Descripción general del balanceador de cargas de red de transferencia externo basado en servicios de backend.](https://cloud.google.com/compute/docs/load-balancing/network/)

1. Crea una dirección IP externa estática para tu balanceador de cargas:

   ```bash
   gcloud compute addresses create network-lb-ip-1 \
   --region Region
   ```

   Resultado:

   `Created [https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-03-xxxxxxxxxxx/regions//addresses/network-lb-ip-1].`

2. Agrega un recurso de verificación de estado HTTP heredado:

   `gcloud compute http-health-checks create basic-check`

Haz clic en Revisar mi progreso para verificar que creaste un balanceador de cargas de red L4 dirigido a los servidores web.
Configurar el servicio de balanceo de cargas

### Tarea 4: Crea el grupo de destino y la regla de reenvío

Un grupo de destino es un grupo de instancias de backend que reciben tráfico entrante de los NLB de transferencia externos. Todas las instancias de backend de un grupo de destino deben estar en la misma región de Google Cloud.

1. Ejecuta el siguiente comando para crear el grupo de destino y utilizar la verificación de estado requerida para que funcione el servicio:

   ```bash
   gcloud compute target-pools create www-pool \
   --region Region --http-health-check basic-check
   ```

2. Agrega al grupo las instancias que creaste anteriormente:

   ```bash
   gcloud compute target-pools add-instances www-pool \
    --instances www1,www2,www3
   ```

   A continuación, crearás la [regla de reenvío.](https://cloud.google.com/load-balancing/docs/forwarding-rule-concepts) Una regla de reenvío especifica cómo enrutar el tráfico de red a los servicios de backend de un balanceador de cargas.

3. Agrega una regla de reenvío:

   ```bash
   gcloud compute forwarding-rules create www-rule \
    --region Region \
    --ports 80 \
    --address network-lb-ip-1 \
    --target-pool www-pool
   ```

Haz clic en **Revisar mi progreso** para verificar que creaste el grupo de destino y una regla de reenvío.

## Tarea 5: Envía tráfico a tus instancias

Ahora que está configurado el servicio de balanceo de cargas, puedes comenzar a enviar tráfico a la regla de reenvío y ver cómo se dispersa el tráfico a las diferentes instancias.

1. Ingresa el comando siguiente para ver la dirección IP externa de la regla de reenvío www-rule que usa el balanceador de cargas:

   `gcloud compute forwarding-rules describe www-rule --region Region`

2. Accede a la dirección IP externa:

   `IPADDRESS=$(gcloud compute forwarding-rules describe www-rule --region Region --format="json" | jq -r .IPAddress)`

3. Muestra la dirección IP externa:

   `echo $IPADDRESS`

4. Utiliza el comando `curl` para acceder a la dirección IP externa (reemplaza IP_ADDRESS por la dirección IP externa del comando anterior):

   `while true; do curl -m1 $IPADDRESS; done`

La respuesta del comando curl se alterna de manera aleatoria entre las tres instancias. Si al principio la respuesta es incorrecta, espera aproximadamente 30 segundos para que la configuración se cargue por completo y las instancias estén en buen estado antes de volver a intentarlo.

Utiliza Ctrl + C para detener la ejecución del comando.
