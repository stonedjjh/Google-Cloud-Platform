#!/bin/bash

# Este script automatiza la configuración del laboratorio "Configura balanceadores de cargas de aplicaciones".
# GSP155
# Asegúrate de haber definido las variables de entorno REGION y ZONE antes de ejecutar.
# Ejemplo:
# export REGION="europe-west4"
# export ZONE="europe-west4-b"

echo "Configurando las variables de entorno..."
echo
export REGION="<ingresa la region del lab>"
export ZONE="<ingresa la zona del lab>"

if [[ -z "$REGION" || "$REGION" == "<colocar region dada en lab>" || -z "$ZONE" || "$ZONE" == "<colocar zona dada en lab>" ]]; then
  echo "Error: Debes configurar correctamente las variables REGION y ZONE en el script antes de continuar."
  exit 1
fi

echo "Configurando la región y zona predeterminadas..."
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE
echo

echo "--- Tarea 1: Creando instancias de servidor www ---"
echo
for i in 1 2 3
do
  gcloud compute instances create www$i \
    --zone=$ZONE \
    --tags=network-lb-tag \
    --machine-type=e2-small \
    --image-family=debian-11 \
    --image-project=debian-cloud \
    --metadata=startup-script='#!/bin/bash 
    apt-get update
    apt-get install apache2 -y
    service apache2 restart
    echo "
    <h3>Web Server: www'$i'
    </h3>" | tee /var/www/html/index.html'
done
echo
echo "Esperando 60 segundos para que las instancias se inicien..."
sleep 60
echo

echo "creando regla de firewall para permitir la entrada del tráfico externo"
gcloud compute firewall-rules create www-firewall-network-lb \
    --target-tags network-lb-tag --allow tcp:80
echo

echo "Listando las instancias..."
gcloud compute instances list
echo

echo "Verificando la respuesta de cada instancia con curl..."
for i in 1 2 3
do
  IP_ADDRESS=$(gcloud compute instances describe www$i --zone=$ZONE --format="get(networkInterfaces[0].accessConfigs[0].natIP)")
  echo "Probando www$i en http://$IP_ADDRESS ..."
  curl -s http://$IP_ADDRESS
  echo ""
done
echo

echo "--- Tarea 3: Crea un balanceador de cargas de aplicaciones ---"
echo

echo "Paso 1 creando la plantilla del balanceador de cargas"

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
echo

echo "Paso 2 creando  un grupo de instancias administrado basado en la plantilla"

gcloud compute instance-groups managed create lb-backend-group \
   --template=lb-backend-template --size=2 --zone=$ZONE
echo

echo "Paso 3 creando la regla de firewall fw-allow-health-check"

gcloud compute firewall-rules create fw-allow-health-check \
  --network=default \
  --action=allow \
  --direction=ingress \
  --source-ranges=130.211.0.0/22,35.191.0.0/16 \
  --target-tags=allow-health-check \
  --rules=tcp:80

echo
echo "Paso 4 creando una dirección IP externa"
echo

gcloud compute addresses create lb-ipv4-1 \
  --ip-version=IPV4 \
  --global

echo
echo "Paso 5 Crea una verificación de estado para el balanceador de cargas"
echo

gcloud compute health-checks create http http-basic-check \
  --port 80

echo
echo "Paso 6 creando un servicio de backend para el balanceador de cargas"  
echo

gcloud compute backend-services create web-backend-service \
  --protocol=HTTP \
  --port-name=http \
  --health-checks=http-basic-check \
  --global

echo
echo "Paso 7 Agrega tu grupo de instancias como backend al servicio de backend"
echo

gcloud compute backend-services add-backend web-backend-service \
  --instance-group=lb-backend-group \
  --instance-group-zone=$ZONE \
  --global

echo
echo "Paso 8 crea un mapa de URL para el balanceador de cargas"
echo

gcloud compute url-maps create web-map-http \
    --default-service web-backend-service

echo
echo "Paso 9 Crea un Proxy HTTP de destino para enrutar las solicitudes a tu mapa de URLs."   
echo

gcloud compute target-http-proxies create http-lb-proxy \
    --url-map web-map-http

echo
echo "Paso 10 Crea una regla de reenvío global para enrutar las solicitudes entrantes al proxy"
echo

gcloud compute forwarding-rules create http-content-rule \
   --address=lb-ipv4-1 \
   --global \
   --target-http-proxy=http-lb-proxy \
   --ports=80

echo
echo "--- Tarea 4: Prueba el tráfico enviado a las instancias ---"
echo

echo
echo "Obteniendo la IP del balanceador de cargas..."
echo
LB_IP=$(gcloud compute addresses describe lb-ipv4-1 --global --format='get(address)')
echo "IP del load balancer: $LB_IP"
echo

echo "Esperando a que los backends estén saludables..."
echo
for attempt in {1..30}; do
  HEALTH_STATUS=$(gcloud compute backend-services get-health web-backend-service --global --format="value(status.healthStatus[].healthState)" | tr '\n' ' ')
  echo "Intento $attempt: $HEALTH_STATUS"
  HEALTHY_COUNT=$(echo "$HEALTH_STATUS" | grep -o "HEALTHY" | wc -l)
  if [[ $HEALTHY_COUNT -ge 2 ]]; then
    echo "Los backends están saludables."
    break
  fi
  sleep 10
  if [[ $attempt -eq 30 ]]; then
    echo "Advertencia: los backends no alcanzaron estado HEALTHY después de 5 minutos."
  fi
done

echo "Probando el balanceador de cargas en http://$LB_IP/ (10 veces para verificar el balanceo de carga)"
echo
for i in {1..10}; do
  echo "Prueba $i:"
  curl -sS "http://$LB_IP/" | sed -n '1,20p'
  echo ""
done

  