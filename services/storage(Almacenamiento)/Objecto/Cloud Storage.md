# Cloud Storage (Almacenamiento de objetos)

## Descripción general
Google Cloud Storage es un servicio de almacenamiento de objetos altamente escalable, duradero y disponible globalmente. Permite almacenar y recuperar cualquier cantidad de datos en cualquier momento, desde cualquier lugar, con baja latencia.

## Clases de almacenamiento

# Updated storage class table
| Clase | Tipo de acceso | Frecuencia de acceso | Latencia | Coste | Caso de uso |
|-------|----------------|----------------------|----------|-------|-------------|
| Standard | Acceso frecuente | Varias veces al día | Baja | Alto | Datos activos, sitios web, aplicaciones en tiempo real |
| Nearline | Acceso poco frecuente | ≈ 1 vez al mes | Media | Medio | Copias de seguridad, recuperación ante desastres |
| Coldline | Acceso muy poco frecuente | ≈ 1 vez cada 90 días | Alta | Bajo | Archivado a medio plazo, cumplimiento normativo |
| Archive | Acceso extremadamente poco frecuente | ≥ 1 vez al año | Muy alta | Muy bajo | Retención a largo plazo, requisitos regulatorios |

- **Durabilidad y disponibilidad**: 99.999999999 % (eleven‑9s) de durabilidad y alta disponibilidad según la clase elegida.
- **Control de acceso**: IAM basado en roles, listas de control de acceso (ACL) y políticas de bucket.
- **Cifrado**: Cifrado en reposo por defecto con claves gestionadas por Google (Google‑managed), con la opción de usar claves administradas por el cliente (CMEK) o propias (CSEK).
- **Versionado**: Mantén versiones anteriores de los objetos para proteger contra borrados o sobrescrituras accidentales.
- **Políticas de ciclo de vida**: Automatiza la transición de objetos entre clases o su eliminación después de un período definido.
- **Replicación**: Replicación automática entre regiones o dentro de la misma región (Multi‑regional, Dual‑regional).
- **Integración**: Compatibilidad con `gsutil`, API REST, bibliotecas cliente y herramientas de transferencia como Storage Transfer Service.

## Cómo usarlo (pasos básicos)
1. **Crear un bucket**
   ```bash
   gsutil mb -p YOUR_PROJECT_ID -c STANDARD -l us-central1 gs://mi-bucket/
   ```
2. **Subir un objeto**
   ```bash
   gsutil cp archivo.txt gs://mi-bucket/
   ```
3. **Configurar control de acceso**
   ```bash
   # Conceder acceso de lectura a todos los usuarios
   gsutil iam ch allUsers:objectViewer gs://mi-bucket
   ```
4. **Habilitar versionado (opcional)**
   ```bash
   gsutil versioning set on gs://mi-bucket
   ```
5. **Definir política de ciclo de vida** (ejemplo: mover a Nearline después de 30 días)
   ```json
   {
     "lifecycle": {
       "rule": [{
         "action": {"type": "SetStorageClass", "storageClass": "NEARLINE"},
         "condition": {"age": 30}
       }]
     }
   }
   ```
   ```bash
   gsutil lifecycle set lifecycle.json gs://mi-bucket
   ```

## Mejores prácticas
- **Selecciona la clase adecuada** según la frecuencia de acceso y los requerimientos de latencia.
- **Utiliza políticas de ciclo de vida** para mover datos inactivos a clases de bajo costo y limitar el almacenamiento de datos obsoletos.
- **Activa el versionado** en buckets críticos para evitar pérdida de datos.
- **Configura IAM con el principio de menor privilegio**; evita otorgar permisos de nivel `Owner` cuando no sea necesario.
- **Monitorea costos** usando Cloud Billing reports y alertas de presupuesto.
- **Cifra datos sensibles** con CMEK si necesitas control sobre las claves de cifrado.

## Enlaces relacionados
- **[gsutil](https://cloud.google.com/storage/docs/gsutil)** – herramienta de línea de comandos.
- **[IAM](https://cloud.google.com/iam)** – gestión de identidades y accesos.
- **[Storage Transfer Service](https://cloud.google.com/storage-transfer)** – migración de datos a Cloud Storage.
- **[Políticas de ciclo de vida](https://cloud.google.com/storage/docs/lifecycle)** – automatización de gestión de objetos.

## Datos Clave

- **Tamaño:** Ilimitado; se paga por uso (pay‑as‑you‑go) según la cantidad de datos almacenados y las operaciones.
- **Tamaño máximo por objeto:** 5 TB.
- **Subida paralela:** Para objetos > 100 MiB se emplea carga paralela (resumable upload) para mejorar el rendimiento.
- **Modelo de costes:** No hay inversión inicial (CapEx); los cargos son operacionales (OpEx) y se facturan por GB‑mes y por cada operación.
- **Durabilidad:** 99.999999999 % (eleven‑9s) garantizada, replicación automática entre regiones.
- **Latencia y disponibilidad:** Acceso de baja latencia a nivel global.
- **Cifrado en reposo:** Los datos se encriptan por defecto en reposo con claves gestionadas por Google.
- **Transporte seguro:** Los datos se transfieren mediante protocolos seguros como HTTPS o TLS.

