# Administra Kubernetes en Google Cloud

## [GSP304](https://www.skills.google/paths/125/course_templates/640/labs/613293)

![Logotipo de los labs de autoaprendizaje de Google Cloud](https://cdn.qwiklabs.com/GMOHykaqmlTHiqEeQXTySaMXYPHeIvaqa2qHEzw6Occ%3D)

## Introducción

En un lab de desafío, se le proporcionarán una situación y un conjunto de tareas. En lugar de seguir instrucciones paso a paso, deberás utilizar las habilidades aprendidas en los labs del curso para decidir cómo completar las tareas por tu cuenta. Un sistema automatizado de puntuación (en esta página) mostrará comentarios y determinará si completaste tus tareas correctamente.

En un lab de desafío, no se explican conceptos nuevos de Google Cloud, sino que se espera que amplíes las habilidades que adquiriste, como cambiar los valores predeterminados y leer o investigar los mensajes de error para corregir sus propios errores.

Debe completar correctamente todas las tareas dentro del período establecido para obtener una puntuación del 100%.

Se les recomienda este lab a los estudiantes que se están preparando para el examen de certificación[Google Cloud Certified Professional Cloud Architect.](https://cloud.google.com/certification/cloud-architect) ¿Aceptas el desafío?

## Situación del desafío

Tu equipo de desarrollo desea adoptar un enfoque de microservicios alojados en contenedores para la arquitectura de aplicaciones. Debes probar la aplicación de ejemplo que te proporcionaron para garantizar que se pueda implementar en un contenedor de Google Kubernetes. El grupo de desarrollo proporcionó una aplicación sencilla en Go, llamada `echo-web`, con un Dockerfile y el contexto asociado, para que puedas crear una imagen de Docker inmediatamente.

## Tu desafío

Para probar la implementación, debes descargar la aplicación de ejemplo y, luego, crear la imagen del contenedor de Docker con una etiqueta que permita almacenarla en Container Registry. Una vez que se haya creado la imagen, debes enviarla a Container Registry para poder implementarla.

Con la imagen preparada, puedes crear un clúster de Kubernetes y, luego, implementar la aplicación de ejemplo en el clúster.

Nota: Para garantizar un monitoreo preciso de la actividad del lab, debes asignarle el nombre echo-app a la imagen del repositorio del contenedor y echo-cluster al clúster de Kubernetes. Además, debes crear el clúster de Kubernetes en la zona ZONE y usar echo-web como nombre de la implementación.

## Tarea 1: Crea un clúster de Kubernetes

Tu entorno de pruebas tiene una capacidad limitada, por lo que debes restringir el clúster de Kubernetes de prueba que estás creando a solo dos instancias `e2-standard-2`. Debes asignarle el nombre `echo-cluster` al clúster.

**Solución Tarea 1:**

Ok este paso es sencillo es crear un cluster llamado echo-cluster y solo nos piden que la familia de instancia sea `e2-standard-2` y 2 nodos, por defecto son 3.  Se njecesita la Zona pero esa la obtendremos de lab.

```bash
ZONE=<Ingrese zona del lab>

echo -e "\e[1mTarea 1: Crea un clúster de Kubernetes\e[0m\n"

gcloud container clusters create echo-cluster --zone=$ZONE --num-nodes=2 --machine-type=e2-standard-2

echo -e "\n\e[32mCluster Creado\e[0m\n"
```

## Tarea 2: Crea una imagen etiquetada de Docker

La aplicación de ejemplo, incluidos el Dockerfile y los archivos de contexto de la aplicación, se encuentran en un archivo llamado `echo-web.tar.gz`. El archivo se copió en el bucket de Cloud Storage que pertenece al proyecto del lab llamado `gs://[PROJECT_ID]`.

- Debes implementar esto con una etiqueta llamada v1.

**Solución Tarea 2:**

1. Descargar el archivo `echo-web.tar.gz` desde el bucket de Cloud Storage hacia el cloud shell

2. Descomprimir el archivo `echo-web.tar.gz`

3. Ubicar el Dockerfile.

4. Construir la imagen con la etiqueta v1.

```bash
PROJECT_ID=$(gcloud config list --format="value(core.project)")

echo -e "\e[1mTarea 2: Crea una imagen etiquetada de Docker\e[0m\n"

echo -e "Paso 1 Descargar el archivo echo-web.tar.gz desde el bucket de Cloud Storage hacia el cloud shell\n"
gcloud storage cp gs://$PROJECT_ID/echo-web.tar.gz .

echo -e "\n\e[32mArchivo descargado\e[0m\n"

echo -e "Paso 2 Descomprimir el archivo echo-web.tar.gz\n"
tar -xvf echo-web.tar.gz

echo -e "\n\e[32mArchivo descomprimido\e[0m\n"

echo -e "Paso 3 Ubicar el Dockerfile\n"
cd echo-web

echo -e "\n\e[32mDockerfile ubicado\e[0m\n"

echo -e "Paso 4 Construir la imagen con la etiqueta v1\n"
docker build -t echo-web:v1 .

echo -e "\n\e[32mImagen construida\e[0m\n"
```

> [!NOTE]
> Al descomprimir el archivo todos los archivos se descromprimieron en la raiz del directorio. Como actualización se recomienda crear una carpeta y trabajar en ella.

## Tarea 3: Envía la imagen a Google Container Registry

Tu organización decidió que siempre usará el nombre de host gcr.io de Container Registry para todos los proyectos. La aplicación de ejemplo es una app web sencilla que informa algunos datos que describen la configuración del sistema donde se ejecuta. Está configurada para usar el puerto TCP 8000 de forma predeterminada.

**Solución Tarea 3:**

1. Etiquetar la imagen local para que docker sepa a donde subirla
1. Enviar la imagen a Google Container Registry.

```bash
echo -e "\e[1mTarea 3: Envía la imagen a Google Container Registry\e[0m\n"

echo -e "Paso 1 etiquetando la imagen para enviar a Google Container Registry\n"

docker tag echo-web:v1 gcr.io/$PROJECT_ID/echo-app:v1

echo -e "\n\e[32mImagen etiquetada\e[0m\n"

echo -e "Paso 2 enviando la imagen a Google Container Registry\n"

docker push gcr.io/$PROJECT_ID/echo-app:v1

echo -e "\n\e[32mImagen enviada a Google Container Registry\e[0m\n"
```

## Tarea 4: Implementa la aplicación en el clúster de Kubernetes

Si bien la aplicación está configurada para responder a las solicitudes HTTP en el puerto 8000, debes configurar el servicio para que responda a las solicitudes web normales en el puerto 80. Cuando configures el clúster para la aplicación de ejemplo, asígnale el nombre echo-web a la implementación.

**Solución Tarea 4:**

1. Crear echo-web.yaml

2. Ejecutar el deployment

```bash

echo -e "\e[1mTarea 4: Implementa la aplicación en el clúster de Kubernetes\e[0m\n"

echo -e "Paso 1 Crear echo-web.yaml\n"

touch echo-web.yaml

cat << EOF > echo-web.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: echo-web
  labels:
    app: echo-web
spec:
  replicas: 2
  selector:
    matchLabels:
      app: echo-web
  template:
    metadata:
      labels:
        app: echo-web
    spec:
      containers:
      - name: echo-web
        image: gcr.io/$PROJECT_ID/echo-app:v1
        ports:
        - containerPort: 8000
---
apiVersion: v1
kind: Service
metadata:
  name: echo-app
spec:
  type: LoadBalancer
  selector:
    app: echo-web
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8000
EOF

echo -e "\n\e[32mArchivo echo-web.yaml creado\e[0m\n"

echo -e "Paso 2 Ejecutar el deployment\n"

kubectl apply -f echo-web.yaml

echo -e "\n\e[32mDeployment creado\e[0m\n"
      
```

> [!TIP]
> Este ultimpo paso tambien se puede resolver de forma imperativa
> `kubectl create deployment echo-web --image=gcr.io/$PROJECT_ID/echo-app:v1`
> `kubectl expose deployment echo-web --type=LoadBalancer --name=echo-app --port=80 --target-port=8000`

## Soluciona problemas

**Error de tiempo de espera de puerta de enlace, 504:** Esto podría indicar que la aplicación aún no se inicializa, pero también podría deberse a una falta de coincidencia entre el puerto predeterminado establecido en el Dockerfile (puerto TCP 8000) y la elección del puerto de aplicación que configuraste al implementar la imagen de la aplicación o al configurar el acceso externo.

**Últimos tres objetivos sin una puntuación de evaluación:** Esto podría indicar que no creaste el clúster de Kubernetes en la zona ==ZONE== como se espera en el lab, sino en otra.
