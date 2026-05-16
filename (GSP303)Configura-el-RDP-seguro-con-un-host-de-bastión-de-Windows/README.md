# Configura el RDP seguro con un host de bastión de Windows

## GSP303

![Logotipo de los labs de autoaprendizaje de Google Cloud](https://cdn.qwiklabs.com/GMOHykaqmlTHiqEeQXTySaMXYPHeIvaqa2qHEzw6Occ%3D)

## Descripción general

En un lab de desafío, se le proporcionarán una situación y un conjunto de tareas. En lugar de seguir instrucciones paso a paso, deberás utilizar las habilidades aprendidas en los labs del curso para decidir cómo completar las tareas por tu cuenta. Un sistema automatizado de puntuación (en esta página) mostrará comentarios y determinará si completaste tus tareas correctamente.

En un lab de desafío, no se explican conceptos nuevos de Google Cloud, sino que se espera que amplíes las habilidades que adquiriste, como cambiar los valores predeterminados y leer o investigar los mensajes de error para corregir sus propios errores.

Debe completar correctamente todas las tareas dentro del período establecido para obtener una puntuación del 100%.

Se les recomienda este lab a los estudiantes que se están preparando para el examen de certificación [Google Cloud Certified Professional Cloud Architect](https://cloud.google.com/certification/cloud-architect). ¿Aceptas el desafío?

## Situación del desafío

Tu empresa decidió implementar nuevos servicios de aplicaciones en la nube. Tu tarea consiste en desarrollar un framework seguro para administrar los servicios de Windows que se implementarán. Tendrás que crear un nuevo entorno de red de VPC para los servidores de Windows de producción segura.

Inicialmente, los servidores de producción deben estar aislados por completo de las redes externas y no se podrá acceder a ellos desde Internet ni podrán conectarse directamente a esa red. Para configurar y administrar tu primer servidor en este entorno, deberás además implementar un host de bastión (o jump box) accesible desde Internet con el Protocolo de escritorio remoto (RDP) de Microsoft. Solo se podrá acceder al host de bastión mediante el RDP desde Internet, y este podrá comunicarse con las otras instancias de procesamiento dentro de la red de VPC con el RDP.

Tu empresa también tiene un sistema de supervisión que se ejecuta desde la red de VPC predeterminada, por lo que todas las instancias de procesamiento deben tener una segunda interfaz de red con una conexión únicamente interna a la red de VPC predeterminada.

## Tu desafío

Implementar la máquina de Windows segura que no está configurada para la comunicación externa dentro de una nueva subred de VPC. Luego, implementar Microsoft Internet Information Server en dicha máquina segura. A los fines de este lab, todos los recursos se deben aprovisionar en la siguiente región y zona:

- **Región**: region
- **Zona**: zone

## Tareas

Estas son las tareas clave del desafío. ¡Buena suerte!

- Crear una nueva red de VPC con una única subred
- Crear una regla de firewall que permita el tráfico de RDP externo al sistema del host de bastión
- Implementar dos servidores de Windows que estén conectados tanto a la red de VPC como a la red predeterminada
- Crear una máquina virtual que apunte a la secuencia de comandos de inicio
- Configurar una regla de firewall para permitir el acceso de HTTP a la máquina virtual

## Tarea 1: Crea la red de VPC

1. Crea una red de VPC nueva con el nombre `securenetwork`.

2. Crea una subred de VPC nueva en securenetwork en la región region.

3. Una vez que la red y la subred se hayan establecido, configura una regla de firewall que permita el tráfico de RDP entrante (puerto TCP 3389) desde Internet hasta el host de bastión. Esta regla se debe aplicar al host apropiado mediante las etiquetas de red.

## Tarea 2: Implementa tus instancias de Windows y configura las contraseñas de usuarios

1. Implementa una instancia de Windows Server 2016 (servidor con experiencia de escritorio) llamada `vm-securehost` con dos interfaces de red en la zona `zone`.
   - Configura la primera interfaz de red con una conexión únicamente interna a la nueva subred de VPC.

   - Configura la segunda interfaz de red con una conexión únicamente interna a la red de VPC predeterminada. Este es el servidor seguro.

2. Implementa una segunda instancia de Windows Server 2016 (servidor con experiencia de escritorio) llamada `vm-bastionhost` con dos interfaces de red en la zona `zone`.
   - Configura la primera interfaz de red para que se conecte a la nueva subred de VPC con una dirección pública efímera (NAT externa).
   - Configura la segunda interfaz de red con una conexión únicamente interna a la red de VPC predeterminada. Este es el host de bastión o jump box.

## Configura las contraseñas de usuarios

1. Después de que se hayan creado las instancias de Windows, crea una cuenta de usuario y restablece las contraseñas de Windows para conectarte a cada instancia.

   > [!NOTE]
   > Copia el nombre de usuario y la contraseña de ambas instancias para usarlos más adelante.

2. El siguiente comando de gcloud crea un nuevo usuario llamado `app-admin` y restablece la contraseña de un host con el nombre `vm-bastionhost` ubicado en la zona `placeholder`:

   ```bash
   gcloud compute reset-windows-password vm-bastionhost --user app_admin --zone "placeholder"
   ```

3. El siguiente comando de gcloud crea un nuevo usuario llamado `app-admin` y restablece la contraseña de un host con el nombre `vm-securehost` ubicado en la zona `placeholder`:

   ```bash
   gcloud compute reset-windows-password vm-securehost --user app_admin --zone "placeholder"
   ```

- También puedes forzar el restablecimiento de la contraseña desde la consola de Compute Engine. Tendrás que repetir este paso para el segundo host, ya que las credenciales de acceso para esa instancia serán diferentes.

## Tarea 3: Conéctate al host seguro y configura Internet Information Server

1. Para conectarte al host seguro, primero debes conectarte vía RDP al `host de bastión`. Una instancia de Windows Compute con una dirección externa se puede conectar vía RDP con el botón correspondiente que aparece junto a las instancias de Windows Compute en la página de resumen de la instancia de Compute.

2. Cuando te hayas conectado a la sesión de RDP con el host de bastión, abre una nueva sesión de RDP dentro del `host de bastión` para conectarte a la dirección de red privada interna del `host seguro`.

3. Cuando te conectas a un servidor de Windows, puedes iniciar el cliente de RDP de Microsoft con el comando `mstsc.exe`, o bien puedes buscar Remote Desktop Manager en el menú Inicio. De este modo, podrás conectarte desde el host de bastión a otras instancias de procesamiento en la misma VPC, incluso si esas instancias no tienen una conexión directa a Internet.

   Una vez que conectes la máquina `vm-securehost` a través de RDP, configura Internet Information Server.

4. Cuando hayas accedido a la máquina `vm-securehost`, abre la ventana de administración del servidor y configura el servidor local para agregar `roles y funciones`.

5. Usa la `instalación basada en roles o en funciones` para agregar el rol de `Web Server (IIS)`.

## Soluciona problemas

- **No se puede conectar con el host de bastión:** Asegúrate de que estás intentando conectarte a la dirección externa del host de bastión. Aunque la dirección sea correcta, tal vez no puedas conectarte al host de bastión si la regla de firewall no está configurada correctamente para permitir el tráfico de puerto TCP 3389 (RDP) desde Internet o la dirección IP pública de tu sistema a la interfaz de red en el host de bastión que tiene una dirección externa. Por último, puede que tengas problemas para conectarte vía RDP si tu propia red no permite el acceso a direcciones de Internet a través del RDP. Si todo lo demás está bien, tendrás que hablar con el propietario de la red a la que te conectaste a Internet para abrir el puerto 3389, o bien conectarte a través de una red diferente.

- **No se puede conectar al host seguro desde el host de bastión**: Si puedes conectarte correctamente al host de bastión, pero no puedes realizar la conexión de RDP interna mediante la aplicación Conexión a Escritorio remoto de Microsoft, verifica que ambas instancias estén conectadas a la misma red de VPC.

**Solucion:**

```bash
#Creamos las variables a usar
REGION=
ZONE=
VPC_NAME=securenetwork
SUBNETS_NAME=subnetwork-securenetwork
SECURE_HOST=vm-securehost
BASTION_HOST=vm-bastionhost
FIREWALL_RULE_NAME=firewall-securenetwork
TAG="bastion-access"

echo -e "\e[1mTarea 1: Crea la red de VPC\e[0m\n"

echo -e "Paso 1 creando red\n"

gcloud compute networks create $VPC_NAME \
  --subnet-mode=custom

echo -e "\n\e[32mred creada\e[0m\n"

echo -e "Paso 2 creando subred $SUBNETS_NAME  en la Region $REGION\n"

gcloud compute networks subnets create $SUBNETS_NAME \
  --network=$VPC_NAME \
  --range=10.0.0.0/24 \
  --region=$REGION

echo -e "\n\e[32msubred creada\e[0m\n"

echo -e "Paso 3 configura una regla de firewall que permita el tráfico de RDP\n"

gcloud compute firewall-rules create $FIREWALL_RULE_NAME \
  --network=$VPC_NAME \
  --action=allow \
  --direction=ingress \
  --source-ranges=0.0.0.0/0 \
  --target-tags=$TAG \
  --rules=tcp:3389

echo -e "\n\e[32mregla creada\e[0m\n"

echo -e "\e[1mTarea 2: Implementa tus instancias de Windows y configura las contraseñas de usuarios\e[0m\n"

echo -e "Paso 1 creando instancia $SECURE_HOST \n"

gcloud compute instances create $SECURE_HOST \
    --zone=$ZONE \
    --machine-type=e2-medium \
    --image-family=windows-2016 \
    --image-project=windows-cloud \
    --network-interface=subnet=$SUBNETS_NAME,no-address  \
    --network-interface=network="default",no-address

echo -e "\n\e[32m Instancia $SECURE_HOST creada\e[0m\n"

echo -e "Paso 2 creando instancia $BASTION_HOST \n"

gcloud compute instances create $BASTION_HOST \
    --zone=$ZONE \
    --machine-type=e2-medium \
    --image-family=windows-2016 \
    --image-project=windows-cloud \
    --network-interface=subnet=$SUBNETS_NAME  \
    --network-interface=network="default",no-address \
    --tags=$TAG

echo -e "\n\e[32m Instancia $BASTION_HOST\e[0m\n"

echo -e "Paso 3 Configura las contraseñas de usuarios \n"

SECURE_HOST_PASSWORD=$(gcloud compute reset-windows-password $SECURE_HOST \
    --user app_admin \
    --zone $ZONE \
    --format="value(password)")

BASTION_HOST_PASSWORD=$(gcloud compute reset-windows-password $BASTION_HOST \
    --user app_admin \
    --zone $ZONE \
    --format="value(password)")
```
