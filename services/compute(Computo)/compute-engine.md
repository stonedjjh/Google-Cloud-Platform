# Compute Engine

Compute Engine es el servicio de infraestructura como servicio (IaaS) de Google Cloud que permite crear y ejecutar máquinas virtuales (VMs) en la infraestructura global de Google.

## Configuración de una Máquina Virtual (VM)

Al crear una instancia de máquina virtual en Compute Engine, puedes personalizar los siguientes componentes:

- **Potencia de CPU y Memoria (Machine Types):** Puedes elegir entre familias de máquinas optimizadas para diferentes cargas de trabajo (propósito general, optimizadas para cómputo, optimizadas para memoria o aceleradas por GPU). También tienes la opción de crear **máquinas personalizadas (Custom Machine Types)** definiendo la cantidad exacta de vCPUs y memoria RAM que necesites.
- **Sistema Operativo (S.O.):** Puedes iniciar tu VM utilizando **imágenes públicas** proporcionadas y mantenidas por Google (Linux Debian, Ubuntu, CentOS, Rocky Linux, Red Hat, Windows Server, etc.) o utilizar **imágenes personalizadas** creadas por ti o tu organización.
- **Tipo de Almacenamiento (Discos):** Puedes acoplar discos de almacenamiento a tu VM según tus requisitos de rendimiento y persistencia:
  - **Discos Persistentes (Persistent Disks - PD):** Almacenamiento en red persistente y redundante. Si la VM se detiene o se destruye, los datos se conservan. Disponibles en versiones Standard (HDD), Balanced (SSD balanceado), SSD y Extreme.
  - **SSD Locales (Local SSD):** Discos de estado sólido conectados físicamente al servidor que aloja la VM. Ofrecen el mayor rendimiento de IOPS y menor latencia posible. Sin embargo, sus datos son **temporales** y se pierden si la instancia se detiene (Stop).

## Tipos de Instancias VM

Google Cloud ofrece una variedad de familias de instancias preconfiguradas, pero también permite la flexibilidad de crear instancias personalizadas.

### 1. Familias de Instancias Predeterminadas

Estas familias están diseñadas para cargas de trabajo específicas y ofrecen una relación precio-rendimiento optimizada para sus casos de uso:

- **Serie N1 (General Purpose):** Es la familia más antigua y versátil. Permite un alto grado de personalización en la asignación de CPUs y memoria.
- **Serie N2 (General Purpose):** Ofrece un mejor rendimiento y un precio más competitivo en comparación con la serie N1 para cargas de trabajo de propósito general.
- **Serie E2 (General Purpose - Cost-Optimized):** Diseñada para cargas de trabajo de propósito general con un enfoque principal en la **optimización de costos**. Ofrece precios significativamente más bajos (hasta un 30% más) que las familias N2/N1 a cambio de un rendimiento máximo ligeramente inferior.
- **Serie C3 (Compute-Optimized):** Orientada a aplicaciones que requieren alta capacidad de procesamiento (alto rendimiento de CPU), como servidores web, procesamiento de Big Data y HPC (Computación de Alto Rendimiento).
- **Serie M3 (Memory-Optimized):** Optimizada para aplicaciones que demandan grandes cantidades de memoria RAM, como bases de datos en memoria (SAP HANA, por ejemplo) o cachés de datos grandes.
- **Serie A3 (Accelerator-Optimized):** Diseñada específicamente para cargas de trabajo de Machine Learning e inferencia. Está acelerada con GPUs de alto rendimiento (NVIDIA H100).

### 2. Tipos de Máquinas Personalizadas (Custom Machine Types)

La capacidad de crear **Tipos de Máquinas Personalizadas** es una característica distintiva y muy valorada de Google Cloud.

- **Flexibilidad Total:** Permiten definir con precisión el número exacto de **vCPUs** y la cantidad de **memoria RAM** que deseas asignar a tu instancia.
- **Ajuste Perfecto:** Puedes ajustar los recursos a las necesidades exactas de tu aplicación, evitando el desperdicio de capacidad (y dinero) que a veces ocurre al usar tipos de máquinas predefinidos.
- **Ejemplo Práctico:** Si tu aplicación necesita 6 vCPUs y 12 GB de RAM, puedes crear una máquina personalizada que se ajuste exactamente a esas especificaciones, en lugar de aprovisionar una máquina estándar de 8 vCPUs que te sobraría.

## Spot VMs (Instancias Interrumpibles)

Las **Spot VMs** (anteriormente conocidas como *Preemptible VMs*) son instancias de bajo costo ideales para tareas por lotes (batch processing), análisis de datos o ambientes de pruebas que pueden tolerar interrupciones.

- **Gran Descuento:** Ofrecen una reducción de costos de entre el **60% y el 91%** en comparación con el precio estándar.
- **Riesgo de Interrupción:** Google Cloud puede reclamar la capacidad de cómputo y detener la VM en cualquier momento si otros clientes la necesitan.
- **Diferencia Clave (Preemptible vs. Spot):**
  - Las *Preemptible VMs (legadas)* tienen un límite máximo de ejecución de **24 horas**.
  - Las *Spot VMs (actuales)* no tienen un límite de tiempo de 24 horas y pueden durar días funcionando si la capacidad de Google lo permite.
- **Aviso de Terminación:** Compute Engine envía una notificación de interrupción **30 segundos antes** de apagar la VM (lo que permite realizar tareas rápidas de guardado o limpieza).
- **Parámetro para Creación (CLI `gcloud`):**
  Para crear una Spot VM desde la línea de comandos, se añade la siguiente bandera de aprovisionamiento:
  ```bash
  --provisioning-model=SPOT
  ```

> [!NOTE]
> Para el modelo legado Preemptible, se utilizaba la bandera `--preemptible`.


## Modelos de Descuento

Compute Engine ofrece esquemas de descuento para reducir costos en cargas de trabajo continuas o predecibles:

- **Descuentos por Uso Continuo (Sustained Use Discounts - SUD):**
  - **Automático:** Se aplican de forma automática sin necesidad de contratos ni configuraciones adicionales.
  - **Funcionamiento:** Google calcula el tiempo que tus instancias de VM corren durante el mes de facturación. Si una VM (o un grupo de VMs de la misma serie) corre por **más del 25% del mes**, Google aplica un descuento progresivo sobre la tarifa estándar (pudiendo llegar hasta un 30% de descuento si corre el 100% del mes).
- **Descuentos por Compromiso de Uso (Committed Use Discounts - CUD):**
  - **Por Contrato:** Requieren un compromiso formal de compra de recursos (vCPUs, memoria, GPUs, etc.) por un periodo de **1 o 3 años**.
  - **Funcionamiento:** Son ideales para cargas de trabajo estables y predecibles. A cambio de este compromiso, obtienes descuentos masivos (hasta un 57% en máquinas estándar y hasta un 70% en optimizadas para memoria). *(Es el equivalente a las Reserved Instances / Savings Plans de AWS).*

## Grupos de Instancias (Instance Groups)

Los grupos de instancias te permiten administrar múltiples máquinas virtuales como una sola entidad. En Compute Engine existen dos tipos de grupos:

### 1. Plantilla de Instancia (Instance Template)
* Es un recurso **global** que define la configuración de las VMs (sistema operativo, tamaño de disco, tipo de máquina, etiquetas de red, etc.).
* **Regla de examen:** Una plantilla de instancia **es inmutable**. Una vez creada, no se puede editar. Si necesitas cambiar algo, debes crear una nueva versión de la plantilla y actualizar el grupo de instancias con ella.

### 2. Grupos de Instancias Administrados (MIG - Managed Instance Groups)
* Utilizan una **Plantilla de Instancia** para crear un grupo de VMs **idénticas**.
* **Características Clave:**
  * **Auto-healing (Auto-recuperación):** Asocia un *Health Check*. Si una VM deja de responder o reporta fallos, el MIG la destruye y crea una nueva automáticamente a partir de la plantilla.
  * **Autoscaling (Escalado Automático):** Agrega o elimina VMs de forma dinámica según métricas (uso de CPU, capacidad del balanceador de carga o métricas personalizadas de Cloud Monitoring).
  * **Actualizaciones Graduales (Rolling Updates):** Permite actualizar el software o S.O. de las VMs progresivamente sin detener el servicio.
  * **Regional vs. Zonal:** Un MIG regional distribuye las VMs automáticamente en **múltiples zonas de una misma región** para ofrecer Alta Disponibilidad (HA).
  * **Uso en otros servicios:** Los clústeres de GKE utilizan MIGs por debajo para administrar sus grupos de nodos (*Node Pools*), y los balanceadores de carga los usan como backends de destino de tráfico.

### 3. Grupos de Instancias No Administrados (UMIG - Unmanaged Instance Groups)
* Agrupan máquinas virtuales que son **diferentes entre sí** (diferente S.O., tamaño o configuración).
* **Restricción de examen:** **NO soportan** ni autoscaling, ni auto-healing, ni plantillas de instancias. Solo sirven para distribuir tráfico con un balanceador de carga hacia VMs existentes que ya tenías creadas por separado.

## Datos Clave

- **Sin Inversión Inicial:** No se requieren inversiones iniciales de capital (CapEx) para adquirir hardware físico. Los costos se manejan como gastos operativos (OpEx), pagando únicamente por los recursos de cómputo consumidos.
- **Facturación por Segundo con Mínimo:** El uso de las VMs se factura por segundo, lo que permite un control muy preciso de costos. Sin embargo, existe un **cargo mínimo de 1 minuto (60 segundos)** de uso para cualquier instancia iniciada. Después del primer minuto, el cobro es estrictamente por segundo.
- **Equivalencia con AWS (Imágenes vs AMIs):** Las imágenes de disco (públicas o personalizadas) utilizadas para cargar el sistema operativo de las VMs en GCP son el equivalente directo a las **AMIs (Amazon Machine Images) de AWS**.