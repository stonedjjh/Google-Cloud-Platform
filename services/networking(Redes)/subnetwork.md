# Subnetwork(subred)

Una subred es un bloque contiguo de direcciones IP dentro de un rango de direcciones IP más grande, generalmente dentro de una red VPC. Las subredes se utilizan para dividir una red en segmentos más pequeños y manejables, lo que facilita la administración y seguridad de la red.

## Subred

- Scope: Regional.
- Permite el tráfico entre zonas dentro de la misma región.
- Puedes asignar rangos de IP internos (privados) o externos (públicos).

## Tipos de subredes

Las redes de VPC admiten subredes con los siguientes tipos de pila. Una sola red de VPC puede contener cualquier combinación de estas subredes.

| Tipo de pila | Rangos de subredes | Interfaces de red de VM compatibles |
| :--- | :--- | :--- |
| **Solo IPv4** (pila única) | Solo rangos de subredes IPv4 | Interfaces solo IPv4 |
| **IPv4 e IPv6** (pila doble) | Rangos de subredes IPv4 e IPv6 | Interfaces de solo IPv4, de pila doble y de solo IPv6 |
| **Solo IPv6** (pila única) | Solo rangos de subredes IPv6 | Interfaces solo IPv6 |

Cuando creas una subred, especificas qué tipo de pila usar. También puedes cambiar el tipo de pila de una subred en los siguientes casos:

- Si la subred es solo IPv4, puedes cambiarla a pila doble.
- Si la subred es de pila doble y tiene un rango de direcciones IPv6 externas, puedes cambiarla a solo IPv4.

Las subredes con rangos de direcciones IPv6 solo son compatibles con las redes de VPC de modo personalizado. Las subredes con rangos de direcciones IPv6 no son compatibles con redes de VPC en modo automático ni con redes heredadas.

> [!NOTE]
> Si deseas crear subredes con rangos de direcciones IPv6 en una red de VPC de modo automático, primero debes convertir una red de VPC de modo automático al modo personalizado.

Cuando creas un rango de subred IPv4, proporcionas la siguiente información:

| Configuración de subred | Valores válidos | Detalles |
| :--- | :--- | :--- |
| **Rango IPv4** | Un rango válido que elijas | Obligatorio |
| **Rango de IPv4 secundario** | Un rango válido que elijas | Opcional |

### Rangos de IP Secundarios (Alias IP)

Los rangos de IP secundarios permiten estructurar subredes con rangos CIDR adicionales para fines específicos. Sus casos de uso principales en Google Cloud son:

- **Google Kubernetes Engine (GKE):** En clústeres nativos de VPC, las direcciones IP de los Nodos se asignan desde el rango primario de la subred, mientras que las direcciones IP de los **Pods** y **Servicios** utilizan rangos secundarios independientes.
- **Alias IP en VMs:** Permite asignar múltiples direcciones IP a una sola interfaz de red de una máquina virtual (VM) para alojar múltiples aplicaciones o contenedores independientes, dándole a cada uno su propia IP interna ruteable.


Cuando creas un rango de subred IPv6, especificas el tipo de acceso y la fuente de las direcciones IP. Por defecto, una subred no tiene rangos de direcciones IPv6. Si agregas un rango de direcciones IPv6 a una subred, esta se convierte en una subred de pila doble.

## Propósitos de las subredes

Cuando creas una subred, debes seleccionar un propósito para ella:

- Subredes regulares (PRIVATE): Este es el tipo de subred predeterminado. Los usuarios crean subredes regulares o se crean de forma automática en redes de VPC de modo automático para usarlas con instancias de VM. El propósito se muestra como Ninguno en la consola de Google Cloud.
    
    - Las subredes híbridas son subredes normales que se configuran con un comportamiento de enrutamiento diferente (--allow-cidr-routes-overlap). Las subredes híbridas se extienden lógicamente a una red local o de origen, lo que te permite migrar cargas de trabajo a Google Cloud sin necesidad de cambiar las direcciones IP. Puedes habilitar o inhabilitar el enrutamiento híbrido para una subred en cualquier momento.

- Subredes de Private Service Connect (PRIVATE_SERVICE_CONNECT): Es una subred que usas para publicar un servicio administrado con Private Service Connect.
- Subredes de solo proxy (GLOBAL_MANAGED_PROXY y REGIONAL_MANAGED_PROXY): Una subred de solo proxy que usas con balanceadores de cargas basados en Envoy y Secure Web Proxy.
- Subredes NAT privadas (PRIVATE_NAT): Es una subred reservada para que se use como rango de origen de la NAT privada.
- Subredes de migración de intercambio de tráfico (PEER_MIGRATION): Es una subred que usas para migrar un servicio de VPC compartida a Private Service Connect. Una vez que se complete la migración, puedes convertir la subred de migración entre pares en una subred normal.

En la mayoría de los casos, no puedes cambiar el parámetro de configuración de propósito de una subred después de crearla. Para obtener más información, consulta la referencia del comando gcloud compute networks subnets update.

## Acceso Privado a Google (Private Google Access)

El **Acceso Privado a Google** es una característica clave que se configura a nivel de **subred**:

- **Funcionamiento:** Permite que las máquinas virtuales (VMs) de esa subred que **únicamente tienen direcciones IP internas (privadas)** puedan comunicarse de manera segura con las APIs y servicios globales de Google (como Cloud Storage, BigQuery, Pub/Sub, etc.) a través de la red interna de Google.
- **Caso de uso para el Examen:** Si un escenario te pide que una VM acceda a servicios de Google pero, por razones de seguridad, **no debe tener asignada una IP pública externa**, la solución recomendada es habilitar esta opción en la subred de la VM.



## Limitaciones para asignar nombres a las subredes

Los nombres de las subredes tienen las siguientes limitaciones:

- Dentro de un proyecto Google Cloud, una subred no puede tener el mismo nombre que una red de VPC, a menos que sea miembro de esa red. Dentro de un proyecto, las subredes en la misma región deben tener nombres únicos. Por ejemplo, una red llamada production puede tener varias subredes también llamadas production, siempre que cada una de esas subredes esté en una región única.

- No puedes cambiar el nombre ni la región de una subred luego de crearla. Sin embargo, puedes borrar una subred y reemplazarla, siempre y cuando no haya recursos que la usen.

## Datos Clave y Límites (Quotas)

- **Redes VPC vs Subredes:** Las redes VPC son globales, pero las subredes son regionales.
- **Expansión de Rango:** Después de crear una subred, el rango IPv4 principal se puede expandir, pero no se puede reemplazar ni reducir. Esta expansión se realiza sin afectar a las máquinas virtuales existentes en la subred.
- **Tamaño Mínimo de Rango:** El tamaño mínimo tanto para rangos principales como secundarios es de 8 direcciones IPv4. Por lo tanto, la máscara de subred más larga que puedes usar es `/29`.
- **Direcciones IP Reservadas:** Google Cloud reserva **4 direcciones IP** de cada subred para configurar la red (a diferencia de AWS que reserva 5). En un bloque como `10.1.2.0/24`, las IPs reservadas son:
  - `10.1.2.0` (Dirección de red).
  - `10.1.2.1` (Puerta de enlace predeterminada / Default Gateway).
  - `10.1.2.254` (Reservada para uso futuro).
  - `10.1.2.255` (Dirección de difusión / Broadcast).
- **Eliminación de Subredes:** Se puede eliminar una subred siempre y cuando no tenga ningún recurso asociado que la esté utilizando.

---

## Tip de Arquitectura para el Examen

¡Recuerda siempre esta regla de oro: **VPC = Global, Subred = Regional**! Múltiples VMs pueden compartir exactamente la misma subred aunque se encuentren en diferentes zonas (ej. zona `A` y zona `B`), lo que facilita enormemente el diseño de arquitecturas de Alta Disponibilidad (HA) sin complicar el diseño de red.


