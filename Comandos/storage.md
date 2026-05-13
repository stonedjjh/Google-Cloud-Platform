# Storage

## Bucket de almacenamiento

Para crear un bucket de almacenamiento se usa el comando `gcloud storage buckets`

para [referencia](https://docs.cloud.google.com/storage/docs/buckets?hl=es-419)

### Crear un bucket

Para crear un bucket se usa el comando `gcloud storage buckets create`

**Ejemplo:**

```bash
gcloud storage buckets create gs://BUCKET_NAME --location=BUCKET_LOCATION
```

En este ejemplo:

- `BUCKET_NAME` es el nombre del bucket

- `--location` es el flag que permite establecer la ubicación del bucket para [infomración](https://docs.cloud.google.com/storage/docs/locations?hl=es-419)

Configura las siguientes marcas para tener un mayor control sobre la creación de tu bucket:

- **--project:** Especifica el ID o el número del proyecto con el que se asociará el bucket. Por ejemplo, my-project

- **--default-storage-class**: Especifica la clase de almacenamiento predeterminada de tu bucket. Por ejemplo, STANDARD.

- **--uniform-bucket-level-access**: Habilita el acceso uniforme a nivel de bucket para el bucket.

- **--soft-delete-duration**: Especifica una duración de retención de borrar de forma no definitiva, que es la cantidad de días que deseas retener los objetos después de que se borren. Por ejemplo, 10d.

- **--encryption-enforcement-file**: Proporciona un archivo que define qué métodos de encriptación están restringidos o permitidos para los objetos nuevos en el bucket.
