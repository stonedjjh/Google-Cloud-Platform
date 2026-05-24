# Comandos de sql instances

Para operaciones con una instancia de Cloud SQL usaremos el comando `gcloud sql instances`

Para [referencias](https://docs.cloud.google.com/sdk/gcloud/reference/sql/instances)

## Crear una instancia

Para crear una instancia de Cloud SQL usaremos el comando `gcloud sql instances create`

**Ejemplo:**

```bash
gcloud sql instances create instance-name \
    --database-version=MYSQL_5_7 \
    --tier=db-f1-micro \
    --region=us-central1
```

En este ejemplo:

- `instance-name` es el nombre de la instancia

- `--database-version` es el flag que permite establecer la versión de base de datos

- `--tier` es el flag que permite establecer el tipo de instancia

- `--region` es el flag que permite establecer la región

```bash

gcloud sql instances create $DB_INSTANCE_NAME \
    --database-version=MYSQL_5_7 \
    --tier=db-f1-micro \
    --region=$REGION \
    --zone=$ZONE \
    --storage-type=SSD \
    --storage-size=10 \
    --availability-type=zonal
```

En este ejemplo:

- `$DB_INSTANCE_NAME` es el nombre de la instancia

- `--database-version` es el flag que permite establecer la versión de base de datos

- `--tier` es el flag que permite establecer el tipo de instancia

- `--region` es el flag que permite establecer la región

- `--zone` es el flag que permite establecer la zona

- `--storage-type` es el flag que permite establecer el tipo de almacenamiento

- `--storage-size` es el flag que permite establecer el tamaño de almacenamiento

- `--availability-type` es el flag que permite establecer el tipo de disponibilidad

## Crear una base de datos

Para crear una base de datos en una instancia de Cloud SQL usaremos el comando `gcloud sql databases create`

**Ejemplo:**

```bash
gcloud sql databases create database-name \
    --instance=instance-name
```

En este ejemplo:

- `database-name` es el nombre de la base de datos

- `--instance` es el flag que permite establecer la instancia a la que pertenece la base de datos

## Crear un usuario

Para crear un usuario en una instancia de Cloud SQL usaremos el comando `gcloud sql users create`

**Ejemplo:**

```bash
gcloud sql users create user-name \
    --instance=instance-name \
    --password=user-password
```

En este ejemplo:

- `user-name` es el nombre del usuario

- `--instance` es el flag que permite establecer la instancia a la que pertenece el usuario

- `--password` es el flag que permite establecer la contraseña del usuario

## Conectar a una instancia

Para conectar a una instancia de Cloud SQL usaremos el comando `gcloud sql connect`

**Ejemplo:**

```bash
gcloud sql connect instance-name \
    --user=user-name \
    --password=user-password
```

En este ejemplo:

- `instance-name` es el nombre de la instancia

- `--user` es el flag que permite establecer el nombre del usuario

- `--password` es el flag que permite establecer la contraseña del usuario
