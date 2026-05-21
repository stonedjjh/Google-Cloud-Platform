# Artifact Registry

Un gestor de paquetes universal para todos tus artefactos y dependencias de compilación. Rápido, escalable, fiable y seguro.

Artifact Registry proporciona una única ubicación para gestionar paquetes privados e imágenes de contenedores Docker.

## Repositorios

Para trabajar con repositorios se usa el comando `gcloud artifacts repositories`

### Crear un repositorio

Para crear un repositorio se usa el comando `gcloud artifacts repositories create`

**Ejemplo:**

```bash
gcloud artifacts repositories create quickstart-docker-repo --repository-format=docker \
    --location=us-west1 --description="Docker repository" \
    --project=PROJECT
```

En este ejemplo:

- `quickstart-docker-repo` es el nombre del repositorio

- `--repository-format` es el flag que permite establecer el formato del repositorio

- `--location` es el flag que permite establecer la ubicación del repositorio

- `--description` es el flag que permite establecer la descripción del repositorio

- `--project` es el flag que permite establecer el proyecto

### Configurar la autenticación

Antes de poder enviar o extraer imágenes, configura Docker para que use la CLI de Google Cloud con el fin de autenticar las solicitudes a Artifact Registry.

Para configurar la autenticación en los repositorios de Docker de la región us-west1, ejecuta el siguiente comando:

`gcloud auth configure-docker us-west1-docker.pkg.dev`

El comando actualiza tu configuración de Docker. Ahora puedes conectarte a Artifact Registry en tu Google Cloud proyecto para insertar y 
extraer imágenes.

`gcloud auth configure-docker "REGION"-docker.pkg.dev`

### Obtener una imagen

En esta guía de inicio rápido, enviarás una imagen de muestra llamada hello-app.

Ejecuta el siguiente comando para extraer la versión 1.0 de la imagen.

   `docker pull us-docker.pkg.dev/google-samples/containers/gke/hello-app:1.0`

Las rutas de las imágenes en Artifact Registry incluyen varias partes. En esta imagen de muestra:

- **us-docker.pkg.dev** es el nombre de host de las imágenes de contenedor almacenadas en los repositorios de Docker de Artifact Registry, que incluye la ubicación del repositorio (us).

- **google-samples** es el ID del proyecto.

- **containers** es el ID del repositorio.

- **/gke/hello-app** es la ruta de la imagen en el repositorio containers.

### Enviar una imagen

Para envir una imagen al repositorio de Artifact Registry, ejecuta el siguiente comando

```bash
docker push us-east4-docker.pkg.dev/qwiklabs-gcp-01-9ef12446a57a/my-repository/node-app:0.2
The push refers to repository [us-east4-docker.pkg.dev/qwiklabs-gcp-01-9ef12446a57a/my-repository/node-app]
c2d50c56f947: Pushed 
4de66d18d68b: Pushed 
2e51c50554dc: Pushed 
f6c63d283d3f: Pushed 
4adf95fdf6b4: Pushed 
cc4895a79c8a: Pushed 
4887723d153c: Pushed 
a234579dfb0d: Pushed 
0ce041001b89: Pushed 
29fd6050affe: Pushed 
d76470c50f00: Pushed 
0.2: digest: sha256:f88b7aa19a270ecc575f661a1a39885f5db98c80929a5bd4c47e02ecb11acf5c size: 856
```

En este ejemplo:

- `us-east4-docker.pkg.dev` es la ubicación del repositorio

- `qwiklabs-gcp-01-9ef12446a57a` es el ID del proyecto

- `my-repository` es el ID del repositorio

- `node-app:0.2` es la ruta de la imagen

