# Health-Checks-Legacy-vs-Global.md

### Verificaciones de estado (Health Checks) heredadas

En Google Cloud Platform, el término heredada (legacy) se refiere a las versiones anteriores de las verificaciones de estado que se utilizaban antes de la unificación del sistema de health checks. Estas se diferencian de las verificaciones de estado modernas en su alcance, versatilidad y compatibilidad con los distintos balanceadores de carga.

#### Diferencias principales

1. Protocolos soportados:

- Heredadas: Existen comandos específicos para cada protocolo, como gcloud compute http-health-checks (solo para HTTP) o gcloud compute https-health-checks (solo para HTTPS).
- Modernas: Se utiliza un comando unificado gcloud compute health-checks create [PROTOCOL], que soporta HTTP, HTTPS, TCP, SSL, HTTP2 y gRPC.

2. Ámbito de aplicación:

- Heredadas: Se utilizan principalmente para Target Pools (usados en Network Load Balancers externos de paso) y algunos balanceadores de carga de aplicaciones antiguos.
- Modernas: Son compatibles con la mayoría de los recursos actuales, incluyendo grupos de instancias administrados (MIG), balanceadores de carga globales (HTTP/S, SSL Proxy, TCP Proxy) y servicios de backend modernos.

3. Flexibilidad:

- Las verificaciones modernas permiten definir de forma más precisa el puerto (por nombre o número) y son más eficientes en la gestión de recursos de red dentro de la infraestructura de Google.

#### Cuándo utilizar cada una

- Se debe usar una verificación de estado heredada únicamente si el recurso que se está configurando requiere específicamente un Target Pool o si se está trabajando con un balanceador de carga de red antiguo que no admite las nuevas verificaciones.
- Se debe usar una verificación de estado moderna para cualquier despliegue nuevo, ya que ofrecen mejores opciones de monitoreo, soporte para múltiples protocolos y una integración más profunda con las capacidades actuales de la nube.

#### Comparación de comandos

| Característica | Verificación Heredada             | Verificación Moderna                       |
| :------------- | :-------------------------------- | :----------------------------------------- |
| Comando base   | gcloud compute http-health-checks | gcloud compute health-checks               |
| Protocolos     | Único por comando (HTTP o HTTPS)  | Múltiples (HTTP, HTTPS, TCP, etc.)         |
| Uso principal  | Target Pools (Network LB antiguo) | Backend Services (HTTP/S, TCP Proxy, etc.) |
| Recomendación  | Solo por retrocompatibilidad      | Estándar para nuevos proyectos             |

Nota para el examen: Identificar que gcloud compute health-checks es la herramienta estándar actual. Si el comando incluye el protocolo inmediatamente después de compute (como compute http-health-checks), se trata de una herramienta heredada.
