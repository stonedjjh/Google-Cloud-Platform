# VPC Compartida (Shared VPC)

**VPC Compartida (Shared VPC)** es una funcionalidad de Google Cloud que permite a **una organización** conectar recursos de **múltiples proyectos a una red Virtual Private Cloud (VPC) centralizada**. Esto facilita una topología de red administrada de manera segura y eficiente, manteniendo al mismo tiempo la separación de entornos y facturación.

> [!NOTE]
> **VPC compartida también se llama XPN en la API y en la interfaz de línea de comandos.**

## 1. Definición y Arquitectura Principal

La arquitectura de una Shared VPC se basa en la división de responsabilidades entre proyectos:

*   **Proyecto Host (Host Project):**
    *   Es el proyecto que **aloja y es dueño** de una o más redes VPC compartidas.
    *   Centraliza el control de la red: subredes, reglas de firewall, enrutamiento, VPNs, etc.
    *   El equipo de red (Network Admins) tiene control total aquí.

*   **Proyecto de Servicio (Service Project):**
    *   Es cualquier proyecto que se adjunta al Proyecto Host.
    *   Los recursos en este proyecto (como instancias de Compute Engine, clústeres de GKE o entornos de Cloud Run) pueden usar las subredes de la VPC compartida en el Host Project.
    *   El equipo de desarrollo (Devs) opera aquí sin tener permisos para modificar la infraestructura de la red subyacente.

## 2. Requisitos y Restricciones (Reglas de Examen)

Para el examen de certificación, ten en mente las siguientes reglas estrictas:

*   **Misma Organización:** Todos los proyectos involucrados (el Host Project y todos sus Service Projects) **deben pertenecer a la misma Organización** en Google Cloud. No puedes compartir una VPC entre diferentes organizaciones (para eso se usa VPC Peering).
*   **Restricción de Conexión:** Un Service Project **solo puede estar conectado a un (1) único Host Project** a la vez. No puede estar conectado a múltiples Host Projects.
*   **Límite de Host Projects:** Un Host Project puede tener múltiples Service Projects adjuntos, pero un proyecto **no puede ser Host Project y Service Project** al mismo tiempo (no se pueden anidar).

## 3. IAM y Separación de Responsabilidades

La principal ventaja de Shared VPC es la estricta separación de funciones mediante IAM:

*   **Shared VPC Admin (`roles/compute.xpnAdmin`):**
    *   Es el rol maestro para habilitar Shared VPC.
    *   **Debe asignarse a nivel de Organización o de Carpeta (Folder)**, no a nivel de proyecto, porque requiere la autoridad para vincular múltiples proyectos.
    *   Este administrador asocia los Service Projects al Host Project.
*   **Network User (`roles/compute.networkUser`):**
    *   Es el rol que el Shared VPC Admin otorga a los administradores de los **Service Projects** (desarrolladores).
    *   Se puede otorgar a nivel de todo el Host Project (da acceso a *todas* las subredes) o, por seguridad (Principio de Menor Privilegio), **a nivel de una subred específica**. Esto permite que un equipo solo despliegue VMs en su subred designada.
*   **Administrador de Instancias (`roles/compute.instanceAdmin.v1`):**
    *   Para poder crear y administrar recursos (como máquinas virtuales) en la VPC compartida, los desarrolladores **deben tener al menos este rol (o superior) en su propio Service Project**, además de contar con el rol de *Network User* proporcionado por el Host Project. La combinación de ambos permisos es la que hace posible el despliegue.
*   **Security Admin (`roles/compute.securityAdmin`):**
    *   Administra las reglas de firewall y las políticas de seguridad en el Host Project sin tener acceso a la creación de instancias.

## 4. Beneficios Clave

*   **Control de Seguridad Centralizado:** Un solo equipo de red y seguridad puede establecer políticas (firewalls, Cloud Armor, enrutamiento) en el Host Project que aplican a todos los recursos de los Service Projects.
*   **Facturación Separada:** Los recursos (como el CPU y memoria de una VM) **se cobran al Service Project** donde residen, mientras que los costos de red de los componentes centralizados se facturan al Host Project. Esto facilita el chargeback/showback por departamento.
*   **Comunicación Interna Privada:** Los recursos en diferentes Service Projects pueden comunicarse entre sí usando IPs internas (RFC 1918) siempre que se encuentren en la misma red VPC compartida y el firewall lo permita.

## 5. Diferencias Clave vs. VPC Peering

| Característica | VPC Compartida (Shared VPC) | Intercambio de Tráfico (VPC Peering) |
| :--- | :--- | :--- |
| **Administración** | **Centralizada** (un Host Project controla la red). | **Descentralizada** (cada red se administra por separado). |
| **Estructura** | Un Host Project conecta varios Service Projects. | Dos redes VPC se conectan de punto a punto. |
| **Organización** | Debe ser dentro de la **misma organización**. | Puede conectar VPCs de **diferentes organizaciones**. |
| **Roles de IAM** | Usa `Shared VPC Admin` y `Network User`. | No requiere roles especiales de VPC Compartida; cada admin configura su peering. |
| **Transitividad** | Los Service Projects en la misma Shared VPC pueden comunicarse entre sí por defecto. | El VPC Peering **NO es transitivo**. |
| **Casos de Uso** | Empresas que requieren control estricto de red, aislamiento de facturación y un solo equipo de seguridad. | Conectar redes de socios externos, adquisiciones, o proyectos independientes que necesitan compartir datos. |
