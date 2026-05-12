# Configura balanceadores de cargas de aplicaciones

## GSP155

![Logotipo de los labs de autoaprendizaje de Google Cloud](https://cdn.qwiklabs.com/GMOHykaqmlTHiqEeQXTySaMXYPHeIvaqa2qHEzw6Occ%3D)

## Descripción general

En este lab práctico, aprenderás a configurar un balanceador de cargas de aplicaciones de capa 7 (L7) en máquinas virtuales (VMs) de Compute Engine. Los balanceadores de cargas L7 pueden comprender los protocolos HTTP(S), lo que les permite tomar decisiones de enrutamiento basadas en parámetros como la URL, los encabezados, las cookies y el contenido de la solicitud. Esto permite mejorar el rendimiento y la capacidad de respuesta de las aplicaciones.

Existen varias formas de [balancear cargas en Google Cloud](https://cloud.google.com/load-balancing/docs/load-balancing-overview#a_closer_look_at_cloud_load_balancers). En este lab, conocerás los pasos para configurar los siguientes balanceadores de cargas:

- [Balanceador de cargas de aplicaciones](https://cloud.google.com/compute/docs/load-balancing/http/)

Es aconsejable que escribas los comandos por tu cuenta, ya
que te ayudará a aprender los conceptos básicos. Muchos labs incluyen un bloque de código que contiene los comandos necesarios. Durante el lab, puedes copiar y pegar fácilmente los comandos del bloque de código en los lugares apropiados.

## Objetivos

En este lab, aprenderás a realizar las siguientes tareas:

- Configurar la región y la zona predeterminadas para tus recursos

- Crear un balanceador de cargas de aplicaciones

-Probar el tráfico a tus instancias

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

### Tarea 3: Crea un balanceador de cargas de aplicaciones

El balanceo de cargas de aplicaciones se implementa en Google Front End (GFE). Los GFE se distribuyen globalmente y operan juntos con el plano de control y la red global de Google. Puedes configurar reglas de URL que enruten algunas URLs a un conjunto de instancias y otras URLs a otras instancias.

Las solicitudes siempre se enrutan al grupo de instancias más cercano al usuario si el grupo tiene la capacidad suficiente y es apropiado para la solicitud. Si el grupo más cercano no tiene suficiente capacidad, la solicitud se envía al grupo más cercano que sí la tenga.

Para configurar un balanceador de cargas con un backend de Compute Engine, tus VMs deben estar en un grupo de instancias. El grupo de instancias administrado proporciona las VMs que ejecutan los servidores de backend de un balanceador de cargas de aplicaciones externo. En este lab, los backends entregan sus propios nombres de host.

1. Primero crea la plantilla del balanceador de cargas:

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

   Los grupos de instancias administrados (MIG) te permiten operar apps en varias VMs idénticas. Puedes hacer que tus cargas de trabajo sean escalables y tengan alta disponibilidad gracias a los servicios de MIG automatizados, que incluyen el escalado automático, la reparación automática, la implementación regional (en varias zonas) y la actualización automática.

2. Crea un grupo de instancias administrado basado en la plantilla:

   ```bash
   gcloud compute instance-groups managed create lb-backend-group \
   --template=lb-backend-template --size=2 --zone=Zone
   ```

3. Crea la regla de firewall `fw-allow-health-check`:

   ```bash
   gcloud compute firewall-rules create fw-allow-health-check \
    --network=default \
    --action=allow \
    --direction=ingress \
    --source-ranges=130.211.0.0/22,35.191.0.0/16 \
    --target-tags=allow-health-check \
    --rules=tcp:80
   ```

   > [!NOTE]
   > Nota: La regla de entrada permite el tráfico de los sistemas de verificación de estado de Google Cloud (130.211.0.0/22 y 35.191.0.0/16). En este lab, se utiliza la etiqueta de destino allow-health-check para identificar las VMs.

4. Ahora que las instancias están en funcionamiento, configura una dirección IP externa, estática y global que usarán tus clientes para llegar al balanceador de cargas:

   ```bash
   gcloud compute addresses create lb-ipv4-1 \
    --ip-version=IPV4 \
    --global
   ```

   Ten en cuenta la dirección IPv4 que estaba reservada:

   ```bash
   gcloud compute addresses describe lb-ipv4-1 \
    --format="get(address)" \
    --global
   ```

   > [!NOTE]
   > Nota: Guarda esta dirección IP, ya que deberás consultarla más adelante en este lab.

5. Crea una verificación de estado para el balanceador de cargas (con esto garantizarás que solo se envíe tráfico a los backends en buen estado):

   ```bash
   gcloud compute health-checks create http http-basic-check \
    --port 80
   ```

6. Crea un servicio de backend:

   ```bash
   gcloud compute backend-services create web-backend-service \
    --protocol=HTTP \
    --port-name=http \
    --health-checks=http-basic-check \
    --global
   ```

7. Agrega tu grupo de instancias como backend al servicio de backend:

   ```bash
   gcloud compute backend-services add-backend web-backend-service \
    --instance-group=lb-backend-group \
    --instance-group-zone=Zone \
    --global
   ```

8. Crea un [mapa de URLs](mapa de URLs) para enrutar las solicitudes entrantes al servicio de backend predeterminado:

   ```bash
   gcloud compute url-maps create web-map-http \
    --default-service web-backend-service
   ```

   > [!NOTE]
   > Nota: Un mapa de URLs es un recurso de configuración de Google Cloud que se usa para enrutar las solicitudes a servicios de backend o buckets de backend. Por ejemplo, con un balanceador de cargas de aplicaciones externo, puedes usar un solo mapa de URLs para enrutar solicitudes a diferentes destinos según las reglas configuradas en aquel mapa:
   >
   > Las solicitudes de https://example.com/video se enrutan a un solo servicio de backend.
   > Las solicitudes de https://example.com/audio se envían a un servicio de backend diferente.
   > Las solicitudes de https://example.com/images se enrutan a un bucket de backend de Cloud Storage.
   > Las solicitudes de cualquier otra combinación de host y ruta de acceso se envían a un servicio de backend predeterminado.

9. Crea un [Proxy HTTP de destino](https://cloud.google.com/load-balancing/docs/target-proxies) para enrutar las solicitudes a tu mapa de URLs.

   ```bash
   gcloud compute target-http-proxies create http-lb-proxy \
   --url-map web-map-http
   ```

10. Crea una [regla de reenvío global](https://cloud.google.com/load-balancing/docs/forwarding-rule-concepts) para enrutar las solicitudes entrantes al proxy:

```bash
gcloud compute forwarding-rules create http-content-rule \
--address=lb-ipv4-1\
--global \
--target-http-proxy=http-lb-proxy \
--ports=80
```

> [!NOTE]
>
> Nota: Una [regla de reenvío](https://cloud.google.com/load-balancing/docs/using-forwarding-rules) y su dirección IP correspondiente representan la configuración del frontend de un balanceador de cargas de Google Cloud. Consulta la guía de [Descripción general sobre las reglas de reenvío](https://cloud.google.com/load-balancing/docs/forwarding-rule-concepts) para obtener más información acerca de los conceptos básicos.

### Tarea 4: Prueba el tráfico enviado a las instancias

1. En el campo Buscar de la consola de Google Cloud, escribe **Balanceo de cargas** y, luego, elige **Balanceo de cargas** en los resultados de la búsqueda.

2. Haz clic en el balanceador de cargas que acabas de crear, `web-map-http`.

3. En la sección **Backend**, haz clic en el nombre del backend y confirma que las VMs estén **En buen estado**. De lo contrario, espera unos minutos y vuelve a cargar la página.

4. Cuando las VMs estén en buen estado, prueba el balanceador de cargas en un navegador web. Ve a http://IP_ADDRESS/ (reemplaza IP_ADDRESS por la dirección IP del balanceador de cargas que copiaste anteriormente).

> [!NOTE]
> Nota: Esto puede tardar de tres a cinco minutos. Si no te conectas, espera un minuto y, luego, vuelve a cargar el navegador.

El navegador debe mostrar una página con contenido que indique el nombre de la instancia que entregó la página, junto con su zona (por ejemplo, Page served from: lb-backend-group-xxxx).
