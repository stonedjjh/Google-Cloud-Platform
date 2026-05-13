# IAM

## Rol

### Crear un rol personalizado

Para crear un rol personalizado se usa el comando `gcloud iam roles create`

**Ejemplo:**

```bash
gcloud iam roles create customRoleName \
  --project=ProjectID \
  --title="Custom Role Title" \
  --description="Custom Role Description" \
  --permissions=compute.instances.get,compute.instances.list
```

En este ejemplo:

- `customRoleName` es el nombre del rol

- `--project` es el flag que permite establecer el proyecto

- `--title` es el flag que permite establecer el título del rol

- `--description` es el flag que permite establecer la descripción del rol

- `--permissions` es el flag que permite establecer los permisos del rol

### Cuenta de Servicio

Para crear una cuenta de servicio se usa el comando `gcloud iam service-accounts`

para referencia

### Crear

Para crear una cuenta de servicio se usa el comando `gcloud iam service-accounts create`

**Ejemplo:**

```bash
gcloud iam service-accounts create vmtobucket --display-name="Web Server Service Account"
```

En este ejemplo:

- `vmtobucket` es el nombre de la cuenta de servicio

- `--display-name` es el flag que permite establecer el nombre de la cuenta de servicio
