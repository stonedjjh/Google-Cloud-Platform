# ====================================================================
# CONFIGURACIÓN INICIAL Y PREPARACIÓN DE IAM
# NOTA: Asegúrate de que BUCKET_NAME, REGION, PROJECT_ID y los nombres de BQ estén definidos.
# ====================================================================

# Definición de variables clave (usar valores específicos del lab si se dan)
export PROJECT_ID=$(gcloud config list --format="value(core.project)")
export NUMERO_PROJECT=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")
export REGION=<colocar la región> # Reemplazar con la región del lab, por ejemplo us-central1
# Variables de la Tarea 1: Dataflow y BigQuery
export BIGQUERY_DATASET_NAME=<colocar el nombre del dataset de BigQuery> # Reemplazar con el nombre del dataset, por ejemplo customers_dataset
export OUTPUT_TABLE_NAME=<colocar el nombre de la tabla de salida de BigQuery> # Reemplazar con el nombre de la tabla, por ejemplo customers_table
export BUCKET_NAME=<colocar el nombre del bucket de GCS323 dato en las instrucciones> # Reemplazar con el nombre de tu bucket
export TABLA_SALIDA_BIGQUERY=${PROJECT_ID}:${BIGQUERY_DATASET_NAME}.${OUTPUT_TABLE_NAME}

# ===========================================================
# ⚠️ NOTA IMPORTANTE SOBRE VARIABLES DE UBICACIÓN Y BUCKET ⚠️
# -----------------------------------------------------------
# Las siguientes variables usan el BUCKET_NAME definido arriba junto con
# ciertas cadenas establecidas en la guía del lab.
# Si tu bucket tiene un nombre diferente o no coincide con el indicado en
# las instrucciones del Qwiklabs, actualiza manualmente los valores.
#
# Variables afectadas:
#  - CLOUD_SPEECH_LOCATION
#  - CLOUD_NATURAL_LANGUAGE_LOCATION
#  - DIRECTORIO_TEMPORAL
#  - UBICACION_TEMPORAL
# ===========================================================
export DIRECTORIO_TEMPORAL=gs://${BUCKET_NAME}/bigquery_temp
export UBICACION_TEMPORAL=gs://${BUCKET_NAME}/temp

# Variables de la Tarea 3 y 4: APIs de ML (dependen del bucket)
export NOMBRE_API=qwiklabs-ml-key
export CLOUD_SPEECH_LOCATION=<ingrese el nombre dado en la tarea 3>
export CLOUD_NATURAL_LANGUAGE_LOCATION=<ingrese el nombre dado en la tarea 4>

# ====================================================================
# Asignación de permisos de IAM (Comprobación y asignación no interactiva)
# ====================================================================

# Verifica y asigna 'storage.admin'
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:${NUMERO_PROJECT}-compute@developer.gserviceaccount.com" \
  --role='roles/storage.admin' --condition=None > /dev/null 2>&1

# Verifica y asigna 'editor'
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:${NUMERO_PROJECT}-compute@developer.gserviceaccount.com" \
  --role='roles/editor' --condition=None > /dev/null 2>&1

# ====================================================================
# PREPARACIÓN DE BIGQUERY y GCS (Necesario para Tarea 1)
# ====================================================================

echo "--- Preparando BigQuery y GCS ---"
# Se crea el bucket de GCS
gcloud storage buckets create gs://${BUCKET_NAME} --project=${PROJECT_ID} --location=${REGION} --uniform-bucket-level-access

# Crea el dataset de BigQuery
bq mk --location=${REGION} ${BIGQUERY_DATASET_NAME}

# Crea la tabla de BigQuery (usando un esquema vacío ya que Dataflow la poblará)
bq mk --table ${TABLA_SALIDA_BIGQUERY}

# ====================================================================
# TAREA 1: DATAFLOW (Text to BigQuery)
# ====================================================================
echo "--- Ejecutando Tarea 1: Dataflow ---"
gcloud services enable dataflow.googleapis.com

# ===========================================================
# NOTA: Las siguientes variables estaban predefinidas en el lab,
# pero se recomienda verificar que las rutas gs://siguen activas.
# ===========================================================
export NOMBRE_TRABAJO=mi-data-flow
export UBICACION_GSC=gs://dataflow-templates-us-central1/latest/GCS_Text_to_BigQuery
export ARCHIVOS_ENTRADA=gs://spls/gsp323/lab.csv
export ESQUEMA=gs://spls/gsp323/lab.schema
export UDF=gs://spls/gsp323/lab.js
export TRANSFORM=transform
export TIPO_MAQUINA=e2-standard-2
export NUMERO_TRABAJADORES=3

gcloud dataflow jobs run ${NOMBRE_TRABAJO} \
  --gcs-location=${UBICACION_GSC} \
  --region=${REGION} \
  --num-workers=${NUMERO_TRABAJADORES} \
  --worker-machine-type=${TIPO_MAQUINA} \
  --staging-location=${UBICACION_TEMPORAL} \
  --parameters inputFilePattern=${ARCHIVOS_ENTRADA},JSONPath=${ESQUEMA},outputTable=${TABLA_SALIDA_BIGQUERY},bigQueryLoadingTemporaryDirectory=${DIRECTORIO_TEMPORAL},javascriptTextTransformGcsPath=${UDF},javascriptTextTransformFunctionName=${TRANSFORM}
echo "Job de Dataflow iniciado. Esperando la finalización..."

# ====================================================================
# TAREA 2: DATAPROC (Creación, SSH No-Interactiva y Job Spark)
# ====================================================================
echo "--- Ejecutando Tarea 2: Dataproc ---"
gcloud services enable dataproc.googleapis.com

# Variables de Dataproc
#⚠️ Nota importante
# Los valores mostrados en esta tabla (por tipo de trabajo, clase principal o jar, archivos jar, 
# etc.) corresponden a los que estaban disponibles al momento de elaborar esta guía.
# Sin embargo, Google Cloud puede actualizarlos o modificarlos con el tiempo, por lo que 
# se recomienda verificar que los nombres y rutas coincidan con los valores actuales en la consola 
# antes de ejecutar el laboratorio.

export NOMBRE_CLUSTER="mi-cluster-dataproc"
export TAMANO_DISCO_PRINCIPAL=100GB
export NODO_ADMINISTRADOR_FAMILIA=e2-standard-2
export NODO_TRABAJADORES_FAMILIA=e2-standard-2
export MAXIMO_NODOS_TRABAJO=2
export TIPO_DISCO="pd-ssd" # Se requiere pd-ssd para e2-standard-2
export TIPO_TRABAJO=spark
export CLASE_PRINCIPAL=org.apache.spark.examples.SparkPageRank
export ARCHIVO=file:///usr/lib/spark/examples/jars/spark-examples.jar
export ARGUMENTO=/data.txt
export MAXIMO_REINTENTO_HORA=1

echo "Creando clúster Dataproc: Esto puede tardar entre 3 y 5 minutos. Por favor, espere..."
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

echo "Generando clave SSH de forma no interactiva (solución de automatización)..."
ssh-keygen -t rsa -N "" -f ~/.ssh/google_compute_engine <<< y > /dev/null 2>&1

echo "Extrayendo la zona del clúster..."
export ZONE=$(gcloud dataproc clusters list \
  --filter="clusterName=${NOMBRE_CLUSTER}" \
  --region=${REGION} \
  --format="value(config.gceClusterConfig.zoneUri)")

echo "Copiando archivo a HDFS (solución a PATH_NOT_FOUND)..."
gcloud compute ssh ${NOMBRE_CLUSTER}-m \
  --zone=${ZONE} \
  --command="hdfs dfs -cp gs://spls/gsp323/data.txt /data.txt"

echo "Enviando Job Spark PageRank..."
gcloud dataproc jobs submit ${TIPO_TRABAJO} \
  --cluster=${NOMBRE_CLUSTER} \
  --region=${REGION} \
  --class=${CLASE_PRINCIPAL} \
  --jars=${ARCHIVO} \
  --max-failures-per-hour=${MAXIMO_REINTENTO_HORA} \
  -- \
  ${ARGUMENTO}
echo "Job de Spark enviado."

# ====================================================================
# TAREAS 3 y 4: CLOUD SPEECH-TO-TEXT & NATURAL LANGUAGE (API Key)
# ====================================================================
echo "--- Ejecutando Tareas 3 y 4: APIs de ML ---"
gcloud services disable speech.googleapis.com
gcloud services disable language.googleapis.com
gcloud services enable speech.googleapis.com
gcloud services enable language.googleapis.com

echo "Creando Clave API con restricciones de servicio..."
gcloud services api-keys create --display-name=${NOMBRE_API} \
  --api-target=service=speech.googleapis.com \
  --api-target=service=language.googleapis.com \
  --project=${PROJECT_ID} > key_output.json 2>&1

echo "Extrayendo valor de la Clave API..."
export API_KEY=$(grep -oP '"keyString":"\K[^"]+' key_output.json)
rm key_output.json

echo "Esperando 30 segundos para la propagación de permisos de API..."
sleep 30

# --- Tarea 3: Speech-to-Text ---
echo "--- Tarea 3: Speech-to-Text ---"
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
rm request.json response.json
echo "Tarea 3 completada y archivo subido."

# --- Tarea 4: Cloud Natural Language ---
echo "--- Tarea 4: Cloud Natural Language ---"
gcloud ml language analyze-entities --content="Old Norse texts portray Odin as one-eyed and long-bearded, frequently wielding a spear named Gungnir and wearing a cloak and a broad hat" > result.json
gsutil cp result.json ${CLOUD_NATURAL_LANGUAGE_LOCATION}
rm result.json
echo "Tarea 4 completada y archivo subido."
echo "--- Script de Automatización Finalizado ---"
