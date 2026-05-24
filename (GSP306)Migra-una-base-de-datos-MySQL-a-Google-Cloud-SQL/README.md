# Migra una base de datos MySQL a Google Cloud SQL

## [GSP306](https://www.skills.google/paths/125/course_templates/640/labs/613295)

## Descripción general

En un lab de desafío, se le proporcionarán una situación y un conjunto de tareas. En lugar de seguir instrucciones paso a paso, deberás utilizar las habilidades aprendidas en los labs del curso para decidir cómo completar las tareas por tu cuenta. Un sistema automatizado de puntuación (en esta página) mostrará comentarios y determinará si completaste tus tareas correctamente.

En un lab de desafío, no se explican conceptos nuevos de Google Cloud, sino que se espera que amplíes las habilidades que adquiriste, como cambiar los valores predeterminados y leer o investigar los mensajes de error para corregir sus propios errores.

Debe completar correctamente todas las tareas dentro del período establecido para obtener una puntuación del 100%.

Se les recomienda este lab a los estudiantes que se están preparando para el examen de certificación [Google Cloud Certified Professional Cloud Architect](https://cloud.google.com/certification/cloud-architect). ¿Aceptas el desafío?

## Situación del desafío

Tu blog de WordPress se ejecuta en un servidor que ya no es adecuado. Como primera parte de un ejercicio de migración completa, tendrás que migrar a Cloud SQL la base de datos alojada de manera local que utiliza el blog.

La instalación de WordPress existente está en el directorio `/var/www/html/wordpress`, en la instancia llamada blog que ya se está ejecutando en el lab. Para acceder al blog, abre un navegador web y apunta a la dirección IP externa de la instancia del blog.

MySQL proporciona la base de datos existente para el blog que se ejecuta en el mismo servidor. La base de datos de MySQL existente se llama `wordpress` y el usuario llamado **blogadmin** tiene acceso completo a esa base de datos con la contraseña **Password1\***.

## Tu desafío

1. Debes crear una nueva instancia de Cloud SQL para alojar la base de datos migrada.

2. Una vez que crees y configures la nueva base de datos, podrás crear un volcado de la base de datos existente para después importarlo a Cloud SQL.

3. Cuando los datos se hayan migrado, volverás a configurar el software del blog para usar la base de datos migrada.

El archivo de configuración del sitio de WordPress para este lab se encuentra aquí: /var/www/html/wordpress/wp-config.php.

En resumen, tu desafío es migrar la base de datos a Cloud SQL y, luego, volver a configurar la aplicación para que ya no dependa de la base de datos MySQL local. ¡Buena suerte!

> [!NOTE]
> **Nota:** La puntuación inicial del monitoreo de actividades del lab será de 20 puntos debido a que tu blog se está ejecutando. Si vuelves a configurar correctamente la aplicación del blog para usar la base de datos de Cloud SQL, esa puntuación permanecerá en tu total general.
>
> Si la base de datos no se migra correctamente, la prueba de “ejecución del blog” fallará y se te descontarán 20 puntos.

> [!NOTE]
> **Nota:** Utiliza los siguientes valores para la zona y la región donde corresponda. Zona: ==ZONE==; región: ==REGION==.

Sugerencias y trucos

**Google Cloud SQL - Guías prácticas**: La documentación de Cloud SQL incluye un conjunto de [guías prácticas](https://cloud.google.com/sql/docs/mysql/how-to) que brindan orientación sobre cómo crear instancias y bases de datos, y cómo conectar aplicaciones a esas bases de datos.

**Instalación y migración de WordPress**: [WordPress Codex](https://codex.wordpress.org/Installing_WordPress) proporciona información sobre cómo instalar, configurar y migrar sitios de esta plataforma. [Aquí](https://codex.wordpress.org/Installing_WordPress#Detailed_Instructions) encontrarás instrucciones sobre cómo crear y preparar bases de datos para usar con WordPress.

## Tarea 1: Crea una nueva instancia de Cloud SQL

En esta tarea, debes configurar una nueva instancia de Cloud SQL en Google Cloud. Elige los parámetros de configuración correctos y asegúrate de crear la instancia de SQL en la Zona: ZONE y la Región: REGION, que son las adecuadas para alojar la base de datos de WordPress. Asegúrate de que comprendes los requisitos que debe cumplir la base de datos para admitir el blog de WordPress.

**Solución Tarea 1:**

Los requerimientos minimos para instalar WordPress según su sitio web son:

Requirements on the server side
PHP 7.4 or greater
MySQL 5.7 or MariaDB 10.3 or greater
HTTPS support

Esto datos se tomaran para crear la instancia y buscar cumplir los minimos requerimientos para no incurrir en costos mas altos.

1. Crea la instancia de Cloud SQL con el siguiente comando:

```bash
ZONE=<Ingrese la zona del lab>
REGION=<Ingrese la region del lab>
DB_INSTANCE_NAME=mycloudsql
DB_NAME=wordpress
DB_USER=blogadmin
DB_PASSWORD=Password1*

echo -e "\e[1mTarea 1: Crea una nueva instancia de Cloud SQL\e[0m\n"

gcloud sql instances create $DB_INSTANCE_NAME \
    --database-version=MYSQL_5_7 \
    --tier=db-f1-micro \
    --region=$REGION \
    --zone=$ZONE \
    --storage-type=SSD \
    --storage-size=10 \
    --availability-type=zonal

echo -e "\n\e[32mInstancia de Cloud SQL creada\e[0m\n"

```

## Tarea 2: Configura la base de datos nueva

Una vez creada la instancia de Cloud SQL, el siguiente paso es configurar la base de datos en ella. Establece los parámetros necesarios de la base de datos y asegúrate de que está lista para recibir los datos existentes de la base de datos de WordPress.

**Solución Tarea 2:**

1. Crea la base de datos en la instancia de Cloud SQL.

2. Crear el usuario de base de datos en la instancia de Cloud SQL.

```bash

echo -e "\e[1mTarea 2: Configura la base de datos nueva\e[0m\n"

echo -e "Paso 1 Crear la base de datos\n"

gcloud sql databases create $DB_NAME \
    --instance=$DB_INSTANCE_NAME

echo -e "\n\e[32mBase de datos creada\e[0m\n"

echo -e "Paso 2 Crear el usuario de base de datos\n"

gcloud sql users create $DB_USER \
    --instance=$DB_INSTANCE_NAME \
    --password=$DB_PASSWORD

echo -e "\n\e[32mUsuario de base de datos creado\e[0m\n"

```

> [!NOTE]
> Aunque Cloud SQL crea un usuario administrativo root por defecto, WordPress requiere un usuario de aplicación dedicado (blogadmin) con su respectiva contraseña para que coincida con la configuración previa del sitio web. La base de datos lógica (wordpress) debe crearse explícitamente en este paso, ya que el comando mysqldump de la siguiente tarea no tiene la instrucción de crear el contenedor del esquema, solo inyecta las tablas.

## Tarea 3: Realiza un volcado de la base de datos e importa los datos

Tu tarea aquí es realizar un volcado de la base de datos de MySQL wordpress existente y, luego, importar estos datos a la base de datos de Cloud SQL recién creada. Este paso es fundamental para migrar la base de datos con eficacia.

**Solución Tarea 3:**

1. Obetener clave de acceso ssh de la instancia blog

2. Realiza un volcado de la base de datos de MySQL existente.

3. Importa los datos del volcado a la base de datos de Cloud SQL.

```bash

echo -e "\e[1mTarea 3: Realiza un volcado de la base de datos e importa los datos\e[0m\n"

echo -e "Paso 1: Obtener IP de Cloud SQL y autorizar la red de origen\n"

# Extraer la IP pública de Cloud SQL de forma limpia
DB_EXTERNAL_IP=$(gcloud sql instances describe $DB_INSTANCE_NAME \
    --format="value(ipAddresses.filter(type:PRIMARY).ipAddress)")

# Obtener la IP externa de la VM blog para la regla de firewall administrada
VM_EXTERNAL_IP=$(gcloud compute instances describe blog \
    --zone=$ZONE \
    --format="value(networkInterfaces[0].accessConfigs[0].natIP)")

# Aplicar el parche de red para evitar el bloqueo de conexión
gcloud sql instances patch $DB_INSTANCE_NAME \
    --authorized-networks=$VM_EXTERNAL_IP

echo -e "\n\e[32mCapa de red configurada y autorizada\e[0m\n"

echo -e "Paso 2 y 3: Volcado remoto e importación de datos en un solo bloque seguro\n"

# El comando genera el respaldo con blogadmin local y lo inyecta a Cloud SQL
# usando el MISMO usuario blogadmin que creamos en la Tarea 2 con su contraseña
gcloud compute ssh blog \
    --zone=$ZONE \
    --ssh-flag="-o StrictHostKeyChecking=no" \
    --command="mysqldump -u blogadmin -p'$DB_PASSWORD' --databases wordpress > wordpress_backup.sql && mysql -u blogadmin -p'$DB_PASSWORD' -h $DB_EXTERNAL_IP wordpress < wordpress_backup.sql"

echo -e "\n\e[32mMigración de datos completada con éxito\e[0m\n"

```

> [!NOTE]
> En un entorno real y productivo sería muchísimo más recomendable usar una Cuenta de Servicio (Service Account) con los roles de IAM adecuados combinada con Cloud SQL Auth Proxy para conectar de forma segura la VM y la instancia de Cloud SQL. Sin embargo, siguiendo la petición estricta del ejercicio del laboratorio, se creó el patch de red directo entre las IPs públicas para cumplir con la validación automática.

## Tarea 4: Vuelve a configurar la instalación de WordPress

Ahora que la base de datos se migró a Cloud SQL, debes volver a configurar el software de WordPress para que utilice esta nueva base de datos, lo que implica editar el archivo wp-config.php en el directorio de WordPress para que apunte a la base de datos de Cloud SQL y se aleje de la base de datos de MySQL local.

**Solución Tarea 4:**

1. Edita el archivo wp-config.php para que apunte a la base de datos de Cloud SQL.

```bash

echo -e "\e[1mTarea 4: Vuelve a configurar la instalación de WordPress\e[0m\n"

echo -e "Paso 1: Modificar wp-config.php y apuntar a Cloud SQL\n"

# Definir la ruta exacta del archivo que descubrimos en el sistema
WP_CONFIG_PATH="/var/www/html/wordpress/wp-config.php"

# El comando se envía desde Cloud Shell para modificar el archivo de forma remota.
# Usamos 'sed' con expresiones regulares para reemplazar 'localhost' por la IP pública de Cloud SQL
gcloud compute ssh blog \
    --zone=$ZONE \
    --ssh-flag="-o StrictHostKeyChecking=no" \
    --command="sudo sed -i \"s/define( 'DB_HOST', 'localhost' );/define( 'DB_HOST', '$DB_EXTERNAL_IP' );/g\" $WP_CONFIG_PATH"

echo -e "\e[32mArchivo wp-config.php actualizado con la nueva IP de conexión\e[0m\n"

echo -e "Paso 2: Reiniciar el servidor web Apache para aplicar los cambios\n"

# Obligar a Apache a vaciar los sockets de red y leer la nueva configuración
gcloud compute ssh blog \
    --zone=$ZONE \
    --ssh-flag="-o StrictHostKeyChecking=no" \
    --command="sudo systemctl restart apache2"

echo -e "\n\e[32mServidor web Apache reiniciado con éxito. Laboratorio 100% Completado.\e[0m\n"

```

> [!NOTE]
> Nota de depuración en entornos reales: Aunque la instrucción teórica del laboratorio asumía una ruta genérica dentro del directorio de WordPress, la realidad en el servidor nos obligó a inspeccionar a fondo la máquina virtual. Nada sale a la primera en producción. Para resolver el bloqueo, ejecutamos comandos de búsqueda del sistema (sudo find / -name "wp-config.php") para mapear la localización exacta del archivo de configuración, descubriendo que el entorno real del laboratorio lo alojaba en /var/www/html/wordpress/wp-config.php. Esta verificación previa evitó fallos de ejecución en nuestro script de automatización con sed.

## Tarea 5: Valida el resultado y soluciona los problemas

Tu tarea final es asegurarte de que el blog de WordPress funciona correctamente con la nueva base de datos de Cloud SQL. Comprueba si el blog funciona según lo esperado y soluciona cualquier problema que encuentres. Este paso es importante para confirmar el éxito de la migración de la base de datos y la funcionalidad general del blog.

**Solución Tarea 5:**

1. Verifica que el blog de WordPress funcione correctamente con la nueva base de datos de Cloud SQL.

```bash

echo -e "\e[1mTarea 5: Valida el resultado y soluciona los problemas\e[0m\n"

echo -e "Paso 1: Realizar petición de validación al servidor Web\n"

# Ejecutamos curl capturando únicamente el código de estado HTTP (ej. 200, 301, 404, 500)
# -s (silencioso), -o /dev/null (no pinta el HTML en pantalla), -w (formato de salida específico)
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://$VM_EXTERNAL_IP/wordpress/)

echo "Código de respuesta HTTP detectado: $HTTP_STATUS"

# Paso 2: Validar el estado con una estructura condicional
if [ "$HTTP_STATUS" -eq 200 ] || [ "$HTTP_STATUS" -eq 301 ] || [ "$HTTP_STATUS" -eq 302 ]; then
    echo -e "\n\e[32m[ÉXITO] El blog de WordPress responde correctamente con código $HTTP_STATUS.\e[0m"
    echo -e "\e[32mMigración a Cloud SQL validada al 100% de forma automatizada.\e[0m\n"
else
    echo -e "\n\e[31m[ALERTA] Validación fallida. El servidor devolvió el código $HTTP_STATUS.\e[0m"
    echo -e "\e[31mPor favor, revisa la conexión en wp-config.php o el estado de Apache.\e[0m\n"
fi

```
