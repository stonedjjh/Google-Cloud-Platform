# Configura un entorno de desarrollo de apps en Google Cloud: Lab de desafío

Es posible que este lab incorpore herramientas de IA para facilitar tu aprendizaje.

GSP315

Logotipo de los labs de autoaprendizaje de Google Cloud

## Introducción

En un lab de desafío, se le proporcionarán una situación y un conjunto de tareas. En lugar de seguir instrucciones paso a paso, deberás utilizar las habilidades aprendidas en los labs del curso para decidir cómo completar las tareas por tu cuenta. Un sistema automatizado de puntuación (en esta página) mostrará comentarios y determinará si completaste tus tareas correctamente.

En un lab de desafío, no se explican conceptos nuevos de Google Cloud, sino que se espera que amplíes las habilidades que adquiriste, como cambiar los valores predeterminados y leer o investigar los mensajes de error para corregir sus propios errores.

Debe completar correctamente todas las tareas dentro del período establecido para obtener una puntuación del 100%.

Se recomienda este lab a los estudiantes inscritos en el curso para obtener la insignia de habilidad Configura un entorno de desarrollo de apps en Google Cloud. ¿Aceptas el desafío?

## Situación del desafío

Recién comienzas a desempeñarte en tu rol como ingeniero júnior de servicios de nube para Jooli Inc. Hasta ahora, estuviste ayudando a los equipos a crear y administrar recursos de Google Cloud.

Se espera que tengas las habilidades y el conocimiento para realizar estas tareas, por lo que no recibirás guías paso a paso.

Tu desafío
Se te solicitó ayudar a un equipo de desarrollo recién formado con el trabajo inicial de un nuevo proyecto llamado Recuerdos, que consiste en almacenar y organizar fotos. Se te solicitó que ayudes al equipo de Recuerdos con la configuración inicial de su entorno de desarrollo de aplicaciones.

Recibiste una solicitud para completar estas tareas:

1. Crear un bucket para almacenar fotos
2. Crear un tema de Pub/Sub para que lo utilice la Cloud Run Function que generes
3. Crear una Cloud Run Function
4. Quitar el acceso del anterior ingeniero de servicios de nube para que ya no pueda ingresar al proyecto Recuerdos

Estas son algunas pautas de Jooli Inc. que debes seguir:

- Crea todos los recursos en la región REGION y en la zona ZONE, a menos que se indique lo contrario.
- Usa las VPC del proyecto.
- Normalmente, la asignación de nombres se realiza de la siguiente manera: equipo-recurso; p. ej., una instancia podría llamarse kraken-webserver1
- Asigna tamaños de recursos rentables. Ten cuidado porque los proyectos se supervisan y el uso excesivo de recursos dará como resultado la finalización del proyecto que los contiene, es decir, posiblemente el tuyo. Esta es la orientación que el equipo de supervisión está dispuesto a compartir; a menos que se indique lo contrario, utiliza e2-micro para VMs pequeñas de Linux y e2-medium para Windows o alguna otra aplicación, como nodos de Kubernetes.

A continuación, se describe cada tarea en detalle. ¡Buena suerte!

```bash
export REGION=<ingresa la region del lab>

export ZONE=<ingresa la zona del lab>

gcloud config set compute/region $REGION

gcloud config set compute/zone $ZONE

export PROJECT_ID=$(gcloud config list --format="value(core.project)")
export numeroProject=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")
export mi_bucket=$PROJECT_ID-bucket
export mi_tema=<ingresa el nombre del topico dado en el lab>
export mi_nombre_funcion=<ingresa el nombre de la funcion dado en el lab>
export ingeniero2=<ingresa el email del usaurio 2 dado en el lab>

gcloud services enable \
    run.googleapis.com \
    storage-component.googleapis.com \
    pubsub.googleapis.com \
    cloudbuild.googleapis.com \
    eventarc.googleapis.com
```

## **Tarea 1: Crea un bucket**

Debes crear un bucket llamado Bucket Name para almacenar las fotos. Asegúrate de que el recurso esté creado en la región REGION y en la zona ZONE.

## Solución:

Creamos el bucket con los requerimientos solicitados([referencia](https://cloud.google.com/sdk/gcloud/reference/storage/buckets))

```bash
gcloud storage buckets create gs://$mi_bucket --location=$REGION
```

## **Tarea 2: Crea un tema de Pub/Sub**

Crea un tema de Pub/Sub llamado Topic Name para que la Cloud Run Function envíe mensajes.

## Solución:

Creamos el PUB/SUB con los requerimientos solicitados([referencia](https://cloud.google.com/pubsub/docs/publish-receive-messages-gcloud?hl=es-419))

```bash
gcloud pubsub topics create $mi_tema
```

## **Tarea 3: Crea la Cloud Run Function de la miniatura**

**_Crea la función_**

Crea una Cloud Run Function Cloud Run Function Name que creará una miniatura a partir de una imagen agregada al bucket Bucket Name.

Asegúrate de que la Cloud Run Function use el entorno Cloud Run Function (que es de 2ª generación). Asegúrate de que el recurso esté creado en la región REGION y en la zona ZONE.

1. Crea una Cloud Run Function (2ª generación) llamada Cloud Run Function Name con Node.js 22.

   > Nota: La Cloud Run Function se debe ejecutar cada vez que se cree un objeto en el bucket que creaste en la Tarea 1. Durante el proceso, la Cloud Run Function puede solicitarte permiso para habilitar APIs o asignar roles a las cuentas de servicio. Habilita cada una de las APIs requeridas y otorga los roles solicitados.

2. Asegúrate de configurar el punto de entrada (la Function que se ejecutará) como Cloud Run Function Name y el activador como Cloud Storage.
3. Agrega el siguiente código a index.js:

```bash
const functions = require('@google-cloud/functions-framework');
const { Storage } = require('@google-cloud/storage');
const { PubSub } = require('@google-cloud/pubsub');
const sharp = require('sharp');

functions.cloudEvent('$mi_nombre_funcion', async cloudEvent => {
  const event = cloudEvent.data;

  console.log(`Event: ${JSON.stringify(event)}`);
  console.log(`Hello ${event.bucket}`);

  const fileName = event.name;
  const bucketName = event.bucket;
  const size = "64x64";
  const bucket = new Storage().bucket(bucketName);
  const topicName = "$mi_tema$";
  const pubsub = new PubSub();

  if (fileName.search("64x64_thumbnail") === -1) {
    // doesn't have a thumbnail, get the filename extension
    const filename_split = fileName.split('.');
    const filename_ext = filename_split[filename_split.length - 1].toLowerCase();
    const filename_without_ext = fileName.substring(0, fileName.length - filename_ext.length - 1); // fix sub string to remove the dot

    if (filename_ext === 'png' || filename_ext === 'jpg' || filename_ext === 'jpeg') {
      // only support png and jpg at this point
      console.log(`Processing Original: gs://${bucketName}/${fileName}`);
      const gcsObject = bucket.file(fileName);
      const newFilename = `${filename_without_ext}_64x64_thumbnail.${filename_ext}`;
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
            contentType: `image/${filename_ext}`,
          },
        });

        console.log(`Success: ${fileName} → ${newFilename}`);

        await pubsub
          .topic(topicName)
          .publishMessage({ data: Buffer.from(newFilename) });

        console.log(`Message published to ${topicName}`);
      } catch (err) {
        console.error(`Error: ${err}`);
      }
    } else {
      console.log(`gs://${bucketName}/${fileName} is not an image I can handle`);
    }
  } else {
    console.log(`gs://${bucketName}/${fileName} already has a thumbnail`);
  }
});
```

4. Agrega el siguiente código a package.json:

```bash
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
```

> Nota: Si se muestra un error de permiso denegado en el que se indica que los permisos necesarios tardarán algunos minutos en propagarse al agente de servicio, espera un momento y vuelve a intentarlo. Asegúrate de tener los roles apropiados (Agente de servicio de Eventarc, Receptor de eventos de Eventarc, Creador de tokens de cuenta de servicio y Publicador de Pub/Sub) asignados a las cuentas de servicio correctas.

### Prueba la función

- Sube una imagen en formato PNG o JPG al bucket Bucket Name.

> Nota: De manera alternativa, descarga esta imagen https://storage.googleapis.com/cloud-training/gsp315/map.jpg en tu máquina y, luego, súbela al bucket.
> Al cabo de unos instantes, aparecerá una imagen de miniatura (selecciona ACTUALIZAR en la página de detalles del bucket).

Después de subir el archivo de imagen, puedes hacer clic para verificar tu progreso a continuación. No es necesario que esperes a que se cree la imagen de miniatura.

> Opcional: Si la función se implementó correctamente y no ves la imagen en miniatura en el bucket, puedes verificar que la pestaña Activadores muestre la información del activador que proporcionaste anteriormente para la función, que podría no haberse guardado de forma correcta si antes encontraste errores. Si no ves el activador de Cloud Storage en la pestaña Activadores de la función, puedes volver a crearlo (consulta la página de documentación titulada Cómo crear un activador para servicios) y, luego, subir un archivo nuevo para volver a realizar la prueba (actualiza la página después de agregar un archivo nuevo).

## Solución:

creamos la funcion con los requerimientos solicitados[referencia](https://cloud.google.com/sdk/gcloud/reference/functions/deploy)

```bash
mkdir gcf && cd gcf
touch index.js
touch package.json
```
aqui debemos abrir el editor de la consola y copiar lo script en sus archivos correspondientes

```bash
npm install

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:service-$numeroProject@gcp-sa-pubsub.iam.gserviceaccount.com" \
    --role='roles/pubsub.publisher'

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$numeroProject@cloudservices.gserviceaccount.com" \
    --role='roles/pubsub.publisher'


# Bucle de reintento para el despliegue de la función 
# Se ejecute 3 veces para que pueda realizarlo por consola miestras se crean los recursos
for i in {1..3}; do
  echo "Intento $i de 3..."
  # Otorgar permisos críticos a la cuenta de servicio de Cloud Storage en cada intento puede fallar las 
  # primeras veces no te preocupes
  gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:service-$numeroProject@gs-project-accounts.iam.gserviceaccount.com" \
    --role='roles/iam.serviceAccountUser' \
    --role='roles/pubsub.publisher'

  gcloud functions deploy $mi_nombre_funcion \
    --gen2 \
    --runtime=nodejs22 \
    --region=$REGION \
    --source=. \
    --entry-point=$mi_nombre_funcion \
    --trigger-bucket=$mi_bucket \
    --allow-unauthenticated

  if [ $? -eq 0 ]; then
    echo "✅ Despliegue de la función exitoso."
    break
  else
    echo "❌ Error en el despliegue. Esperando 45 segundos antes de reintentar..."
    sleep 45
  fi
done



wget https://storage.googleapis.com/cloud-training/gsp315/map.jpg
gsutil cp map.jpg gs://$mi_bucket/map.jpg
```

## **Tarea 4: Quita al anterior ingeniero de servicios de nube**

Verás que hay dos usuarios definidos en el proyecto:

- Uno que corresponde a tu cuenta (Username 1, con el rol Propietario)
- Otro que corresponde al ingeniero de servicios de nube anterior (Username 2, con el rol Visualizador).

1. Quita el acceso del anterior ingeniero de servicios de nube para que ya no pueda ingresar al proyecto.

## solución:

```bash
gcloud projects remove-iam-policy-binding $PROJECT_ID \
    --member="user:$ingeniero2" \
    --role='roles/viewer'
```
---
## Solución automatizada
También puedes resolver este laboratorio ejecutando un script de automatización en tu entorno de Cloud Shell. Este archivo contiene todos los comandos de gcloud en orden para crear la infraestructura.

Pasos para ejecutar el script
Crear el archivo del script:
En Cloud Shell, ejecuta el siguiente comando para crear un archivo vacío llamado solucion.sh:

```Bash
touch solucion.sh
```

Abrir el Editor de Código:
Haz clic en Open Editor en la parte superior derecha de tu terminal de Cloud Shell. En el menú de la izquierda, selecciona el archivo solucion.sh que acabas de crear.

Pegar el contenido:
Copia el código completo del script solucion.sh y pégalo en el editor. Luego, guarda el archivo.

Hacer el archivo ejecutable:
Regresa a la terminal y otorga permisos de ejecución al script con el siguiente comando:

```Bash
chmod +x solucion.sh
```

Ejecutar el script:
Para ejecutar el script y asegurarte de que las variables de entorno se mantengan en tu sesión de Cloud Shell, usa el comando source o el punto (.).

```Bash
source ./solucion.sh
# O
. ./solucion.sh
```
El script ahora se ejecutará, y la infraestructura del laboratorio será creada automáticamente.
