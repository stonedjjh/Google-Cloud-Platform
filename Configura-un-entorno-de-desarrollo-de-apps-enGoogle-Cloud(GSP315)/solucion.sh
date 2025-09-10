#!/bin/bash

# --- IMPORTANTE: CONFIGURACIÓN INICIAL ---
# Antes de ejecutar este script, actualiza las siguientes variables con los valores de tu laboratorio.
# ------------------------------------------------------------------------------------------------

export REGION=<ingresa la region del lab>
export ZONE=<ingresa la zona del lab>
export MI_TEMA=<ingresa el nombre del topico dado en el lab>
export MI_NOMBRE_FUNCION=<ingresa el nombre de la funcion dado en el lab>
export INGENIERO2=<ingresa el email del usaurio 2 dado en el lab>

# --- Fin de la configuración ---
# ------------------------------------------------------------------------------------------------

# Este script automatiza el lab de desafío GSP315: "Configura un entorno de desarrollo de apps en Google Cloud".

# Configuración del proyecto y variables de entorno
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE
export PROJECT_ID=$(gcloud config list --format="value(core.project)")
export NUMERO_PROJECT=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")
export MI_BUCKET=$PROJECT_ID-bucket

# Habilitar APIs
echo "Habilitando APIs requeridas... puede tomar un par de minutos."
gcloud services enable \
    run.googleapis.com \
    storage-component.googleapis.com \
    pubsub.googleapis.com \
    cloudbuild.googleapis.com \
    eventarc.googleapis.com
sleep 60
echo "APIs habilitadas."

# --- Tarea 1: Crea un bucket ---
echo "Creando bucket: $MI_BUCKET en la región: $REGION"
gcloud storage buckets create gs://$MI_BUCKET --location=$REGION

# --- Tarea 2: Crea un tema de Pub/Sub ---
echo "Creando tema de Pub/Sub: $MI_TEMA"
gcloud pubsub topics create $MI_TEMA

# --- Tarea 3: Crea la Cloud Run Function de la miniatura ---

# Crear el directorio para el código
echo "Creando directorio para la función..."
mkdir gcf && cd gcf

# Crear el archivo index.js usando cat y un heredoc para mantener el formato
echo "Creando archivo index.js..."
cat > index.js << EOF
const functions = require('@google-cloud/functions-framework');
const { Storage } = require('@google-cloud/storage');
const { PubSub } = require('@google-cloud/pubsub');
const sharp = require('sharp');

functions.cloudEvent('$MI_NOMBRE_FUNCION', async cloudEvent => {
  const event = cloudEvent.data;

  console.log(\`Event: \${JSON.stringify(event)}\`);
  console.log(\`Hello \${event.bucket}\`);

  const fileName = event.name;
  const bucketName = event.bucket;
  const size = "64x64";
  const bucket = new Storage().bucket(bucketName);
  const topicName = "$MI_TEMA";
  const pubsub = new PubSub();

  if (fileName.search("64x64_thumbnail") === -1) {
    const filename_split = fileName.split('.');
    const filename_ext = filename_split[filename_split.length - 1].toLowerCase();
    const filename_without_ext = fileName.substring(0, fileName.length - filename_ext.length - 1);

    if (filename_ext === 'png' || filename_ext === 'jpg' || filename_ext === 'jpeg') {
      console.log(\`Processing Original: gs://\${bucketName}/\${fileName}\`);
      const gcsObject = bucket.file(fileName);
      const newFilename = \`\${filename_without_ext}_64x64_thumbnail.\${filename_ext}\`;
      const gcsNewObject = bucket.file(newFilename);

      try {
        const [buffer] = await gcsObject.download();
        const resizedBuffer = await sharp(buffer)
          .resize(64, 64, {
            fit: 'inside',
            withoutEnlargement: true,
          })
          .toFormat(filename_ext)
          .toBuffer();

        await gcsNewObject.save(resizedBuffer, {
          metadata: {
            contentType: \`image/\${filename_ext}\`,
          },
        });

        console.log(\`Success: \${fileName} → \${newFilename}\`);

        await pubsub
          .topic(topicName)
          .publishMessage({ data: Buffer.from(newFilename) });

        console.log(\`Message published to \${topicName}\`);
      } catch (err) {
        console.error(\`Error: \${err}\`);
      }
    } else {
      console.log(\`gs://\${bucketName}/\${fileName} is not an image I can handle\`);
    }
  } else {
    console.log(\`gs://\${bucketName}/\${fileName} already has a thumbnail\`);
  }
});
EOF

# Crear el archivo package.json
echo "Creando archivo package.json..."
cat > package.json << EOF
{
  "name": "thumbnails",
  "version": "1.0.0",
  "description": "Create Thumbnail of uploaded image",
  "scripts": {
    "start": "node index.js"
  },
  "dependencies": {
    "@google-cloud/functions-framework": "^3.0.0",
    "@google-cloud/pubsub": "^2.0.0",
    "@google-cloud/storage": "^6.11.0",
    "sharp": "^0.32.1"
  },
  "devDependencies": {},
  "engines": {
    "node": ">=4.3.2"
  }
}
EOF

# Instalar las dependencias
echo "Instalando dependencias de Node.js..."
npm install

# Volver al directorio padre para el despliegue
cd ..

# --- Permisos de Pub/Sub para que la función publique ---
echo "Otorgando permisos de Pub/Sub a las cuentas de servicio..."
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:service-$NUMERO_PROJECT@gcp-sa-pubsub.iam.gserviceaccount.com" \
    --role='roles/pubsub.publisher'

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$NUMERO_PROJECT@cloudservices.gserviceaccount.com" \
    --role='roles/pubsub.publisher'

echo "Permisos otorgados. Esperando 60 segundos para que los cambios de IAM se propaguen..."    
sleep 60

# Desplegar la función con reintentos
echo "Iniciando el despliegue de la función de Cloud Run. Esto puede tomar varios minutos."
for i in {1..3}; do
  echo "Intento $i de 3..."
  # Otorgar permisos antes de cada intento de despliegue
  gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:service-$NUMERO_PROJECT@gs-project-accounts.iam.gserviceaccount.com" \
    --role='roles/iam.serviceAccountUser' \
    --role='roles/pubsub.publisher'

  gcloud functions deploy $MI_NOMBRE_FUNCION \
    --gen2 \
    --runtime=nodejs22 \
    --region=$REGION \
    --source=gcf \
    --entry-point=$MI_NOMBRE_FUNCION \
    --trigger-bucket=$MI_BUCKET \
    --allow-unauthenticated

  if [ $? -eq 0 ]; then
    echo "✅ Despliegue de la función exitoso."
    break
  else
    echo "❌ Error en el despliegue. Esperando 45 segundos antes de reintentar..."
    sleep 45
  fi
done

# Verificar si el despliegue tuvo éxito después de los 3 intentos
if [ $? -ne 0 ]; then
  echo "❌ El despliegue de la función falló después de 3 intentos. Por favor, revisa la consola para más detalles."
  exit 1
fi

# Subir la imagen de prueba para activar la función
echo "Subiendo imagen de prueba para verificar la función..."
wget https://storage.googleapis.com/cloud-training/gsp315/map.jpg
gsutil cp map.jpg gs://$MI_BUCKET/map.jpg

# --- Tarea 4: Quita al anterior ingeniero de servicios de nube ---
echo "Eliminando acceso del antiguo ingeniero..."
gcloud projects remove-iam-policy-binding $PROJECT_ID \
    --member="user:$INGENIERO2" \
    --role='roles/viewer'

echo "Script completado. ¡El laboratorio ha sido automatizado con éxito!"
