# Migración de VMs entre Redes VPC

En Google Cloud, es posible migrar una instancia de máquina virtual (VM) de una red VPC a otra (o entre subredes) sin tener que recrear la VM desde cero, aunque existen ciertas limitaciones y requisitos estrictos.

## Requisitos y Restricciones Principales

*   **Migración en Frío (Cold Migration):** Es obligatorio que la máquina virtual esté **detenida (Stopped)** antes de iniciar el proceso de migración.
*   **Comportamiento de la Región:** Durante la migración, la VM **permanece en la misma región**. Lo único que cambia es la red a la que está conectada.
*   **Múltiples Interfaces:** Si la VM posee más de una interfaz de red (NIC), el proceso de migración actualizará la interfaz que especifiques y dejará el resto de las interfaces intactas.

## Comportamiento con Grupos de Instancias

Las reglas varían dependiendo de si la VM forma parte de una agrupación:

*   **MIGs (Grupos de Instancias Administrados):** **No se pueden migrar** las VMs pertenecientes a un MIG. La solución es copiar la plantilla de instancias (Instance Template) apuntando a la nueva red y recrear el grupo con esa plantilla.
*   **UMIGs (No Administrados) y NEGs (Network Endpoint Groups):** La VM debe ser **retirada (quitada)** del grupo manualmente antes de proceder con la migración.
*   **Grupos de Destino (Target Pools):** (Usados en balanceadores de carga de red). A diferencia de los anteriores, **sí puedes** mover instancias que están en Target Pools sin retirarlas primero; el Target Pool se expande automáticamente para abarcar ambas redes temporalmente.

## Migraciones Admitidas vs. No Admitidas

**Migraciones Soportadas:**
*   De una red *heredada (Legacy)* a una red de VPC en el mismo proyecto.
*   De una red de VPC a otra red de VPC en el mismo proyecto.
*   De una subred a otra subred dentro de la **misma red de VPC**.
*   De la red local de un *Service Project* hacia la red compartida (*Shared VPC*) de un *Host Project*.

**Migraciones NO Soportadas:**
*   **No puedes** migrar una interfaz de red de vuelta hacia una red heredada (Legacy).

## Impacto en IPs y Direcciones MAC (Reglas Críticas)

1.  **Cambio de Dirección MAC:** La dirección MAC de la interfaz de red **cambiará obligatoriamente** durante la migración. Esto es crítico si ejecutas software de terceros (como firewalls o bases de datos) cuyas licencias estén fuertemente acopladas a la dirección MAC original.
2.  **Direcciones IP Internas:**
    *   Si la nueva red/subred tiene un rango de IP distinto, deberás cambiar la IP interna de la instancia.
    *   Si migras a una subred que maneja el **mismo rango de IP**, puedes conservar la IP interna antigua (si lo especificas y si no está siendo usada en el destino).
3.  **Direcciones IP Externas:**
    *   Puedes **conservar la dirección IP externa** existente en la nueva ubicación.
    *   **Requisitos:** Debes tener el permiso de IAM `compute.subnetworks.useExternalIp` en la red de destino. Además, la red de destino no debe tener bloqueadas las IPs públicas mediante restricciones de política de organización (`constraints/compute.vmExternalIpAccess`).
