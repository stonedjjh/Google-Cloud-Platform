# Implementa un sitio web y soluciona problemas

## [GSP101](https://www.skills.google/paths/125/course_templates/640/labs/613296)

![Logotipo de los labs de autoaprendizaje de Google Cloud](https://cdn.qwiklabs.com/GMOHykaqmlTHiqEeQXTySaMXYPHeIvaqa2qHEzw6Occ%3D)

## Introducción

En un lab de desafío, se le proporcionarán una situación y un conjunto de tareas. En lugar de seguir instrucciones paso a paso, deberás utilizar las habilidades aprendidas en los labs del curso para decidir cómo completar las tareas por tu cuenta. Un sistema automatizado de puntuación (en esta página) mostrará comentarios y determinará si completaste tus tareas correctamente.

En un lab de desafío, no se explican conceptos nuevos de Google Cloud, sino que se espera que amplíes las habilidades que adquiriste, como cambiar los valores predeterminados y leer o investigar los mensajes de error para corregir sus propios errores.

Debe completar correctamente todas las tareas dentro del período establecido para obtener una puntuación del 100%.

Se les recomienda este lab a los estudiantes que se están preparando para el examen de certificación[Google Cloud Certified Professional Cloud Architect.](https://cloud.google.com/certification/cloud-architect) ¿Aceptas el desafío?

## Situación del desafío

Tu empresa está lista para lanzar un producto nuevo. Dado que incursionarás en un mercado completamente nuevo, decides implementar un sitio web específico como parte del lanzamiento del producto. El sitio está terminado, pero la persona que lo desarrolló abandonó la empresa antes de poder implementarlo.

## Tu desafío

Tu desafío es implementar el sitio en la nube pública. Para ello, debes completar las tareas que aparecen a continuación. En este ejercicio, usarás un servidor web Apache sencillo como marcador de posición para el sitio nuevo. ¡Buena suerte!

## Ejecuta un servidor web Apache básico

Una instancia de máquina virtual en Compute Engine puede controlarse como cualquier servidor Linux estándar. Implementa un servidor web Apache sencillo (un marcador de posición para el sitio del producto nuevo) para aprender los conceptos básicos de ejecutar un servidor en una instancia de máquina virtual.

## Tarea 1: Crea una instancia de VM de Linux

Crea una máquina virtual de Linux, asígnale el nombre ==Instance name== y especifica la zona como ==Compute zone==.

**Solución Tarea 1:**

1. Crear la maquina virtual, no se especifica la familia por la cual solo es para apache se usara una e2-medium, tambien se le asignara un tag para vincular las reglas de firewall

```bash
ZONE=<Ingrese la zona del lab>
INSTANCE_NAME=<Ingrese el nombre de la instancia>

echo -e "\e[1mTarea 1: Crea una instancia de VM de Linux\e[0m\n"

echo -e "Paso 1 Crear la maquina virtual\n"

gcloud compute instances create $INSTANCE_NAME \
  --zone=$ZONE \
  --tags=apache-server,http-server \
  --machine-type=e2-medium \
  --image-family=debian-11 \
  --image-project=debian-cloud

echo -e "\n\e[32mMaquina virtual creada\e[0m\n"

```

> [!TIP]
> Comportamiento del Validador: Aunque la lógica de red estándar dicta crear una regla personalizada y vincularla mediante un tag propio (como apache-server), el script de evaluación automática de este laboratorio busca estrictamente la metadata nativa del sistema. Es obligatorio inyectar el tag http-server (sin espacios después de la coma) para forzar el aprobado del laboratorio, a pesar de que la regla por defecto default-allow-http haya sido eliminada del proyecto.

## Tarea 2: Habilita el acceso público a una instancia de VM

Mientras creas la instancia de Linux, asegúrate de aplicar las reglas de firewall apropiadas, de modo que los clientes potenciales puedan encontrar tu nuevo producto.

**Solución Tarea 2:**

1. Crear una regla de firewall que permita el trafico desde internet por el puerto 80

```bash

echo -e "\e[1mTarea 2: Habilita el acceso público a una instancia de VM\e[0m\n"

gcloud compute firewall-rules create fw-allow-http-traffic \
  --network=default \
  --action=allow \
  --direction=ingress \
  --source-ranges=0.0.0.0/0 \
  --target-tags=apache-server \
  --rules=tcp:80

echo -e "\n\e[32mRegla de firewall creada\e[0m\n"

```

## Tarea 3: Ejecuta un servidor web Apache básico

Una instancia de máquina virtual en Compute Engine puede controlarse como cualquier servidor Linux estándar.

Implementa un servidor web Apache sencillo (un marcador de posición para el sitio del producto nuevo) para aprender los conceptos básicos de ejecutar un servidor en una instancia de máquina virtual.

**Solución Tarea 3:**

1. Agregar metadata al inicio

2. Reiniciar el servidor

```bash

echo -e "\e[1mTarea 3: Ejecuta un servidor web Apache básico\e[0m\n"

echo -e "Paso 1 Agregar metadata al inicio\n"

gcloud compute instances add-metadata $INSTANCE_NAME \
    --zone=$ZONE \
    --metadata=startup-script='#!/bin/bash
      apt-get update
      apt-get install apache2 -y
      service apache2 restart
      echo "
<h3>Web Server: www1</h3>" | tee /var/www/html/index.html'

echo -e "\n\e[32mMetadata agregada\e[0m\n"

echo -e "Paso 2 Reiniciar el servidor\n"

gcloud compute instances reset $INSTANCE_NAME --zone=$ZONE

echo -e "\n\e[32mServidor reiniciado\e[0m\n"

```

## Tarea 4: Prueba el servidor

Verifica que la instancia esté entregando tráfico en su IP externa.
Deberías ver la página “Hello World!” (un marcador de posición para el sitio del producto nuevo).

Haz clic en Revisar mi progreso para verificar el objetivo.

Probar el servidor
Soluciona problemas
Error de conexión rechazada:
Tu instancia de VM no es accesible de manera pública, ya que no cuenta con la etiqueta apropiada que le permite a Compute Engine aplicar las reglas de firewall correspondientes o tu proyecto no tiene una regla de firewall que permita el tráfico a la dirección IP externa de la instancia.
Intenta acceder a la VM mediante una dirección HTTPS. Comprueba que tu URL sea http://IP_EXTERNA y no https://IP_EXTERNA.
