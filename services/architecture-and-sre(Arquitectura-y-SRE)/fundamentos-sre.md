# Fundamentos de SRE y Operaciones

Dentro del pilar de Excelencia Operativa y Confiabilidad (Reliability) de Google Cloud, existen conceptos clave derivados de **SRE (Site Reliability Engineering)**. Google inventó SRE como la forma en que los ingenieros de software operan los sistemas.

A continuación, definimos los términos críticos para entender cómo medir y garantizar la confiabilidad.

## 1. SLI (Service Level Indicator) - "El Termómetro"
**¿Qué es?** Un Indicador de Nivel de Servicio es una **medida cuantitativa** (un número real) de algún aspecto del nivel de servicio que se está prestando.
* **Debe ser Medible:** "Rápido" o "Alta Disponibilidad" no son SLIs porque son subjetivos. "Peticiones HTTP GET que responden en menos de 400ms agregadas por minuto" sí es un SLI.
* **Fórmula clásica:** `(Eventos Buenos / Total de Eventos) * 100`
* **Métricas según el tipo de sistema:**
  * *Sistemas orientados al usuario:* Disponibilidad (¿respondió?), Latencia (¿cuánto tardó?), Capacidad de procesamiento / Throughput (¿cuántas solicitudes soporta?).
  * *Sistemas de almacenamiento de datos:* Latencia (tiempo de lectura/escritura), Disponibilidad (¿están los datos disponibles cuando se necesitan?), Durabilidad (si hay un fallo, ¿perdemos datos?).
* **El Peligro de los Promedios (Agregación):**
  * Medir usando promedios simples puede ocultar fallas críticas. Por ejemplo, recibir 1000 solicitudes en segundos pares y 0 en segundos impares da un promedio de 500/s, ocultando que tu servidor colapsa la mitad del tiempo bajo picos extremos.
  * **Solución (Percentiles):** Es mejor usar percentiles para métricas como la latencia. Un percentil 99 (p99) muestra los valores del peor de los casos (la peor experiencia de usuario), mientras que el percentil 50 (p50) indica el caso típico.

## 2. SLO (Service Level Objective) - "El Objetivo Interno"
**¿Qué es?** Un Objetivo de Nivel de Servicio es un **valor objetivo o rango de valores** que deseamos que alcance un SLI.
* **Fórmula:** `SLI >= Objetivo`
* **Ejemplo de Múltiples SLOs (Curva de Rendimiento):** A veces un solo SLO no basta para entender la experiencia. Es mejor usar varios umbrales:
  * El 90% de las peticiones HTTP GET responden en < 50ms.
  * El 99% responden en < 100ms.
  * El 99.9% responden en < 500ms.
* **Mejores Prácticas para definir SLOs:**
  * **No apuntes demasiado alto al inicio:** Es mejor empezar con SLOs bajos y ajustarlos con el tiempo. Los SLOs inalcanzables generan esfuerzo sobrehumano y frustran al equipo.
  * **Evita el 100% absoluto:** Un SLO del 100% no es realista, dispara los costos de operación, aumenta la complejidad y ralentiza la innovación (nadie querrá lanzar código nuevo por miedo). Además, el usuario final a menudo no nota la diferencia (ej. usuarios en redes móviles).
  * **Mantenlos simples y mínimos:** Tener demasiados SLOs o SLIs complejos oculta los verdaderos problemas de rendimiento.
  * **Presupuesto de Error (Error Budget):** La diferencia entre tu SLO y el 100% es tu presupuesto de error. Si tu SLO es 99%, tienes un 1% de presupuesto para fallar, hacer mantenimiento o experimentar.

## 3. SLA (Service Level Agreement - ANS) - "El Contrato Legal/Comercial"
**¿Qué es?** Un Acuerdo de Nivel de Servicio (ANS en español) es un **contrato legal** entre el proveedor del servicio y el cliente. 
* **Regla 1:** No todos los servicios tienen ANS (SLA), pero *todos* los servicios internos deben tener SLO.
* **Regla 2 (El Búfer):** El umbral del ANS siempre debe ser **más bajo (menos estricto)** que el SLO. Esto crea un "búfer" de seguridad. Si tu sistema empieza a fallar y rompes tu SLO, aún tienes capacidad y tiempo para arreglarlo antes de romper el ANS.
* **Consecuencias Comerciales:** Si no cumples el ANS, hay penalizaciones (ej. devolver dinero o dar créditos). Por eso, es mejor ser conservador; establecer un ANS demasiado alto puede causar el pago de compensaciones innecesarias, y quitar un ANS es muy difícil.
* **Ejemplo Completo (SLI -> SLO -> SLA):**
  * *SLI:* Latencia end-to-end de respuestas HTTP 200 (agregado por minuto).
  * *SLO:* El 99% de las respuestas deben ser <= 200ms.
  * *SLA (ANS):* El cliente recibirá compensación si la latencia del percentil 99 excede los 300ms. (Aquí el búfer de protección es de 100ms).

## 4. KPI (Key Performance Indicator) - "El Indicador de Negocio"
**¿Qué es?** Una métrica que indica tu progreso para alcanzar un objetivo. Los encargados de negocio usan KPIs para medir el valor de los proyectos y no desperdiciar recursos.
* **Categorías:**
  * *Comerciales:* ROI, deserción de clientes (churn), rotación de personal.
  * *Técnicos (alineados al negocio):* Páginas vistas, registros de usuarios, confirmaciones de compra.
* **Características de un buen KPI:**
  * **Específico:** "Fácil de usar" es subjetivo. "Accesible en virtud del artículo 508" es específico.
  * **Medible:** Te indica matemáticamente si te acercas o te alejas del objetivo.
  * **Alcanzable:** Esperar un 100% de conversiones de ventas en un sitio web no es realista.
  * **Relevante:** Si mejoras el KPI pero el objetivo final (ej. Ganancias) no sube, el KPI no servía.
  * **Limitado en el tiempo:** Se mide en periodos claros (¿es disponibilidad por día, mes o año?).
* **Regla de oro:** Un KPI *no es el objetivo*. El objetivo es el resultado final (ej. Aumentar las ventas de la tienda). El KPI es la métrica asociada para medir el progreso (ej. Porcentaje de conversiones en el sitio web).

## Análisis de Requisitos y Diseño de Arquitectura

Antes de definir SLOs o escribir código, un Arquitecto de Cloud debe recopilar los requisitos del sistema respondiendo 5 preguntas clave:
1. **Quiénes:** Determinar los usuarios directos e indirectos, desarrolladores y stakeholders.
2. **Qué:** Funcionalidad principal requerida (sin ambigüedades).
3. **Por qué:** El problema que el sistema busca solucionar. *El "por qué" es fundamental para definir los KPIs, SLOs y SLAs.*
4. **Cuándo:** Cronograma realista para ayudar a limitar el alcance.
5. **Cómo:** Determina los **requisitos no funcionales** (ej. usuarios simultáneos, latencia, tamaño de carga útil, distribución geográfica).

### Roles de Usuario y Arquetipos
Para entender el "Quién" y el "Qué", utilizamos Roles y Arquetipos:
*   **Rol de Usuario:** Representa el *objetivo* de un usuario (o de otro sistema, como un microservicio) en un momento determinado. Ej: "Comprador", "Administrador". 
    *   *Proceso:* Lluvia de ideas -> Organizar/Agrupar -> Consolidar (quitar duplicados) -> Refinar (añadir contexto de frecuencia y experiencia).
*   **Arquetipo:** Una representación *imaginaria y personalizada* de un rol de usuario que ayuda al equipo a empatizar con sus necesidades.
    *   *Ejemplo:* "Jacinta es madre y trabajadora muy ocupada. Quiere ahorrar tiempo en sus operaciones bancarias." Esto ayuda a los arquitectos a deducir que el sistema debe priorizar la automatización y la baja latencia.

## 5. Historias de Usuario (User Stories) y Criterios INVEST
**¿Qué es?** Son descripciones estructuradas de lo que el usuario desea que haga el sistema. Forman el puente claro entre los requerimientos del cliente y la implementación de los desarrolladores.
* **Estructura típica:** `Como [rol de usuario], deseo [hacer algo] para [obtener algún beneficio].`
* **Ejemplo:** *Consulta de Saldo:* "Como titular de la cuenta, deseo consultar mi saldo disponible en cualquier momento del día para asegurarme de no sobregirar la cuenta."
* **Relación con SRE:** Los SLOs se diseñan basados en el "viaje del usuario" (User Journeys) extraído de estas historias. De nada sirve medir que la CPU esté al 50% si el usuario no puede hacer su "Consulta de saldo".

### Criterios INVEST (Calidad de la Historia)
Una buena historia de usuario debe cumplir con la sigla **INVEST**:
*   **I (Independiente):** No debe depender de otras historias, para evitar bloqueos de planificación y priorización.
*   **N (Negociable):** No es un contrato estricto, sino el inicio de una conversación y colaboración entre cliente y desarrollador.
*   **V (Valor):** Debe proporcionar un valor claro (impacto o resultado) al usuario o al negocio.
*   **E (Estimable):** Debe tener el detalle necesario para que el equipo pueda estimar su esfuerzo. Si no, es muy ambigua o larga.
*   **S (Simple / Small):** Debe ser pequeña para limitar el alcance, reducir la ambigüedad y obtener feedback rápido.
*   **T (Testeable):** Debe poder comprobarse o validarse para que los desarrolladores sepan cuándo se implementó correctamente.

---

### Resumen Visual / Mnemotecnia

1. **SLI:** *¿Cuál es la temperatura actual del paciente?* (ej. 37.5°C)
2. **SLO:** *El objetivo es mantener la temperatura por debajo de 38°C.* (Meta médica).
3. **SLA:** *Si la temperatura pasa de 38°C, el hospital te devuelve tu dinero.* (Contrato legal).
4. **KPI:** *¿Cuántos pacientes curó el hospital hoy?* (Meta de negocio).
5. **Historia de Usuario:** *Como paciente, quiero que me curen la fiebre rápido para poder volver a trabajar.* (Requerimiento).
