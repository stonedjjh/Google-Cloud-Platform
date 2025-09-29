# Prepara datos para las APIs de AA en Google Cloud: Lab de desafío

## GSP323

![Logotipo de los labs de autoaprendizaje de Google Cloud](https://cdn.qwiklabs.com/GMOHykaqmlTHiqEeQXTySaMXYPHeIvaqa2qHEzw6Occ%3D)

## Descripción general

En un lab de desafío, se le proporcionarán una situación y un conjunto de tareas. En lugar de seguir instrucciones paso a paso, deberás utilizar las habilidades aprendidas en los labs del curso para decidir cómo completar las tareas por tu cuenta. Un sistema automatizado de puntuación (en esta página) mostrará comentarios y determinará si completaste tus tareas correctamente.

En un lab de desafío, no se explican conceptos nuevos de Google Cloud, sino que se espera que amplíes las habilidades que adquiriste, como cambiar los valores predeterminados y leer o investigar los mensajes de error para corregir sus propios errores.

Debe completar correctamente todas las tareas dentro del período establecido para obtener una puntuación del 100%.

Se recomienda este lab a los estudiantes que se inscribieron en la insignia de habilidad  [Prepara datos para las APIs de AA en Google Cloud](https://www.cloudskillsboost.google/course_templates/631). ¿Aceptas el desafío?

Temas evaluados:

- Crear un trabajo simple de Dataproc
- Crear un trabajo simple de Dataflow
- Realizar dos tareas de APIs respaldadas por el aprendizaje automático de Google

### Verifica los permisos del proyecto

Antes de comenzar a trabajar en Google Cloud, asegúrate de que tu proyecto tenga los permisos correctos en Identity and Access Management (IAM).

1.  En la consola de Google Cloud, en el  **Menú de navegación**, selecciona  **IAM y administración**  >  **IAM**.

2.  Confirma que aparezca la cuenta de servicio predeterminada de Compute  `{project-number}-compute@developer.gserviceaccount.com`  con los roles  `editor`  y  `storage.admin`  asignados. El prefijo de la cuenta es el número del proyecto, que puedes encontrar en el  **Menú de navegación > Descripción general de Cloud > Panel**.


2.  Confirma que aparezca la cuenta de servicio predeterminada de Compute  `{project-number}-compute@developer.gserviceaccount.com`  con los roles  `editor`  y  `storage.admin`  asignados. El prefijo de la cuenta es el número del proyecto, que puedes encontrar en el  **Menú de navegación > Descripción general de Cloud > Panel**.



> [!NOTE]
  **Nota:** Si la cuenta no aparece en IAM o no tiene asignado el rol  `storage.admin`, sigue los pasos que se indican a continuación para asignar el rol necesario.
  

1. En la consola de Google Cloud, en el  **menú de navegación**, haz clic en  **Descripción general de Cloud > Panel**.
2. Copia el número del proyecto (p. ej.,  `729328892908`).
3. En el  **Menú de navegación**, selecciona  **IAM y administración**  >  **IAM**.
4. En la parte superior de la tabla de funciones, debajo de  **Ver por principales**, haz clic en  **Otorgar acceso**.
5. En  **Principales nuevas**, escribe lo siguiente:

{project-number}-compute@developer.gserviceaccount.com

6.  Reemplaza  `{project-number}`  por el número de tu proyecto.
7.  En  **Rol**, selecciona  **Administrador de almacenamiento**.
8.  Haz clic en  **Guardar**.

```bash
export PROJECT_ID=<ingrese el id del projecto>
# Define las variables de entorno
export PROJECT_ID=$(gcloud config list --format="value(core.project)")
export NUMERO_PROJECT=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")

# ---

# Verifica si el permiso 'storage.admin' ya existe y lo asigna si no es así
if ! gcloud projects get-iam-policy $PROJECT_ID --filter="(bindings.members:serviceAccount:*@developer.gserviceaccount.com) AND (bindings.role:roles/storage.admin)" --flatten="bindings[].members" | grep -q "roles/storage.admin"; then
  echo "El rol 'storage.admin' no está asignado. Procediendo a asignarlo..."
  gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:service-${NUMERO_PROJECT}-compute@developer.gserviceaccount.com" \
    --role='roles/storage.admin'
fi

# ---

# Verifica si el permiso 'editor' ya existe y lo asigna si no es así
if ! gcloud projects get-iam-policy $PROJECT_ID --filter="(bindings.members:serviceAccount:*@developer.gserviceaccount.com) AND (bindings.role:roles/editor)" --flatten="bindings[].members" | grep -q "roles/editor"; then
  echo "El rol 'editor' no está asignado. Procediendo a asignarlo..."
  gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:service-${NUMERO_PROJECT}-compute@developer.gserviceaccount.com" \
    --role='roles/editor'
fi
```

## Situación del desafío

Como ingeniero de datos júnior en Jooli Inc. y recientemente capacitado en Google Cloud y varios servicios de datos, tienes que demostrar tus nuevas habilidades. El equipo te pidió que completes las tareas que figuran a continuación.

Se espera que tengas las habilidades y el conocimiento necesarios para realizar estas tareas, por lo que no recibirás guías paso a paso.

## Tarea 1: Ejecuta un trabajo simple de Dataflow

En esta tarea, usarás la plantilla por lotes de Dataflow  **Text Files on Cloud Storage to BigQuery**  de la sección “Process Data in Bulk (batch)” para transferir datos desde un bucket de Cloud Storage (`gs://spls/gsp323/lab.csv`). La siguiente tabla tiene los valores que necesitas para configurar correctamente el trabajo de Dataflow.

Asegúrate de haber hecho lo siguiente:

- Crea un conjunto de datos de BigQuery llamado  `BigQuery Dataset Name`  con una tabla llamada  `Output Table Name`.
- Crea un bucket de Cloud Storage llamado  `Cloud Storage Bucket Name`.

|Campo|Valor|
| --|--|
|Archivos de entrada de Cloud Storage  | `gs://spls/gsp323/lab.csv` |
|Ubicación en Cloud Storage del archivo de esquema de BigQuery  | `gs://spls/gsp323/lab.schema` |
|Tabla de salida de BigQuery  | `Output Table Name` |
|Directorio temporal para el proceso de carga de BigQuery  | `Temporary BigQuery Directory` | 
|Ubicación temporal  | `Temporary Location` |
|Parámetros opcionales > Ruta de acceso de UDF de JavaScript en Cloud Storage  | `gs://spls/gsp323/lab.js` |
|Parámetros opcionales > Nombre de UDF de JavaScript  | `transform` |
|Parámetros opcionales > Tipo de máquina  | `e2-standard-2` |

**solución** primero tenemos que crear el conjunto de datos y la tabla para eso buscaremos en la [documentación](https://cloud.google.com/bigquery/docs/quickstarts/load-data-bq?hl=es-419)
y en la de [dataflow](https://cloud.google.com/dataflow/docs/overview?hl=es-419) 
y [aqui](https://cloud.google.com/sdk/gcloud/reference/dataflow)
y para ayudarnos con [GCS_Text_to_BigQuery](https://cloud.google.com/dataflow/docs/guides/templates/provided/cloud-storage-to-bigquery?hl=es-419#gcloud)

```bash
export BIGQUERY_DATA_SET_NAME=<ingrese el nombre del dataset>
export OUTPUT_TABLE_NAME=<ingrese el nombre de la tabla>
export BUCKET_NAME=<ingrese el nombre del bucket>
export REGION=<ingrese la region del lab>

# Se crea el bucket
gcloud storage buckets create gs://${BUCKET_NAME} --project=${PROJECT_ID} --location=${REGION} 

# Crea el dataset
bq mk ${BIGQUERY_DATA_SET_NAME}
# Crea la tabla
bq mk \
  --table \
  ${PROJECT_ID}:${BIGQUERY_DATA_SET_NAME}.${OUTPUT_TABLE_NAME}

export REGION=<ingrese la region del lab>
export ZONE=<ingrese la zona del lab>
#desactivamos y activamos el servicio de dataflow
gcloud services disable dataflow.googleapis.com --project ${PROJECT_ID} --force
gcloud services enable dataflow.googleapis.com --project ${PROJECT_ID}

#definimos las variables para el dataflow
#Puedes definir el nombre que quieras
export NOMBRE_TRABAJO="miDataFlow"
export UBICACION_GSC=<colocar la Ubicación de Cloud Storage del archivo de esquema de BigQuery>
export ARCHIVOS_ENTRADA=<colocar Archivos de entrada de Cloud Storage>
export ESQUEMA=<colocar Ubicación en Cloud Storage del archivo de esquema de BigQuery>
export TABLA_SALIDA_BIGQUERY=<Tabla de salida de BigQuery>
export DIRECTORIO_TEMPORAL=<colocar el Directorio temporal para el proceso de carga de BigQuery>
export UBICACION_TEMPORAL=<colocar la Ubicación temporal del lab>
export UDF=<Parámetros opcionales  Ruta de acceso de UDF de JavaScript en Cloud Storage>
export TRANSFORM=<Parámetros opcionales  Nombre de UDF de JavaScript> #ejemplo transform
export TIPO_MAQUINA=<colocar Parámetros opcionales Tipo de máquina> #ejemplo "e2-standard-2"
export NUMERO_TRABAJADORES=3







gcloud dataflow jobs run ${NOMBRE_TRABAJO}\
  --gcs-location gs://dataflow-templates-us-central1/latest/GCS_Text_to_BigQuery\
  --region ${REGION}\
  --num-workers ${NUMERO_TRABAJADORES}\
  --worker-machine-type ${TIPO_MAQUINA}\
  --staging-location ${UBICACION_TEMPORAL}\
  --parameters inputFilePattern=${ARCHIVOS_ENTRADA},JSONPath=${ESQUEMA},outputTable=${PROJECT_ID}:${BIGQUERY_DATA_SET_NAME}.${OUTPUT_TABLE_NAME},bigQueryLoadingTemporaryDirectory=${DIRECTORIO_TEMPORAL},javascriptTextTransformGcsPath=${UDF},javascriptTextTransformFunctionName=${TRANSFORM}
```


## Tarea 2: Ejecuta un trabajo simple de Dataproc

En esta tarea, ejecutarás un trabajo de Spark de ejemplo con Dataproc.

Antes de ejecutar el trabajo, accede a uno de los nodos del clúster y copia el archivo /data.txt en HDFS (usa el comando  `hdfs dfs -cp gs://spls/gsp323/data.txt /data.txt`).

Ejecuta un trabajo de Dataproc con los valores que se indican a continuación.

| Campo | Valor |
|--|--|
| Región | `` Region `` |
| Tipo de trabajo | `Spark` |
| Clase principal o jar | `org.apache.spark.examples.SparkPageRank` |
| Archivos jar | `file:///usr/lib/spark/examples/jars/spark-examples.jar` |
| Argumentos | `/data.txt` |
| Cantidad máxima de reinicios por hora | `1` |
| Clúster de Dataproc | `Compute Engine` |
| Región | `` `Region` `` |
| Serie de máquinas | `E2` |
| Nodo administrador | Configura el  **tipo de máquina**  como  **e2-standard-2** |
| Nodo trabajador | Configura el  **tipo de máquina**  como  **e2-standard-2** |
| Máx. de nodos trabajadores | `2` |
| Tamaño del disco principal | `100 GB` |
| Solo IP internas | `Anula la selección de “Configurar todas las instancias para tener solo direcciones IP internas`”. |

**Solución** Como en los pasos anteriores nos documentamos sobre [dataproc](https://cloud.google.com/sdk/gcloud/reference/dataproc)

```BASH
# Desactivamos y activamos el servicio de Dataproc para asegurar una configuración limpia
gcloud services disable dataproc.googleapis.com --project ${PROJECT_ID} --force
gcloud services enable dataproc.googleapis.com --project ${PROJECT_ID}

#definimos las variables que usaremos en el cluster y en el trabajo con spark
export NOMBRE_CLUSTER=<Ingrese la variable Clúster de Dataproc del lab>
export TAMANO_DISCO_PRINCIPAL=<ingrese el valor de Tamaño del disco principal> #ejemplo 100GB
export NODO_ADMINISTRADOR_FAMILIA=<ingrese el valor de Nodo administrador>
export NODO_TRABAJADORES_FAMILIA=<ingrese el valor de Nodo trabajador>
export MAXIMO_NODOS_TRABAJO=<ingrese el valor de Máx. de nodos trabajadores>
#La familia de maquinas e2-standard-2 no soporta el disco pd-standard por lo cual se debe
#cambiar a pd-ssd
export TIPO_DISCO="pd-ssd"

#Se procede a crear el cluster
gcloud dataproc clusters create ${NOMBRE_CLUSTER} \
  --region=${REGION} \
  --master-boot-disk-size=${TAMANO_DISCO_PRINCIPAL} \
  --master-boot-disk-type=${TIPO_DISCO} \
  --master-machine-type=${NODO_ADMINISTRADOR_FAMILIA} \
  --public-ip-address \
  --num-workers=${MAXIMO_NODOS_TRABAJO} \
  --worker-machine-type=${NODO_TRABAJADORES_FAMILIA} \
  --worker-boot-disk-type=${TIPO_DISCO} \
  --worker-boot-disk-size=${TAMANO_DISCO_PRINCIPAL} \
  --project=${PROJECT_ID}  

#Al finalizar la creacion del cluster copiamos el archivo hdfs al cluster

gcloud compute ssh ${NOMBRE_CLUSTER}-m

#Se usa el comando dado en el lan
hdfs dfs -cp gs://spls/gsp323/data.txt /data.txt

#Ahora se vuelve a la terminal
exit

#Se definen las variables para el trabajo
export TIPO_TRABAJO=<ingrese el Tipo de trabajo del lab>
export CLASE_PRINCIPAL=<ingrese el Clase principal o jar del lab>
export ARCHIVO=<ingrese el valor de Archivos jar del lab>
export ARGUMENTO=<ingrese el valor de Argumentos> #ejemplo /data.txt
export MAXIMO_REINTENTO_HORA=<Cantidad máxima de reinicios por hora> #ejemplo 1

# Se procede a enviar el trabajo
gcloud dataproc jobs submit spark \
  --cluster=${NOMBRE_CLUSTER} \
  --region=${REGION} \
  --class=${CLASE_PRINCIPAL}\
  --jars=${ARCHIVO}\
  --max-failures-per-hour=${MAXIMO_REINTENTO_HORA} \
  -- \
  ${ARGUMENTO}  
```

## Tarea 3: Usa la API de Google Cloud Speech-to-Text

- Usa la API de Google Cloud Speech-to-Text para analizar el archivo de audio  `gs://spls/gsp323/task3.flac`. Cuando hayas analizado el archivo, sube el archivo resultante aquí:  `Cloud Speech Location`

**Nota:**  Si esta tarea te genera problemas, puedes consultar el lab respectivo para solucionarlos:  [API de Google Cloud Speech-to-Text: Qwik Start](https://www.cloudskillsboost.google/catalog_lab/743)

**Solución** Para esta actividad nos quiaremos con el [qwiklab](https://www.cloudskillsboost.google/paths/36/course_templates/631/labs/591405)

```bash
# Se deshabilita y habilita la api de speech de gcp
gcloud services disable speech.googleapis.com
gcloud services enable speech.googleapis.com
export NOMBRE_API="mi-api-key"
export CLOUD_SPEECH_LOCATION=<ingrese Cloud Speech Location del lab>

# Se crea la API key y se guarda su ID en una variable en un solo paso
gcloud services api-keys create --display-name=${NOMBRE_API}
export API_KEY_ID=$(gcloud services api-keys list --format="value(name)")


# Se obtiene el valor de la llave API y se guarda en una variable
export API_KEY=$(gcloud services api-keys list --format="value(keyString)" --filter="displayName=${NOMBRE_API}")

# Se le da los permisos necesarios a la API Key que se creo
gcloud services api-keys update ${API_KEY_ID} \
  --api-target=service=speech.googleapis.com \
  --api-target=service=language.googleapis.com

# Se procede a crear el archivo json con los parametros para la peticion a la api
cat << EOF > request.json
{
  "config": {
    "encoding":"FLAC",
    "languageCode": "en-US"
  },
  "audio": {
    "uri":"gs://spls/gsp323/task3.flac"
  }
}
EOF

curl -s -X POST -H "Content-Type: application/json" --data-binary @request.json \
"https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}" > response.json
gsutil cp response.json ${CLOUD_SPEECH_LOCATION}
```

## Tarea 4: Usa la API de Cloud Natural Language

- Usa la API de Cloud Natural Language para analizar la oración del texto sobre Odín. El texto que debes analizar es el siguiente: “Old Norse texts portray Odin as one-eyed and long-bearded, frequently wielding a spear named Gungnir and wearing a cloak and a broad hat”. Cuando hayas analizado el texto, sube el archivo resultante aquí:  `Cloud Natural Language Location`

**Nota:**  Si esta tarea te genera problemas, puedes consultar el lab respectivo para solucionarlos:  [API de Cloud Natural Language: Qwik Start](https://www.cloudskillsboost.google/catalog_lab/709)

**Solución** [api](https://www.cloudskillsboost.google/focuses/582?parent=catalog)

```bash
gcloud services disable language.googleapis.com
gcloud services enable language.googleapis.com
export CLOUD_NATURAL_LANGUAGE_LOCATION=<ingrese Cloud Natural Language Location del lab>
gcloud ml language analyze-entities --content="Old Norse texts portray Odin as one-eyed and long-bearded, frequently wielding a spear named Gungnir and wearing a cloak and a broad hat" > result.json
gsutil cp result.json ${CLOUD_NATURAL_LANGUAGE_LOCATION}
```
