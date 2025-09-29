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

> [!NOTE]
  **Nota:** Si la cuenta no aparece en IAM o no tiene asignado el rol  `storage.admin`, sigue los pasos que se indican a continuación para asignar el rol necesario.
  

1. En la consola de Google Cloud, en el  **menú de navegación**, haz clic en  **Descripción general de Cloud > Panel**.
2. Copia el número del proyecto (p. ej.,  `729328892908`).
3. En el  **Menú de navegación**, selecciona  **IAM y administración**  >  **IAM**.
4. En la parte superior de la tabla de funciones, debajo de  **Ver por principales**, haz clic en  **Otorgar acceso**.
5. En  **Principales nuevas**, escribe lo siguiente:

{project-number}-compute@developer.gserviceaccount.com

Se copió correctamente

6. Reemplaza  `{project-number}`  por el número de tu proyecto.
7. En  **Rol**, selecciona  **Administrador de almacenamiento**.
8. Haz clic en  **Guardar**.

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

## Tarea 3: Usa la API de Google Cloud Speech-to-Text

- Usa la API de Google Cloud Speech-to-Text para analizar el archivo de audio  `gs://spls/gsp323/task3.flac`. Cuando hayas analizado el archivo, sube el archivo resultante aquí:  `Cloud Speech Location`

**Nota:**  Si esta tarea te genera problemas, puedes consultar el lab respectivo para solucionarlos:  [API de Google Cloud Speech-to-Text: Qwik Start](https://www.cloudskillsboost.google/catalog_lab/743)

## Tarea 4: Usa la API de Cloud Natural Language

- Usa la API de Cloud Natural Language para analizar la oración del texto sobre Odín. El texto que debes analizar es el siguiente: “Old Norse texts portray Odin as one-eyed and long-bearded, frequently wielding a spear named Gungnir and wearing a cloak and a broad hat”. Cuando hayas analizado el texto, sube el archivo resultante aquí:  `Cloud Natural Language Location`

**Nota:**  Si esta tarea te genera problemas, puedes consultar el lab respectivo para solucionarlos:  [API de Cloud Natural Language: Qwik Start](https://www.cloudskillsboost.google/catalog_lab/709)
