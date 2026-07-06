# Cloud Run

Google Cloud Run es un servicio **serverless** que permite ejecutar contenedores **sin gestionar infraestructura**. Proporciona un entorno gestionado donde la plataforma se encarga del aprovisionamiento, escala y mantenimiento de los recursos.

## Características principales

- **Ejecución sin servidor**: No necesitas crear o administrar máquinas virtuales.
- **Escalado automático**: Escala a cero cuando no hay tráfico y a miles de instancias bajo alta carga.
- **Compatibilidad con contenedores**: Cualquier contenedor Docker puede desplegarse.
- **Integración con Cloud Build y Artifact Registry**: Flujos CI/CD simplificados.
- **Gestión de tráfico**: Deploys de versiones y splitting de tráfico entre versiones.
- **Seguridad**: Integración con IAM y Cloud Run Auth para control de acceso.

## Casos de uso típicos

- APIs y microservicios.
- Aplicaciones web estáticas que requieren backend.
- Procesamiento de eventos (por ejemplo, Cloud Pub/Sub → Cloud Run).
- Tareas de corta duración y sin estado.

## Flujo de trabajo

```mermaid
flowchart LR
    step1["1. Escribir código<br>(Source code)"] --> step2["2. Construir y empaquetar<br>(Container image)"]
    step2 --> step3["3. Desplegar a Cloud Run<br>(Artifact Registry)"]
    step3 --> step4["Aplicación web / Servicio<br>(Web app)"]
```

## Enlaces útiles

- [Documentación oficial de Cloud Run](https://cloud.google.com/run/docs)
- [Guía de inicio rápido con Cloud Build y Artifact Registry](https://cloud.google.com/run/docs/quickstarts/build-and-deploy)
- [Ejemplos de despliegue en GitHub](https://github.com/GoogleCloudPlatform/cloud-run-samples)

## Datos Clave

- **Serverless**: Cloud Run es un servicio serverless que ejecuta contenedores sin gestionar infraestructura.
- **Contenedores sin estado**: Ideal para contenedores sin estado que pueden escalar rápidamente.
- **Eventos web o Pub/Sub**: Soporta disparar contenedores mediante solicitudes HTTP o mensajes de Pub/Sub.
- **Precisión de facturación**: Se cobra por los recursos usados con una precisión de 100 ms.

