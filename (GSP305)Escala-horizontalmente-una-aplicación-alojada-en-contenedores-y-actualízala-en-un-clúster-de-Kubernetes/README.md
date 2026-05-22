# Escala horizontalmente una aplicación alojada en contenedores y actualízala en un clúster de Kubernetes

## [GSP305](https://www.skills.google/paths/125/course_templates/640/labs/613294)

![Logotipo de los labs de autoaprendizaje de Google Cloud](https://cdn.qwiklabs.com/GMOHykaqmlTHiqEeQXTySaMXYPHeIvaqa2qHEzw6Occ%3D)

## Introducción

En un lab de desafío, se le proporcionarán una situación y un conjunto de tareas. En lugar de seguir instrucciones paso a paso, deberás utilizar las habilidades aprendidas en los labs del curso para decidir cómo completar las tareas por tu cuenta. Un sistema automatizado de puntuación (en esta página) mostrará comentarios y determinará si completaste tus tareas correctamente.

En un lab de desafío, no se explican conceptos nuevos de Google Cloud, sino que se espera que amplíes las habilidades que adquiriste, como cambiar los valores predeterminados y leer o investigar los mensajes de error para corregir sus propios errores.

Debe completar correctamente todas las tareas dentro del período establecido para obtener una puntuación del 100%.

Se les recomienda este lab a los estudiantes que se están preparando para el examen de certificación[Google Cloud Certified Professional Cloud Architect.](https://cloud.google.com/certification/cloud-architect) ¿Aceptas el desafío?

## Situación del desafío

Estarás a cargo de un entorno de pruebas, para lo cual se te proporciona una versión actualizada de una aplicación de prueba alojada en contenedores para que la implementes. El equipo de arquitectura de tu sistema comenzó a adoptar una arquitectura de microservicios alojada en contenedores. Eres responsable de administrar las aplicaciones web de prueba alojadas en contenedores. Primero, implementarás la versión inicial de una aplicación de prueba (echo-app) en un clúster de Kubernetes (echo-cluster) de la implementación echo-web. El clúster se implementará en la zona ZONE.

1. Antes de comenzar, selecciona **Cloud Storage > Buckets** en el **menú de navegación**.

2. Verifica que el archivo `echo-web-v2.tar.gz` esté en el bucket ==bucket name==.

   ![Navegador de Storage que contiene el bucket correspondiente](https://cdn.qwiklabs.com/RKx%2Beyre8biFcFibTkCaSr9cy0rNnHR6p4RHDe0TxFs%3D)

   Luego, antes de continuar, comprueba que el clúster de GKE se haya creado.

3. En el **menú de navegación**, selecciona **Kubernetes Engine > Clústeres.**

   Continúa cuando veas una marca de verificación verde junto a `echo-cluster`:

   [echo-cluster con marca de verificación verde en la página de clústeres de Kubernetes](https://cdn.qwiklabs.com/kmqz8VQgu%2BTGMvF1yIjOu3ynvxfVGiUlXS6q3LFdbJc%3D)

4. Para implementar la primera versión de la aplicación, ejecuta los siguientes comandos en Cloud Shell para ponerla en funcionamiento:

   `gcloud container clusters get-credentials echo-cluster --zone=ZONE`

   `kubectl create deployment echo-web --image=gcr.io/qwiklabs-resources/echo-app:v1`

   `kubectl expose deployment echo-web --type=LoadBalancer --port 80 --target-port 8000`

## Tu desafío

Debes actualizar el código v1 de la aplicación `echo-app` en ejecución en la implementación `echo-web` al código v2 que recibiste. También debes escalar la aplicación horizontalmente a 2 instancias y confirmar que se estén ejecutando.

## Tarea 1: Compilar e implementar la aplicación actualizada con una nueva etiqueta

La aplicación de ejemplo actualizada, que incluye los archivos de contexto de la aplicación y el Dockerfile, se encuentra en el archivo echo-web-v2.tar.gz. El archivo se copió en un bucket de Cloud Storage en tu proyecto de lab con el nombre bucket name. El código v2 de la aplicación agrega el número de versión a los datos de la aplicación. En esta tarea, descargarás el archivo, compilarás la imagen de Docker y le asignarás la etiqueta v2.

**Solución Tarea 1:**

1. Descargar el archivo `echo-web-v2.tar.gz` desde el bucket de Cloud Storage hacia el cloud shell

2. Descomprimir el archivo `echo-web-v2.tar.gz`

3. Construir la imagen con la etiqueta v2

```bash
PROJECT_ID=$(gcloud config list --format="value(core.project)")
BUCKET_NAME=<Ingrese el nombre del bucket>
ZONE=<Ingrese la zona del lab>

echo -e "\Pre-requisitos\e[0m\n"

gcloud container clusters get-credentials echo-cluster --zone=$ZONE
kubectl create deployment echo-web --image=gcr.io/qwiklabs-resources/echo-app:v1
kubectl expose deployment echo-web --type=LoadBalancer --port 80 --target-port 8000


echo -e "\e[1mTarea 1: Compilar e implementar la aplicación actualizada con una nueva etiqueta\e[0m\n"

echo -e "Paso 1 Descargar el archivo echo-web-v2.tar.gz desde el bucket de Cloud Storage hacia el cloud shell\n"
mkdir echo-web-v2
cd echo-web-v2
gcloud storage cp gs://$BUCKET_NAME/echo-web-v2.tar.gz .
echo -e "\n\e[32mArchivo descargado\e[0m\n"

echo -e "Paso 2 Descomprimir el archivo echo-web-v2.tar.gz\n"
tar -xvf echo-web-v2.tar.gz

echo -e "\n\e[32mArchivo descomprimido\e[0m\n"

echo -e "Paso 3 Construir la imagen con la etiqueta v2\n"

docker build -t echo-app:v2 .

cd ..

echo -e "\n\e[32mImagen construida\e[0m\n"

```

## Tarea 2: Envía la imagen a Container Registry

Tu organización utiliza Container Registry para alojar imágenes de Docker para las implementaciones. Además, utiliza el nombre de host gcr.io de Container Registry para todos los proyectos. Debes enviar la imagen actualizada a Container Registry antes de implementarla.

**Solución Tarea 2:**

1. Etiquetar la imagen local para que docker sepa a donde subirla

2. Enviar la imagen a Google Container Registry.

```bash
echo -e "\e[1mTarea 2: Envía la imagen a Container Registry\e[0m\n"

echo -e "Paso 1 etiquetando la imagen para enviar a Google Container Registry\n"

docker tag echo-app:v2 gcr.io/$PROJECT_ID/echo-app:v2

echo -e "\n\e[32mImagen etiquetada\e[0m\ n"

echo -e "Paso 2 enviando la imagen a Google Container Registry\n"

docker push gcr.io/$PROJECT_ID/echo-app:v2
```

Comprobar que hay una imagen etiquetada en gcr.io para echo-app:v2

## Tarea 3: Implementa la aplicación actualizada en el clúster de Kubernetes

En esta tarea, implementarás la aplicación actualizada en el clúster de Kubernetes. El nombre de la implementación debe ser echo-web y la aplicación se debe exponer en el puerto 80. La aplicación debe ser accesible desde fuera del clúster.

Implementar la versión de la aplicación actualizada (v2) en el clúster de Kubernetes

**Solución Tarea 3:**

1. Actualizar imagen del deployment

```bash

echo -e "\e[1mTarea 3: Implementa la aplicación actualizada en el clúster de Kubernetes\e[0m\n"

echo -e "Paso 1 Actualizar imagen del deployment\n"

kubectl set image deployment/echo-web echo-app=gcr.io/$PROJECT_ID/echo-app:v2

echo -e "\n\e[32mDeployment Actualizado\e[0m\n"

```

## Tarea 4: Escala horizontalmente la aplicación

En esta tarea, tendrás que escalar horizontalmente la aplicación a 2 réplicas.

Escalar horizontalmente la aplicación de Kubernetes para que ejecute 2 réplicas

**Solución Tarea 4:**

1. Aumentar las replicas a 2

```bash

echo -e "\e[1mTarea 4: Escala horizontalmente la aplicación\e[0m\n"

echo -e "Paso 1 Aumentar las replicas a 2\n"

kubectl scale deployment echo-web --replicas=2

echo -e "\n\e[32mReplicas aumentadas\e[0m\n"
```

## Tarea 5: Confirma que la aplicación se esté ejecutando

En esta tarea, tendrás que confirmar que la aplicación se esté ejecutando y que responda correctamente. Puedes usar la dirección IP externa de la aplicación para probarla.

**Solución Tarea 5:**

1. Verificar que el servicio de la aplicación implementado responde correctamente

```bash
echo -e "\e[1mTarea 5: Confirma que la aplicación se esté ejecutando\e[0m\n"

kubectl get services

# 1. Asignar la IP externa a la variable IP_SERVICE
IP_SERVICE=$(kubectl get service echo-web -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# 2. Verificar que se guardó correctamente
echo $IP_SERVICE

# 3. Hacer el curl a esa dirección en el puerto 80
curl http://$IP_SERVICE

```

Soluciona problemas
Error 504 (error de tiempo de espera de puerta de enlace): Esto podría indicar que la aplicación aún no se inicializó, pero también podría deberse a una falta de coincidencia entre el puerto predeterminado establecido en el Dockerfile (puerto TCP 8000) y:

La elección del puerto de aplicación que configuraste al implementar la imagen de la aplicación
El momento en que configuraste el acceso externo
