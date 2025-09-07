## Situación del desafío

Eres un ingeniero de nube junior en un equipo de colegas que deben proporcionar funcionalidad de red a las instancias de máquinas virtuales (VMs) de Compute Engine en una red de nube privada virtual (VPC) de Google Cloud.

Como no puedes crear instancias de VM, contenedores ni aplicaciones de App Engine sin una red de VPC, cada proyecto de Google Cloud tiene una red predeterminada que ya se configuró para que puedas comenzar.

Para admitir el balanceo de cargas del tráfico de red, debes conocer la diferencia entre un balanceador de cargas de red y un balanceador de cargas HTTP, y cómo configurar ambos para las aplicaciones que se ejecutan en VMs de Compute Engine.

Se espera que tengas las habilidades y el conocimiento necesarios para completar las tareas que se indican a continuación.

### Tu desafío

En este lab, se te pide que crees una red de VPC de modo automático con reglas de firewall y tres instancias de VM. Luego, debes configurar el balanceo de cargas para explorar la conectividad de las instancias de VM.

Deberás hacer lo siguiente:

-   Crear varias instancias de servidor web con reglas de firewall
    
-   Configurar un servicio de balanceo de cargas
    
-   Crear un balanceador de cargas HTTP
    

Estos son algunos estándares que debes seguir:

-   Crea todos los recursos en la Region región y en la Zone zona, a menos que se indique lo contrario.
    

A continuación, se describe cada tarea en detalle. ¡Buena suerte!

**configurar el entorno**

```bash
export REGION=<colocar region dada en lab>

export ZONE=<colocar zona dada en lab>

gcloud config set compute/region $REGION

gcloud config set compute/zone $ZONE
```

## Tarea 1: Crea varias instancias de servidor web

Para esta tarea, debes crear tres instancias de VM de Compute Engine con la configuración que se indica, instalar Apache en ellas y, luego, agregar una regla de firewall que permita que el tráfico HTTP llegue a ellas.

Nota: Asegúrate de que todas las instancias estén en la red predeterminada.

1.  Configura los siguientes valores y deja el resto con sus parámetros predeterminados:
    
| Propiedad | Valor (escribe el valor o selecciona la opción como se especifica) |
|--|--|
| Instancia de VM 1 | **web1** |
| Instancia de VM 2 | **web2** |
| Instancia de VM 3 | **web3** |
| Región | Dada al momento de iniciar el lab |
| Serie| E2 |
| Tipo de máquina| e2-small |
| Etiquetas| network-lb-tag |
| image-family| debian-11 |
| image-project| debian-cloud |
____

2.  Usa la siguiente secuencia de comandos para instalar Apache en cada servidor (actualiza web para que coincida con el nombre de la VM):

```bash
'#!/bin/bash
apt-get update
apt-get install apache2 -y
service apache2 restart
echo "
<h3>Web Server: web<num></num>
</h3>" | tee /var/www/html/index.html
```

> Nota: Puedes verificar que cada instancia se esté ejecutando con curl
> (reemplaza [IP_ADDRESS] por la dirección IP de cada VM):

## Solución:
creamos las instancias([referencia](https://cloud.google.com/sdk/gcloud/reference/compute/instances/create))
```bash
for i in 1 2 3
do
	gcloud compute instances create web$i \
	--zone=$ZONE \
	--tags=network-lb-tag \
	--machine-type=e2-small \
	--image-family=debian-11 \
	--image-project=debian-cloud \
	--metadata=startup-script='#!/bin/bash apt-get update apt-get install apache2 -y service apache2 restart echo "<h3>Web Server: web'$i'</h3>" | tee /var/www/html/index.html'
done
```
  
Ahora creamos la regla del firewall para permitir el acceso http

```bash
gcloud compute firewall-rules create www-firewall-network-lb \
--target-tags network-lb-tag --allow tcp:80
```  

##   

## Tarea 2: Configura el servicio de balanceo de cargas

Para esta tarea, debes crear los recursos que admiten el servicio de balanceo de cargas.

1.  Configura los siguientes valores y deja el resto con sus parámetros predeterminados:

|Propiedad|Valor (escribe el valor o selecciona la opción como se especifica)|
|--|--|
|IP externa estática|network-lb-ip-1|
|Grupo de destino|www-pool|
|Puertos|80|

2.  Una vez que se configure el servicio de balanceo de cargas, comienza a enviar tráfico a la regla de reenvío y observa cómo se dispersa el tráfico a las diferentes instancias.
    

Solución:

Configura el servicio de balanceo de cargas([referencia](https://cloud.google.com/load-balancing/docs/network/setting-up-network?hl=es-419#gcloud_3))

 1. Crea una dirección [IP externa estática](https://cloud.google.com/sdk/gcloud/reference/compute/addresses/create) para tu balanceador de cargas.
 ``` bash
 gcloud compute addresses create network-lb-ip-1 \
--region=$REGION
```
 2. Agrega un recurso de verificación de estado HTTP heredado
 ```bash
 gcloud compute http-health-checks create mi-chequeo-http
 ```
 
 3. Agrega un grupo de destino
 ```bash
 gcloud compute target-pools create www-pool \
--region=$REGION --http-health-check mi-chequeo-http
 ```
 
 4. Agrega tus instancias al grupo de destino.
 ``` bash
 gcloud compute target-pools add-instances www-pool \
--instances web1,web2,web3 \
--instances-zone=$ZONE
 ```
 
 5. Agrega una regla de reenvío
 ```bash
 gcloud compute forwarding-rules create www-rule \
 --region=$REGION \
 --ports 80 \
 --address network-lb-ip-1 \
 --target-pool www-pool
 ```


Probar el balanceador de carga

```bash
ip_ingreso=$(gcloud compute forwarding-rules describe www-rule --region=$REGION --format="get(IPAddress)")
while true; do curl -m1 $ip_ingreso; done
```
> Nota: Este comando se ejecutará en un bucle infinito para probar la rotación de tráfico. Presiona Control + C después de 30 segundos para salir.

## Tarea 3: Crea un balanceador de cargas HTTP

Para esta tarea, debes crear recursos para el balanceador de cargas HTTP.

1.  Establece los valores de la siguiente manera y deja el resto con sus parámetros de configuración predeterminados:
    
| Propiedad | Valor (escribe el valor o selecciona la opción como se especifica) |
|--|--|
| Plantilla de backend | lb-backend-template |
| etiquetas | allow-health-check |
| Grupo de instancias administrado | lb-backend-group |
| machine-type | e2-medium |
| image-family e image-project | igual que las VMs creadas anteriormente |
| fw-allow-health-check |fw-allow-health-check  |
| Permitir source-ranges | 130.211.0.0/22, 35.191.0.0/16 |
| Tráfico | ingress |
| Puerto | 80 |
| dirección IP externa | lb-ipv4-1 |
| verificación de estado | http-basic-check |
| Mapa de URL | web-map-http |
| Proxy HTTP de destino | http-lb-proxy |

    
3.  Crear un balanceador de cargas HTTP
    

### Prueba el tráfico enviado a las instancias

1.  En el menú de navegación de la consola, ve a Servicios de red > Balanceo de cargas.
    
2.  Haz clic en el balanceador de cargas que acabas de crear (web-map-http).
    
3.  Para verificar que las VMs estén disponibles, prueba el balanceador de cargas con un navegador web. Navega a http://<i>[IP_ADDRESS]</i>/ y reemplaza <i>[IP_ADDRESS]</i> por la dirección IP del balanceador de cargas (por ejemplo, 35.241.29.40).
    

Nota: Esto puede tardar de tres a cinco minutos.

Si no te conectas, espera unos minutos y, luego, vuelve a cargar el navegador.

El navegador debe renderizar una página con contenido que muestre el nombre de la instancia que entregó la página (por ejemplo, Page served from: lb-backend-group-xxxx).

Solución: 
Configura un balanceador de cargas de aplicaciones externo global con backends de grupos de instancias de VM([referencia](https://cloud.google.com/load-balancing/docs/https/setup-global-ext-https-compute?hl=es-419))

 1. crea la plantilla del balanceador de cargas:
```shell
gcloud compute instance-templates create lb-backend-template \
--region=$REGION \
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
    
 2.  Crea el grupo de instancias administrado y selecciona la plantilla de instancias.
 ```bash
gcloud compute instance-groups managed create lb-backend-group \
--template=lb-backend-template --size=2 --zone=$ZONE
 ```
 
 3. Agrega un puerto con nombre al grupo de instancias
 ```
 gcloud compute instance-groups set-named-ports lb-backend-group \
 --named-ports http:80 \
 --zone=$ZONE
 ```
 
 4. Configura una regla de firewall
```
gcloud compute firewall-rules create fw-allow-health-check \
--network=default \
--action=allow \
--direction=ingress \
--source-ranges=130.211.0.0/22,35.191.0.0/16 \
--target-tags=allow-health-check \
--rules=tcp:80
```

> Observación: como no tenemos una red definida ni creamos una, con default asume la red predeterminada.

5. Reservar una dirección IP externa
```
gcloud compute addresses create lb-ipv4-1 \
--ip-version=IPV4 \
--network-tier=PREMIUM \
--global

ip_reservada_premium=$(gcloud compute addresses describe lb-ipv4-1 \
--format="get(address)" --global)
```
## Configura el balanceador de cargas
6.  Crea una verificación de estado
```
gcloud compute health-checks create http http-basic-check \
--port 80
```
7. Crea un servicio de backend.
```
gcloud compute backend-services create web-backend-service \
  --protocol=HTTP \
  --port-name=http \
  --health-checks=http-basic-check \
  --global
```
8. Agrega tu grupo de instancias como backend al servicio de backend:
```
gcloud compute backend-services add-backend web-backend-service \
  --instance-group=lb-backend-group \
  --instance-group-zone=$ZONE \
  --global
```
9. Crea un [mapa de URLs](https://cloud.google.com/load-balancing/docs/url-map-concepts) para enrutar las solicitudes entrantes al servicio de backend predeterminado
```
gcloud compute url-maps create web-map-http \
    --default-service web-backend-service
``` 
## **Configura un frontend de HTTP**
10. En el caso de HTTP, crea un proxy HTTP de destino para enrutar las solicitudes a tu mapa de URL.
```
gcloud compute target-http-proxies create http-lb-proxy \
--url-map web-map-http
```
11. Crea una  [regla de reenvío global](https://cloud.google.com/load-balancing/docs/forwarding-rule-concepts)  para enrutar las solicitudes entrantes al proxy:
```
gcloud compute forwarding-rules create http-content-rule \
--address=lb-ipv4-1\
--global \
--target-http-proxy=http-lb-proxy \
--ports=80
   ```

### Prueba el tráfico enviado a las instancias

1.  En el  **menú de navegación**  de la consola, ve a  **Servicios de red > Balanceo de cargas**.
    
2.  Haz clic en el balanceador de cargas que acabas de crear (`web-map-http`).
    
3.  Para verificar que las VMs estén disponibles, prueba el balanceador de cargas con un navegador web. Navega a  `http://<i>[IP_ADDRESS]</i>/`  y reemplaza  `<i>[IP_ADDRESS]</i>`  por la dirección IP del balanceador de cargas (por ejemplo,  `35.241.29.40`).

### Prueba el balanceador de carga
Para probar que el balanceador de carga está funcionando correctamente y que las instancias están sirviendo tráfico, puedes ejecutar el siguiente comando en Cloud Shell. La salida mostrará el nombre de la instancia que respondió a la solicitud.

```bash
curl http://$(echo $ip_reservada_premium)
```
