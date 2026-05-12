#!/bin/bash

# Este script automatiza la configuración del laboratorio "Configura balanceadores de cargas de red".
# Asegúrate de haber definido las variables de entorno REGION y ZONE antes de ejecutar.
# Ejemplo:
# export REGION="europe-west4"
# export ZONE="europe-west4-b"

echo "Configurando las variables de entorno..."
export REGION="europe-west1"
export ZONE="europe-west1-b"

if [[ -z "$REGION" || "$REGION" == "<colocar region dada en lab>" || -z "$ZONE" || "$ZONE" == "<colocar zona dada en lab>" ]]; then
  echo "Error: Debes configurar correctamente las variables REGION y ZONE en el script antes de continuar."
  exit 1
fi

echo "Configurando la región y zona predeterminadas..."
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE

echo "--- Tarea 1: Creando instancias de servidor www ---"
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
echo "Esperando 60 segundos para que las instancias se inicien..."
sleep 60

echo "creando regla de firewall para permitir la entrada del tráfico externo"
gcloud compute firewall-rules create www-firewall-network-lb \
    --target-tags network-lb-tag --allow tcp:80

echo "Listando las instancias..."
gcloud compute instances list

echo "Verificando la respuesta de cada instancia con curl..."
for i in 1 2 3
do
  IP_ADDRESS=$(gcloud compute instances describe www$i --zone=$ZONE --format="get(networkInterfaces[0].accessConfigs[0].natIP)")
  echo "Probando www$i en http://$IP_ADDRESS ..."
  curl -s http://$IP_ADDRESS
  echo ""
done

echo "--- Tarea 3: Configurando el servicio de balanceo de cargas de red ---"

echo "Creando la dirección IP externa estática..."
gcloud compute addresses create network-lb-ip-1 --region=$REGION

echo "Agregando un recurso de verificación de estado HTTP heredado..."
gcloud compute http-health-checks create basic-check

echo "--- Tarea 4: Crea el grupo de destino y la regla de reenvío ---"

echo "Agregando un grupo de destino..."
gcloud compute target-pools create www-pool \
  --region=$REGION --http-health-check basic-check

echo "Agregando las instancias al grupo de destino..."
gcloud compute target-pools add-instances www-pool \
  --instances www1,www2,www3 \
  --instances-zone=$ZONE

echo "Agregando una pausa para que el balanceador de carga pueda verificar la salud de las instancias..."
sleep 30

echo "Agregando la regla de reenvío..."
gcloud compute forwarding-rules create www-rule \
  --region=$REGION \
  --ports 80 \
  --address network-lb-ip-1 \
  --target-pool www-pool

echo "Esperando 15 segundos para que la regla de reenvío se inicien..."
sleep 15

echo "--- Tarea 5: Envía tráfico a tus instancias ---"
echo "Obteniendo la dirección IP externa de la regla de reenvío www-rule..."
IPADDRESS=$(gcloud compute forwarding-rules describe www-rule --region=$REGION --format="get(IPAddress)")
echo "IP obtenida: $IPADDRESS"

echo "Enviando tráfico a $IPADDRESS por 30 segundos..."
timeout 30 bash -c "while true; do curl -m1 $IPADDRESS; done"
echo "Prueba de tráfico finalizada con éxito."
