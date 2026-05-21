# GKE

## Clusters

Para tabajar con Clusters se usa el comando `gcloud container clusters`

### Crear un cluster

Para crear un cluster se usa el comando `gcloud container clusters create`

**Ejemplo:**

```bash
gcloud container clusters create --machine-type=e2-medium --zone=ZONE lab-cluster
```

En este ejemplo:

- `--machine-type` es el flag que permite establecer el tipo de máquina

- `--zone` es el flag que permite establecer la zona

- `lab-cluster` es el nombre del cluster

En uso:

```bash
gcloud container clusters create --machine-type=e2-medium --zone=europe-west3-b lab-cluster
Note: Your Pod address range (`--cluster-ipv4-cidr`) can accommodate at most 1008 node(s).
Creating cluster lab-cluster in europe-west3-b...working.                                                                                                                                                                                                                                                                       CreatingCreating cluster lab-cluster in europe-west3-b... Cluster is being health-checked (Kubernetes Control Plane is healthy)...done.                                    
Created [https://container.googleapis.com/v1/projects/qwiklabs-gcp-00-c08487becf31/zones/europe-west3-b/clusters/lab-cluster].
To inspect the contents of your cluster, go to: https://console.cloud.google.com/kubernetes/workload_/gcloud/europe-west3-b/lab-cluster?project=qwiklabs-gcp-00-c08487becf31
kubeconfig entry generated for lab-cluster.
NAME: lab-cluster
LOCATION: europe-west3-b
MASTER_VERSION: 1.35.3-gke.1389000
MASTER_IP: 34.141.20.109
MACHINE_TYPE: e2-medium
NODE_VERSION: 1.35.3-gke.1389000
NUM_NODES: 3
STATUS: RUNNING
STACK_TYPE: IPV4
```

### Eliminar un cluster

Para eliminar un cluster se usa el comando `gcloud container clusters delete`

```bash
gcloud container clusters delete lab-cluster
# Salida
The following clusters will be deleted.
 - [lab-cluster] in [europe-west3-b]

Do you want to continue (Y/n)?  Y

Deleting cluster lab-cluster...done.                                                                                                                                                                    
Deleted [https://container.googleapis.com/v1/projects/qwiklabs-gcp-00-c08487becf31/zones/europe-west3-b/clusters/lab-cluster].
```

### Obtener autenticación

`gcloud container clusters get-credentials lab-cluster`

## Kubernetes

### Crear un deployment

Para crear un deployment se usa el comando `kubectl create deployment`

**Ejemplo:**

```bash
kubectl create deployment hello-server --image=gcr.io/google-samples/hello-app:1.0
# salida
deployment.apps/hello-server created
```

En este ejemplo:

- `hello-server` es el nombre del deployment

- `--image` es el flag que permite establecer la imagen

- `gcr.io/google-samples/hello-app:1.0` es la imagen

## Servicio

### Crear un servicio

Para crear un servicio se usa el comando `kubectl expose deployment`

**Ejemplo:**

`kubectl expose deployment hello-server --type=NodePort`

```bash
kubectl expose deployment hello-server --type=LoadBalancer --port 8080
# Salida
service/hello-server exposed
```

En este ejemplo:

- `--type` es el flag que permite establecer el tipo de servicio

- `--port` es el flag que permite establecer el puerto

- `8080` es el puerto

- `LoadBalancer` es el tipo de servicio

> [!TIP]
> `type="LoadBalancer"` crea un balanceador de cargas de Compute Engine para tu contenedor.

### Inspeccionar un servicio

Para inspeccionar el objeto Service usamos `kubectl get service`

**Ejemplo:**

```bash
kubectl get service
# Salida
NAME           TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
hello-server   LoadBalancer   10.39.244.36   <pending>     8080:30838/TCP   15s
kubernetes     ClusterIP      10.39.240.1    <none>        443/TCP          6m10s

kubectl get service
# Salida
NAME             TYPE            CLUSTER-IP      EXTERNAL-IP     PORT(S)           AGE
hello-server     loadBalancer    10.39.244.36    35.202.234.26   8080:31991/TCP    65s
kubernetes       ClusterIP       10.39.240.1                     433/TCP           5m13s
```

## Crear un espacio de nombres

Para crear un espacio de nombres se usa el comando `kubectl create ns`

```bash
kubectl create ns gmp-test
```