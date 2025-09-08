#!/bin/bash

# Este script automatiza la configuración del laboratorio "Implementa el balanceo de cargas en Compute Engine".
# Asegúrate de haber definido las variables de entorno REGION y ZONE antes de ejecutar.
# Ejemplo:
# export REGION="europe-west4"
# export ZONE="europe-west4-b"

echo "Configurando las variables de entorno..."
export REGION="<colocar region dada en lab>"
export ZONE="<colocar zona dada en lab>"

echo "Configurando la región y zona predeterminadas..."
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE

echo "--- Tarea 1: Creando instancias de servidor web ---"
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

echo "Creando la regla de firewall para el balanceador de carga de red..."
gcloud compute firewall-rules create www-firewall-network-lb \
  --target-tags network-lb-tag --allow tcp:80

echo "--- Tarea 2: Configurando el servicio de balanceo de cargas de red ---"
echo "Creando la dirección IP externa estática..."
gcloud compute addresses create network-lb-ip-1 --region=$REGION

echo "Agregando un recurso de verificación de estado HTTP heredado..."
gcloud compute http-health-checks create mi-chequeo-http

echo "Agregando un grupo de destino..."
gcloud compute target-pools create www-pool \
  --region=$REGION --http-health-check mi-chequeo-http

echo "Agregando las instancias al grupo de destino..."
gcloud compute target-pools add-instances www-pool \
  --instances web1,web2,web3 \
  --instances-zone=$ZONE

echo "Agregando la regla de reenvío..."
gcloud compute forwarding-rules create www-rule \
  --region=$REGION \
  --ports 80 \
  --address network-lb-ip-1 \
  --target-pool www-pool

echo "--- Tarea 3: Creando un balanceador de cargas HTTP ---"
echo "Creando la plantilla de la instancia..."
gcloud compute instance-templates create lb-backend-template \
  --region=$REGION \
  --network=default \
  --subnet=default \
  --tags=allow-health-check \
  --machine-type=e2-medium \
  --image-family=debian-11 \
  --image-project=debian-cloud \
  --metadata=startup-script='#!/bin/bash apt-get update apt-get install apache2 -y a2ensite default-ssl a2enmod ssl vm_hostname="$(curl -H "Metadata-Flavor:Google" http://169.254.169.254/computeMetadata/v1/instance/name)" echo "Page served from: $vm_hostname" | tee /var/www/html/index.html systemctl restart apache2'

echo "Creando el grupo de instancias administrado..."
gcloud compute instance-groups managed create lb-backend-group \
  --template=lb-backend-template --size=2 --zone=$ZONE

echo "Agregando un puerto con nombre al grupo de instancias..."
gcloud compute instance-groups set-named-ports lb-backend-group \
  --named-ports http:80 \
  --zone=$ZONE

echo "Configurando una regla de firewall para la verificación de estado..."
gcloud compute firewall-rules create fw-allow-health-check \
  --network=default \
  --action=allow \
  --direction=ingress \
  --source-ranges=130.211.0.0/22,35.191.0.0/16 \
  --target-tags=allow-health-check \
  --rules=tcp:80

echo "Reservando una dirección IP externa..."
gcloud compute addresses create lb-ipv4-1 \
  --ip-version=IPV4 \
  --network-tier=PREMIUM \
  --global

echo "Creando la verificación de estado HTTP..."
gcloud compute health-checks create http http-basic-check --port 80

echo "Creando un servicio de backend..."
gcloud compute backend-services create web-backend-service \
  --protocol=HTTP \
  --port-name=http \
  --health-checks=http-basic-check \
  --global

echo "Agregando el grupo de instancias como backend..."
gcloud compute backend-services add-backend web-backend-service \
  --instance-group=lb-backend-group \
  --instance-group-zone=$ZONE \
  --global

echo "Creando el mapa de URLs..."
gcloud compute url-maps create web-map-http \
  --default-service web-backend-service

echo "Creando el proxy HTTP de destino..."
gcloud compute target-http-proxies create http-lb-proxy \
  --url-map web-map-http

echo "Creando la regla de reenvío global..."
gcloud compute forwarding-rules create http-content-rule \
  --address=lb-ipv4-1 \
  --global \
  --target-http-proxy=http-lb-proxy \
  --ports=80

echo "Script completado."
