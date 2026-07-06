# Google Kubernetes Engine

Los clústeres de Google Kubernetes Engine (GKE) funcionan con el sistema de administración de clúster de código abierto de Kubernetes. Este proporciona los mecanismos a través de los cuales interactúas con tu clúster de contenedores. Los comandos y recursos de Kubernetes se usan para implementar y administrar aplicaciones, realizar tareas administrativas, establecer políticas y supervisar el estado de las cargas de trabajo implementadas.

Kubernetes se basa en los mismos principios de diseño que se utilizan para ejecutar algunos servicios populares de Google y ofrece los mismos beneficios: administración automática, supervisión y sondeos de estado en funcionamiento de los contenedores de aplicaciones, escalado automático, actualizaciones progresivas y mucho más. Cuando ejecutas tus aplicaciones en un clúster de contenedores, estás utilizando tecnología basada en la experiencia de más de 10 años que Google tiene ejecutando cargas de trabajo de producción en contenedores.

## Kubernetes en Google Cloud

Cuando ejecutas un clúster de GKE, también obtienes los beneficios de las funciones avanzadas de administración de clústeres que proporciona Google Cloud. Estos incluyen los siguientes:

- [Balanceo de cargas](https://cloud.google.com/compute/docs/load-balancing-and-autoscaling) para instancias de Compute Engine
- [Grupos de nodos](https://cloud.google.com/kubernetes-engine/docs/node-pools) para designar subconjuntos de nodos dentro de un clúster y así obtener flexibilidad adicional
- [Escalado automático](https://cloud.google.com/kubernetes-engine/docs/cluster-autoscaler) del recuento de instancias de nodos del clúster
- [Actualizaciones automáticas](https://cloud.google.com/kubernetes-engine/docs/node-auto-upgrade) para el software de nodo del clúster
- [Reparación automática de los nodos](https://cloud.google.com/kubernetes-engine/docs/how-to/node-auto-repair) para mantenerlos disponibles y en buen estado
- [Registros y supervisión](https://cloud.google.com/kubernetes-engine/docs/how-to/logging) con Cloud Monitoring para obtener una mayor visibilidad del clúster

ss## Modos de clúster: Standard vs Autopilot

- **Standard**: Tú gestionas la configuración de los nodos (tipo de máquina, tamaño de disco, número de nodos, etc.). Es flexible y permite personalizar la infraestructura, pero requiere mantenimiento de los nodos (actualizaciones, parches, configuración de autoscaling).

- **Autopilot**: GKE gestiona automáticamente los recursos de los nodos. Tú defines solo la carga de trabajo (pods, cuotas de recursos). GKE provisiona y escala los nodos bajo el capó, con precios basados en los recursos solicitados por los pods. Reduce la sobrecarga operativa, pero ofrece menos control sobre la infraestructura subyacente.

**Principales diferencias**

| Característica | Standard | Autopilot |
|---|---|---|
| Gestión de nodos | Manual (tú decides) | Automática (GKE) |
| Facturación | Por nodo (VM) | Por recurso solicitado (CPU, RAM) |
| Escalado de nodos | Configuras grupos de nodos y autoscaling | Escalado automático gestionado por GKE |
| Actualizaciones de nodo | Tú ejecutas upgrades | GKE aplica upgrades automáticamente |
| Opciones de personalización | Amplias (tipo de VM, discos, etiquetas) | Limitadas (solo configuración de pods) |
| Uso recomendado | Cargas de trabajo con requisitos de infraestructura específicos o híbridas | Cargas de trabajo que prefieren gestión operativa mínima y facturación basada en uso |


## Datos Clave

- Los recursos para los clústeres provienen de **Computer Engineer**.
