# Implementa una instancia de procesamiento con una secuencia de comandos de inicio remota

## GSP301

![Logotipo de los labs de autoaprendizaje de Google Cloud](https://cdn.qwiklabs.com/GMOHykaqmlTHiqEeQXTySaMXYPHeIvaqa2qHEzw6Occ%3D)

## Descripción general

En un lab de desafío, se le proporcionarán una situación y un conjunto de tareas. En lugar de seguir instrucciones paso a paso, deberás utilizar las habilidades aprendidas en los labs del curso para decidir cómo completar las tareas por tu cuenta. Un sistema automatizado de puntuación (en esta página) mostrará comentarios y determinará si completaste tus tareas correctamente.

En un lab de desafío, no se explican conceptos nuevos de Google Cloud, sino que se espera que amplíes las habilidades que adquiriste, como cambiar los valores predeterminados y leer o investigar los mensajes de error para corregir sus propios errores.

Debe completar correctamente todas las tareas dentro del período establecido para obtener una puntuación del 100%.

Se recomienda este lab a los estudiantes que se inscribieron en la insignia de habilidad [Arquitectura de nube: diseña, implementa y administra](https://www.skills.google/course_templates/640) o que se están preparando para el examen de certificación Google [Cloud Certified Professional Cloud Architect](https://cloud.google.com/certification/cloud-architect). ¿Aceptas el desafío?

## Situación del desafío

Se te asignó la responsabilidad de administrar la configuración de las máquinas virtuales de Google Cloud de tu organización. Decidiste hacer algunos cambios al framework que se usa para administrar las máquinas de implementación y configuración: deseas facilitar la modificación de las secuencias de comandos de inicio que se usan para inicializar una cantidad de instancias de procesamiento. En lugar de almacenar estas secuencias directamente en los metadatos de las instancias, decidiste almacenarlas en un bucket de Cloud Storage y, luego, configurar las máquinas virtuales para que se dirijan al archivo de secuencia de comandos correspondiente en el bucket.

Se te proporcionó una secuencia de comandos Bash básica (llamada `install-web.sh`) que instala el software del servidor web Apache como secuencia de comandos de inicio de muestra. Puedes descargar lo anterior de los vínculos disponibles en la sección Recursos para estudiantes, en el lado izquierdo de la página. También puedes encontrar la secuencia de comandos de inicio en un bucket público de Cloud Storage, en `gs://spls/gsp301/install-web.sh`.

## Tu desafío

Configura una instancia de Compute Engine para Linux que instale el software del servidor web Apache con una secuencia de comandos de inicio remota. Para que se pueda confirmar que se instaló correctamente una instancia de Apache Compute, la instancia de Compute Engine debe ser accesible a través de HTTP desde Internet. Debes crear tu instancia en la siguiente zona: ZONE.

> [!NOTE]
> Nota: Para garantizar un monitoreo exacto de la actividad, no debes modificar ni cambiar ninguno de los recursos de lab creados previamente, en particular, la instancia de Compute Engine lab-monitor.

## Tarea 1: Crea un bucket de almacenamiento

Crear un bucket de almacenamiento

## Tarea 2: Crea una instancia de VM con una secuencia de comandos de inicio remota

Crear una instancia de VM con una secuencia de comandos de inicio remota

## Tarea 3: Crea una regla de firewall para permitir el tráfico (80/TCP)

Crear una regla de firewall para permitir el tráfico (80/TCP)

## Tarea 4. Comprueba que la VM está entregando contenido web

Comprobar que la VM está entregando contenido web

## Sugerencias y trucos

**Configura los metadatos de la instancia**. En la página de documentación sobre cómo ejecutar secuencias de comandos de inicio, se explica cómo pueden usarse los metadatos de la instancia de Compute Engine para configurar las secuencias de comandos de inicio.

**Comprueba si tu instancia de Compute Engine ejecuta la secuencia de comandos de inicio**. Usa la consola en serie de la máquina virtual en ejecución para analizar los eventos de inicio y asegurarte de que la secuencia de comandos de inicio se esté ejecutando.

**Comprueba los permisos**. Es posible que tu instancia de Compute Engine no cuente con los permisos correctos que se requieren para leer la secuencia de comandos de inicio desde el bucket de almacenamiento. La máquina virtual debe contar con permisos alineados con los permisos de almacenamiento.

**Comprueba los firewalls**. Es posible que no puedas conectarte si la secuencia de comandos de inicio instaló el software, pero no se configuró correctamente un firewall.
Comprueba la URL y la dirección. No podrás conectarte al servidor web Apache si intentas acceder a la instancia de Compute Engine con una dirección HTTPS en lugar de una HTTP, o si usas la dirección IP incorrecta. Comprueba que tu URL sea http://[EXTERNAL_IP] y no https://[EXTERNAL_IP] ni http://[INTERNAL_IP].

## Soluciones Prevista

1. Para esta solución pensé que se debia crear una cuenta de servicio, crear un rol y vincularlo a la cuenta de servicio. por lo cual tenia el siguiente código preparado.

2. Aunque no se pide explicitamente los servicios deben comunicarse por lo cual se necesita una cuenta de servicio y sus respectivo rol

   ```bash
    #Creación del Rol
    gcloud iam roles create $CUSTOM_ROLE_NAME \
        --project=$PROJECT_ID \
        --title="Rol de Lectura del Bucket" \
        --description="Custom Role Description" \
        --permissions=storage.objects.get

   gcloud iam service-accounts create $ACCOUNT_SERVICE --display-name="Web Server Service Account"

   gcloud storage buckets add-iam-policy-binding gs://$BUCKET_NAME --member="serviceAccount:$ACCOUNT_SERVICE@$PROJECT_ID.iam.gserviceaccount.com" --role=$CUSTOM_ROLE_NAME
   ```

Al intentar ejecutarlo obtuve el error `ERROR: (gcloud.iam.roles.create) does not have permission to access projects instance`

1. Ok primera dificultad aunque en un entorno real mi estrategia de crear un rol con los permisos mínimos necesarios es mejor, tengo que adaptarme al laboratorio. Entonces para no perder tiempo ya que no tenia preparado los comandos para consultar usuario por la consola de cloud shell, fui a la consola de google busque en `IAM` y vi que ya habia una cuenta de servicio con el permiso de `StorageAdmin` la cual tenia el formato `[ID_PROYECTO]@[ID_PROYECTO].iam.gserviceaccount.com`
   [Pantalla IAM](./images/IAM.png)

2. Dificultad al momento de reclamar los puntos del Connect to the server ip-address us... `Comprobar que la VM está entregando contenido web` me daba error por lo cual intente entrar desde el navegador usando la ip externa y no cargaba. Asi que hice una pequeña auditoria
   1. Busque en `Compute Engine` -> `VM instance` la instancia creada verifique que estuviera sana y que tuviera la etiqueta de red asignada
      [Pantalla de VM](./images/vm_view.png)

   2. Luego fui a `VPC` -> `Firewall Rules` y verifique a que instancias aplica
      [Pantalla de Reglas de Firewall](./images/firewall_view.png)

   3. Sino es la instancia ni la reglas de firewall debía ser la secuencias de comandos esto fue mas por intuicion y experiencia que por sabiduria y aunque sabia que queria hacer no sabia como pero en las notas del lab hay una que dice "Configura los metadatos de la instancia. En la página de documentación sobre cómo ejecutar secuencias de comandos de inicio" y lleva al siguiente link <https://docs.cloud.google.com/compute/docs/instances/startup-scripts?hl=es-419> de las opciones mostrada en la lista seleccione Pasa una secuencia de comandos de inicio desde Cloud Storage VM Linux verifique en Pasa una secuencia de comandos de inicio de Linux desde Cloud Storage que todo estuviera como lo plantie y vi 2 comandos interesante Vuelve a ejecutar una secuencia de comandos de inicio de Linux `sudo google_metadata_script_runner startup` y Visualiza el resultado de una secuencia de comandos de inicio de Linux `sudo journalctl -u google-startup-scripts.service`

   4. Fui de nuevo a `Compute Engine` me conecte por ssh y ejecute el comando

      ```bash
      student-00-405485963dca@web-server:~$ sudo journalctl -u google-startup-scripts.service

       -- Journal begins at Wed 2026-05-13 02:46:38 UTC, ends at Wed 2026-05-13 03:03:37 UTC. --

       May 13 02:46:51 web-server systemd[1]: Starting Google Compute Engine Startup Scripts...
       .
       .
       .
       May 13 02:46:53 web-server google_metadata_script_runner[915]: Script "startup-script-url" failed with error: exit status 100
      ```

   5. Aunque tengo conocimientos de `GCP` no domino todo entonces consulte con `Gemini` y me dijo

      ```txt
      Efectivamente, los logs de journalctl confirman que el problema no es de comunicación entre la instancia y el bucket, sino de la ejecución interna del contenido del script.
      ...
      ¿Has verificado si el contenido del archivo install-web.sh en el bucket coincide exactamente con la sintaxis requerida para la versión de Debian (11) que estás instanciando?
      ```

   6. Ejecute `gcloud storage cat gs://$BUCKET_NAME/install-web.sh`

      ```bash
      gcloud storage cat gs://$BUCKET_NAME/install-web.sh
       #!/bin/bash
      apt-get update
      apt-get install -y apache2
      ```

      y ese espacio en blanco era es que daño todo

   7. Ya con la presión del tiempo mi solución efectiva pero no la mejor fue acomodar el archivo eliminar la instancia y montarla de nuevo

      ```bash
      cat <<EOF > install-web.sh
      #!/bin/bash
      apt-get update
      apt-get install -y apache2
      EOF

      gcloud storage cp install-web.sh gs://$BUCKET_NAME/install-web.sh
      ```

> [!NOTE]
> creo que lo mejor hubiese sido arreglar el archivo y decirle a la VM que lo ejecutara de nuevo con el comando que menciona antes que me llamo la atencion o detener la instancia y correrla de nuevo. Como no se cuantos creditos me queden al final del curso no voy a probar ahora pero si tengo los suficientes lo hare y actualizare estas notas

## Solución Final

Pasos previos

Definir la zona y la región

```bash
ZONE="<ingrese la zona del lab>"
REGION="<ingrese la region>"
BUCKET_NAME="<ingrese un nombre para el bucket>" #recuerde que debe ser único a nivel global
PROJECT_ID=$(gcloud config list --format="value(core.project)")
TAG="network-lab"
```

1. Crear el bucket

   Para crear el bucket lo podemos hacer por la consola de Cloud Shell o la consola de GCP.
   Por la consola de Cloud Shell:

   ```bash
   gcloud storage buckets create gs://$BUCKET_NAME --location=$REGION
   # gsutil cp gs://spls/gsp301/install-web.sh gs://$BUCKET_NAME/install-web.sh
   #Ya que tenemos error haciendolo asi
   cat <<EOF > install-web.sh
   #!/bin/bash
   apt-get update
   apt-get install -y apache2
   EOF

   gcloud storage cp install-web.sh gs://$BUCKET_NAME/install-web.sh
   ```

2. Crea una instancia de VM con una secuencia de comandos de inicio remota

   Para crear la instancia de VM con una secuencia de comandos de inicio remota, lo podemos hacer por la consola de Cloud Shell o la consola de GCP.
   Por la consola de Cloud Shell:

   ```bash
   gcloud compute instances create web-server \
        --zone=$ZONE \
        --machine-type=e2-small \
        --image-family=debian-11 \
        --image-project=debian-cloud \
        --metadata startup-script-url=gs://$BUCKET_NAME/install-web.sh \
        --service-account=$PROJECT_ID@$PROJECT_ID.iam.gserviceaccount.com \
        --tags=$TAG
   ```

3. Crea una regla de firewall para permitir el tráfico (80/TCP)

   Para crear una regla de firewall para permitir el tráfico (80/TCP

   ```bash
       gcloud compute firewall-rules create firewall-network \
           --target-tags $TAG \
           --allow tcp:80
   ```

4. Comprueba que la VM está entregando contenido web

   Para comprobar que la VM está entregando contenido web, lo podemos hacer por la consola de Cloud Shell o la consola de GCP.
   Por la consola de Cloud Shell:

   ```bash
   EXTERNAL_IP=$(gcloud compute instances describe web-server --zone=$ZONE --format='get(networkInterfaces[0].accessConfigs[0].natIP)')
   curl http://$EXTERNAL_IP
   ```
