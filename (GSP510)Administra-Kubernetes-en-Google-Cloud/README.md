# Administra Kubernetes en Google Cloud

## GSP510

![Logotipo de los labs de autoaprendizaje de Google Cloud](https://cdn.qwiklabs.com/GMOHykaqmlTHiqEeQXTySaMXYPHeIvaqa2qHEzw6Occ%3D)

## Introducción

En un lab de desafío, se le proporcionarán una situación y un conjunto de tareas. En lugar de seguir instrucciones paso a paso, deberás utilizar las habilidades aprendidas en los labs del curso para decidir cómo completar las tareas por tu cuenta. Un sistema automatizado de puntuación (en esta página) mostrará comentarios y determinará si completaste tus tareas correctamente.

En un lab de desafío, no se explican conceptos nuevos de Google Cloud, sino que se espera que amplíes las habilidades que adquiriste, como cambiar los valores predeterminados y leer o investigar los mensajes de error para corregir sus propios errores.

Debe completar correctamente todas las tareas dentro del período establecido para obtener una puntuación del 100%.

Se recomienda este lab a los estudiantes inscritos en la insignia de habilidad [Administra Kubernetes en Google Cloud.](https://www.skills.google/course_templates/783) ¿Aceptas el desafío?

## Antes de hacer clic en el botón Comenzar lab

Lee estas instrucciones. Los labs cuentan con un temporizador que no se puede pausar. El temporizador, que comienza a funcionar cuando haces clic en Comenzar lab, indica por cuánto tiempo tendrás a tu disposición los recursos de Google Cloud.

Este lab práctico te permitirá realizar las actividades correspondientes en un entorno de nube real, no en uno de simulación o demostración. Para ello, se te proporcionan credenciales temporales nuevas que utilizarás para acceder a Google Cloud durante todo el lab.

Para completar este lab, necesitarás lo siguiente:

- Acceso a un navegador de Internet estándar. Se recomienda el navegador Chrome.

> [!NOTE]
> **Nota:**Usa una ventana del navegador privada o de incógnito (opción recomendada) para ejecutar el lab. Así evitarás conflictos entre tu cuenta personal y la cuenta de estudiante, lo que podría generar cargos adicionales en tu cuenta personal.

- Tiempo para completar el lab (recuerda que, una vez que comienzas un lab, no puedes pausarlo).

> [!NOTE]
> **Nota:** Usa solo la cuenta de estudiante para este lab. Si usas otra cuenta de Google Cloud, es posible que se apliquen cargos a esa cuenta.

## Situación del desafío

Te integraste a Cymbal Shops hace apenas unos meses. Dedicaste mucho tiempo a trabajar con contenedores en Docker y Artifact Registry, y aprendiste los conceptos básicos para administrar implementaciones nuevas y existentes en GKE. Practicaste actualizando manifiestos, así como escalando, supervisando y depurando las aplicaciones que se ejecutan en tus clústeres.

![logotipo de Cymbal Shops](https://cdn.qwiklabs.com/ERaGdAqCyYGK%2Flm84HkWBKxIQawXk%2FXKsTWjApgsPJ0%3D)

Tu equipo quiere que empieces a administrar sus implementaciones de Kubernetes para garantizar lanzamientos y actualizaciones de aplicaciones sin problemas en su nuevo sitio web de comercio electrónico. Antes de que empieces en este nuevo cargo, el equipo de desarrollo quiere que demuestres tus nuevas habilidades. Como parte de esta demostración, tienen una lista de tareas que les gustaría que realizaras durante un período determinado en un entorno de zona de pruebas.

## Tu desafío

Como parte del entorno de la zona de pruebas, tus desarrolladores crearon un repositorio de Artifact Registry llamado ==cluster name==, que incluye un fragmento de código con una aplicación de ejemplo básica que implementarás en un clúster.

> [!NOTE]
> **Nota:** Esta imagen que se creó en el repo es una versión alojada en un contenedor del código que descargarás del bucket spls/gsp510/hello-app más adelante en el lab.

Deberás realizar las siguientes tareas:

- Crear un clúster de GKE basado en un conjunto de parámetros de configuración proporcionados
- Habilitar Prometheus administrado en el clúster para supervisar métricas
- Implementar un manifiesto de Kubernetes en el clúster y depurar los errores
- Crear una métrica basada en registros y una política de alertas para los errores en el clúster de Kubernetes
- Corregir los errores de manifiesto, alojar en contenedores el código de tu aplicación y enviarlo a Artifact Registry con Docker
- Exponer un servicio para tu aplicación en el clúster y verificar tus actualizaciones

### Tarea 1: Crea un clúster de GKE

El nuevo sitio web de comercio electrónico de Cymbal Shops se ejecutará de forma nativa en GKE, y el equipo quiere conocer tu experiencia trabajando con clústeres y configurándolos. En esta sección, deberás crear un clúster de Kubernetes basado en un conjunto de parámetros de configuración que se te proporcionaron para ejecutar tus aplicaciones de demostración.

    1. Crea un clúster de GKE llamado ==cluster name== con la siguiente configuración:

   |Parámetro de configuración|Valor|
   |:-------------------------|:----|
   |Zona|==ZONE==|
   |Canal de versiones|Regular|
   |Versión de destino del clúster|default|
   |Escalador automático de clúster|Habilitado|
   |Cantidad de nodos|3|
   |Cantidad mínima de nodos|2|
   |Cantidad máxima de nodos|6|

   ```bash
   ZONE=<Ingrese zona del lab>
   CLUSTER_NAME=<Ingrese nombre del cluster>
   
   echo -e "\e[1mTarea 1: Crear cluster de GKE $CLUSTER_NAME\e[0m\n"
   
   gcloud container clusters create $CLUSTER_NAME \
     --zone=$ZONE \     
     --num-nodes=3 \
     --min-nodes=2 \
     --max-nodes=6 \
     --enable-autoscaling
   
   echo -e "\n\e[32mCruster Creado\e[0m\n"  
   gcloud container clusters get-credentials $CLUSTER_NAME --zone=$ZONE
   ```

---

### Tarea 2: Habilita Prometheus administrado en el clúster de GKE

Como parte de la estrategia del sitio web de comercio electrónico, Cymbal Shops quiere comenzar a usar Prometheus administrado para las métricas y la supervisión en el clúster y, así, brindarles una buena experiencia a sus clientes. En esta sección, habilitarás Prometheus administrado en el clúster para supervisar métricas y crearás un espacio de nombres para implementar una aplicación de Prometheus de muestra y la supervisión de Pods.

   1. Habilita la recopilación de Prometheus administrado en el clúster de GKE.
   2. Crea un espacio de nombres en el clúster llamado ==namespace name==.
   3. Descarga una app de Prometheus de ejemplo:

      `gcloud storage cp gs://spls/gsp510/prometheus-app.yaml .`

   4. Actualiza las secciones `<todo>` (líneas 35 a 38) con la siguiente configuración:

      - **containers.image:** nilebox/prometheus-example-app:latest
      - **containers.name:** prometheus-test
      - **ports.name:** metrics

   5. Implementa la aplicación en el espacio de nombres ==namespace name== de tu clúster de GKE.

   6. Descarga el archivo pod-monitoring.yaml:

      `gcloud storage cp gs://spls/gsp510/pod-monitoring.yaml .`

   7. Actualiza las secciones `<todo>` (líneas 18 a 24) con la siguiente configuración:

      - **metadata.name:** prometheus-test
      - **labels.app.kubernetes.io/name:** prometheus-test
      - **matchLabels.app:** prometheus-test
      - **endpoints.interval:** interval period

   8. Aplica el recurso de supervisión de Pod en el espacio de nombres ==namespace name== en tu clúster de GKE.

```bash
NAMESPACE_NAME=<Ingrese nombre del espacio de nombres>
INTERVAL_PERIOD=<Ingrese intervalo de tiempo>

echo -e "\e[1mTarea 2: Habilitar Prometheus administrado en el clúster\e[0m\n"

echo -e "Paso 1 Habilita la recopilación de Prometheus administrado en el clúster de GKE\n"

gcloud container clusters update $CLUSTER_NAME --enable-managed-prometheus --zone=$ZONE

echo -e "\n\e[32mPrometheus habilitado\e[0m\n"

echo -e "Paso 2 Crea un espacio de nombres en el clúster llamado $NAMESPACE_NAME\n"

kubectl create ns $NAMESPACE_NAME

echo -e "\n\e[32mEspacio de nombres creado\e[0m\n"

echo -e "Paso 3 Descarga una app de Prometheus de ejemplo\n"

gcloud storage cp gs://spls/gsp510/prometheus-app.yaml .


echo -e "\n\e[32mApp de Prometheus descargada\e[0m\n"

echo -e "Paso 4 Actualiza las secciones <todo> (líneas 35 a 38)\n"

echo -e "Paso 5 Implementa la aplicación en el espacio de nombres $NAMESPACE_NAME de tu clúster de GKE\n"

kubectl -n $NAMESPACE_NAME apply -f prometheus-app.yaml

echo -e "\n\e[32mApp de Prometheus implementada\e[0m\n"

echo -e "Paso 6 Descarga el archivo pod-monitoring.yaml\n"

gcloud storage cp gs://spls/gsp510/pod-monitoring.yaml .

echo -e "\n\e[32mArchivo pod-monitoring.yaml descargado\e[0m\n"

echo -e "Paso 7 Actualiza las secciones <todo> (líneas 18 a 24)\n"

echo -e "Paso 8 Aplica el recurso de supervisión de Pod en el espacio de nombres $NAMESPACE_NAME en tu clúster de GKE\n"

kubectl -n $NAMESPACE_NAME apply -f pod-monitoring.yaml

echo -e "\n\e[32mApp de Prometheus implementada\e[0m\n"

kubectl get pods -n $NAMESPACE_NAME

```

---

### Tarea 3: Implementa una aplicación en el clúster de GKE

El equipo de desarrollo de Cymbal Shops lanzará constantemente código de aplicación nuevo en el clúster que tendrás que implementar de manera correcta en producción. En esta sección, implementarás un manifiesto de Kubernetes en el clúster y, luego, inspeccionarás el problema.

   1. Descarga los archivos de manifiesto para la implementación de la demostración:

      `gcloud storage cp -r gs://spls/gsp510/hello-app/ .`

   2. Crea una implementación en el espacio de nombres ==namespace name== en tu clúster de GKE desde el archivo de manifiesto `helloweb-deployment.yaml`. Se encuentra en la carpeta `hello-app/manifests`.

   3. Verifica que hayas creado la implementación y navega a la página de detalles de la implementación de **helloweb**. Deberías ver el siguiente error:

   ![error de nombre de imagen no válido](https://cdn.qwiklabs.com/OONay%2Feg%2FuH6FbRql2BVYFxbv%2FrWV1ER97BP1RRyjbY%3D)

Este error parece provenir de un nombre de imagen no válido en el manifiesto que acabas de implementar. Antes de corregir el nombre de la imagen, crearás una métrica basada en registros y una política de alertas para que tu equipo reciba una notificación si esto vuelve a ocurrir en el futuro.

```bash

echo -e "\e[1mTarea 3: Implementa una aplicación en el clúster de GKE\e[0m\n"

echo -e "\e[1m\ePaso1 Descarga los archivos de manifiesto para la implementación de la demostración[0m\n"

gcloud storage cp -r gs://spls/gsp510/hello-app/ .

echo -e "\n\e[32mArchivos de manifiesto descargados\e[0m\n"

echo -e "\e[1m\ePaso2 Crea una implementación en el espacio de nombres $NAMESPACE_NAME en tu clúster de GKE[0m\n"

kubectl -n $NAMESPACE_NAME apply -f hello-app/manifests/helloweb-deployment.yaml

kubectl get deployment helloweb -n $NAMESPACE_NAME
```

---

### Tarea 4: Crea una métrica basada en registros y una política de alertas

A Cymbal Shops le gustaría configurar algunas métricas basadas en registros y políticas de alertas para agregar la cantidad de errores y advertencias en sus Pods de Kubernetes, así como establecer un mecanismo de alertas para sus clústeres cuando se supere un umbral de errores. En esta sección, demostrarás tus conocimientos en la creación de estas métricas y políticas de alertas para el equipo.

#### Crea una métrica basada en registros

   1. En el Explorador de registros, crea una consulta que devuelva las advertencias o los errores que viste en la sección anterior sobre el clúster.

      > [!NOTE]
      > **nota:** Tu consulta debe tener seleccionados solo un tipo de recurso y una gravedad.
      Si la consulta es correcta, cuando se ejecute, deberías ver los siguientes errores en los registros:

      **Resultado:**

      ```bash
      Error: InvalidImageName
      Failed to apply default image tag "`<todo>`": couldn't parse image
      reference "`<todo>`": invalid reference format
      ```

   2. Crea una métrica basada en registros a partir de esta consulta. En **Tipo de métrica**, usa **Contador** y, en **Nombre de la métrica de registro**, usa pod-image-errors.

#### Crea una política de alertas

   1. Crea una política de alertas en función de la métrica basada en registros que acabas de crear. Usa los siguientes detalles para configurar tu política:

      - **Ventana progresiva:** 10 min
      - **Función de ventana progresiva:** Count
      - **Agregación de series temporales:** Sum
      - **Tipo de condición:** Umbral
      - **Activador de alertas:** Cualquier serie temporal tiene incumplimientos
      - **Posición del umbral:** Por encima del umbral
      - **Valor del umbral:** 0
      - **Usar el canal de notificaciones:** Inhabilitar
      - **Nombre de la política de alertas:** Pod Error Alert

```bash
echo -e "\e[1mTarea 4: Crea una métrica basada en registros y una política de alertas\e[0m\n"

echo -e "\e[1m\ePaso1 crea una consulta que devuelva las advertencias o los errores[0m\n"

gcloud logging read "resource.type=\"k8s_container\" AND resource.labels.cluster_name=\"$CLUSTER_NAME\" AND (severity=ERROR OR severity=WARNING)" \
    --limit=10 \
    --format="table(timestamp, resource.labels.container_name, severity, textPayload, jsonPayload.message)"

echo -e "\n\e[32mConsulta creada\e[0m\n"

echo -e "\e[1m\ePaso2 crea una métrica basada en registros[0m\n"   

gcloud logging metrics create pod-image-errors \
    --description="Métrica para capturar errores de imagen en los Pods" \
    --log-filter="resource.type=\"k8s_pod\"
severity=WARNING"

echo -e "\n\e[32mMétrica basada en registros creada\e[0m\n"

echo -e "\e[1m\ePaso3 crea una política de alertas[0m\n"

cat << 'EOF' > alerta.json
{
  "displayName": "Pod Error Alert",
  "userLabels": {},
  "conditions": [
    {
      "displayName": "Kubernetes Pod - logging/user/pod-image-errors",
      "conditionThreshold": {
        "filter": "resource.type = \"k8s_pod\" AND metric.type = \"logging.googleapis.com/user/pod-image-errors\"",
        "aggregations": [
          {
            "alignmentPeriod": "600s",
            "crossSeriesReducer": "REDUCE_SUM",
            "perSeriesAligner": "ALIGN_COUNT"
          }
        ],
        "comparison": "COMPARISON_GT",
        "duration": "0s",
        "trigger": {
          "count": 1
        },
        "thresholdValue": 0
      }
    }
  ],
  "alertStrategy": {
    "autoClose": "604800s"
  },
  "combiner": "OR",
  "enabled": true,
  "notificationChannels": []
}
EOF

gcloud alpha monitoring policies create --policy-from-file="alerta.json"

echo -e "\n\e[32mPolítica de alertas creada\e[0m\n"


```

## Tarea 5: Actualiza y vuelve a implementar tu app

El equipo de desarrollo quiere que demuestres tus conocimientos para borrar y actualizar implementaciones en el clúster en caso de error. En esta sección, actualizarás un manifiesto de Kubernetes con una referencia de imagen correcta, borrarás una implementación y, luego, implementarás la aplicación actualizada en el clúster.

   1. Reemplaza `<todo>` en la sección de imagen del manifiesto de implementación helloweb-deployment.yaml por la siguiente imagen:

      - us-docker.pkg.dev/google-samples/containers/gke/hello-app:1.0

   2. **Borra** la implementación **helloweb** de tu clúster.

   3. Implementa el manifiesto `helloweb-deployment.yaml` actualizado en el espacio de nombres ==namespace name== de tu clúster.

Debes verificar que se haya implementado correctamente y sin errores. La página Cargas de trabajo de Kubernetes se debería ver de la siguiente manera:

![Implementación de helloweb sin errores](https://cdn.qwiklabs.com/0Uymx3hvEhcCmtQreOMdkRsBj8DPVPz6Qq0jDuyuUPw%3D)

```bash

echo -e "\e[1mTarea 5: Actualiza y vuelve a implementar tu app\e[0m\n"

echo -e "\e[1m\ePaso1 Reemplaza <todo>\e[0m\n"

echo -e "\n\e[32mBorra la implementación helloweb de tu clúster\e[0m\n"

kubectl delete deployment helloweb -n $NAMESPACE_NAME

echo -e "\n\e[32mImplementación helloweb borrada\e[0m\n"

echo -e "\n\e[32mImplementa el manifiesto actualizado en el espacio de nombres $NAMESPACE_NAME de tu clúster\e[0m\n"

kubectl -n $NAMESPACE_NAME apply -f hello-app/manifests/helloweb-deployment.yaml

kubectl get deployment helloweb -n $NAMESPACE_NAME

echo -e "\n\e[32mManifiesto Implementado\e[0m\n"

```

## Tarea 6: Aloja tu código en contenedores e impleméntalo en el clúster

Por último, como parte de la estrategia de comercio electrónico de Cymbal Shops, el equipo de aplicaciones te proporcionará un código que deberás alojar en contenedores y almacenar en un registro y, luego, deberás actualizar el clúster con la versión más reciente de ese código.

En esta sección, alojarás en contenedores el código de la aplicación, actualizarás una imagen en Artifact Registry y la configurarás en la imagen de tu clúster. Tu equipo tiene un repositorio en Artifact Registry llamado repo name que contiene una versión alojada en contenedores de la app de ejemplo hello-app en Docker. Actualizarás el código de la compilación de forma local y, luego, enviarás una nueva versión al repositorio.

   1. En el directorio hello-app, actualiza el archivo **main.go** para usar Version: 2.0.0 en la línea 49.

   2. Usa hello-app/Dockerfile para crear una imagen de Docker con la etiqueta v2.

      > [!NOTE]
      > **Nota:** Debes seguir las convenciones de nomenclatura de Artifact Registry que se detallan aquí.

    3. Envía la imagen de Docker recién compilada a tu repositorio en Artifact Registry con la etiqueta v2.

    4. Configura la imagen en tu implementación de **helloweb** para reflejar la imagen v2 que enviaste a Artifact Registry.
    
    5. Expón la implementación **helloweb** a un servicio de LoadBalancer llamado ==service name== en el puerto 8080 y establece el puerto de destino del contenedor en el que está especificado en el Dockerfile.
    
    Navega a la dirección IP del balanceador de cargas externo del servicio ==service name==. Deberías ver el siguiente texto que devuelve el servicio:
    
Resultado:

´´´bash
Hello, world!
Version: 2.0.0
Hostname: helloweb-6fc7476576-cvv5f
´´´

> [!NOTE]
> **Nota:** La página web puede tardar unos minutos en cargarse.

```YAML
# prometheus-app.yml
# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https:#www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

apiVersion: apps/v1
kind: Deployment
metadata:
  name: prometheus-test
  labels:
    app: prometheus-test
spec:
  selector:
    matchLabels:
      app: prometheus-test
  replicas: 3
  template:
    metadata:
      labels:
        app: prometheus-test
    spec:
      nodeSelector:
        kubernetes.io/os: linux
        kubernetes.io/arch: amd64
      containers:
      - image: <todo>
        name: <todo>
        ports:
        - name: <todo>
          containerPort: 1234
        command:
        - "/main"
        - "--process-metrics"
        - "--go-metrics"
```

```bash
# pod-monitoring.yaml
# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https:#www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

apiVersion: monitoring.googleapis.com/v1
kind: PodMonitoring
metadata:
  name: <todo>
  labels:
    app.kubernetes.io/name: <todo>
spec:
  selector:
    matchLabels:
      app: <todo>
  endpoints:
  - port: metrics
    interval: <todo>
```