# Cloud NAT (Network Address Translation)

Google Cloud NAT es un servicio administrado, distribuido y de alta disponibilidad que permite que las instancias de máquina virtual (VM) y los contenedores de GKE que no tienen direcciones IP externas se conecten a Internet para actualizaciones, parches, llamadas a APIs externas y otras tareas.

## Características clave
- **Sin Proxy/Gateway central**: Al ser un servicio de red definido por software (SDN), Cloud NAT no introduce un cuello de botella físico ni requiere una máquina virtual dedicada para el enrutamiento.
- **Seguridad**: Evita que recursos externos en el internet público inicien conexiones directas con tus instancias privadas.
- **Escalabilidad y Alta Disponibilidad**: Al ser un servicio administrado, escala automáticamente el ancho de banda y las direcciones IP necesarias según el tráfico.
- **Integración con Cloud Router**: Cloud NAT requiere un **Cloud Router** en la misma región para gestionar el enrutamiento y la configuración del NAT, aunque no pasa tráfico a través del router en sí.

## Funcionamiento
1. **Asociación**: Se asocia a una VPC, una Región y un Cloud Router específico.
2. **Direcciones IP de origen**: Puedes configurar Cloud NAT para asignar direcciones IP externas de forma:
   - **Automática**: GCP gestiona y asigna dinámicamente direcciones IP públicas.
   - **Manual**: Tú reservas direcciones IP externas estáticas y las asignas a la puerta de enlace de Cloud NAT (útil cuando los destinatarios requieren listas blancas de IP fijas).
3. **Mapeo de puertos**: Traduce las combinaciones de `IP privada + puerto` de las VMs a `IP pública + puerto` para direccionar el tráfico saliente.

## Configuración y Límites
- **Puertos mínimos por VM**: Por defecto asigna 64 puertos por instancia (permite un máximo de 64 conexiones simultáneas al mismo destino por protocolo). Esto se puede incrementar si la aplicación realiza múltiples conexiones salientes concurrentes.
- **Tipos de NAT**:
   - **Public NAT**: Para dar acceso de salida a la internet pública.
   - **Private NAT**: Para traducción de red privada a privada (por ejemplo, interconexiones híbridas donde hay colisiones de rangos CIDR).

## Procedimiento para crear Cloud NAT (gcloud)

1. **Crear el Cloud Router** (si aún no existe en la región):
   ```bash
   gcloud compute routers create router-nat-regional \
       --network=default \
       --region=us-central1
   ```

2. **Crear la puerta de enlace de Cloud NAT**:
   ```bash
   gcloud compute addresses create ip-nat-salida \
       --region=us-central1

   gcloud compute routers nats create gateway-nat \
       --router=router-nat-regional \
       --region=us-central1 \
       --nat-custom-ips=ip-nat-salida \
       --nat-all-subnet-ip-ranges
   ```

## Datos Clave
- **Sin costo por transferencia interna**: Solo se factura el procesamiento de datos salientes a internet y una tarifa por hora del gateway.
- **No es bidireccional**: No permite mapeos estáticos de puertos entrantes (DNAT); solo sirve para tráfico de salida (SNAT).
