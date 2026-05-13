# ☁️ Google Cloud Platform – Soluciones y Prácticas

<p align="left"> <a href="https://cloud.google.com" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/google_cloud/google_cloud-icon.svg" alt="gcp" width="40" height="40"/> </a> </p>

Bienvenido a este repositorio, donde documento mis soluciones, prácticas y aprendizajes en **Google Cloud Platform (GCP)**.  
El objetivo es consolidar conocimientos, aplicar buenas prácticas y compartir ejemplos que pueden servir de guía a otros estudiantes y profesionales de la nube.

---

## 📂 Estructura del repositorio

Cada carpeta corresponde a un reto, práctica o solución implementada en GCP. Dentro encontrarás los pasos, código y configuraciones necesarias.

- Implementa Cloud Load Balancing para Compute Engine
  - [`(GSP007)-Configura balanceadores de cargas de red`](<./Implementa-Cloud-Load-Balancing-para-Compute-Engine/(GSP007)Configurar-balanceadores-de-cargas-de-red/>)
    En este lab práctico, aprenderás a configurar un balanceador de cargas de red (NLB) de transferencia que se ejecute en máquinas virtuales (VMs) de Compute Engine. Un NLB de capa 4 (L4) controla el tráfico según la información a nivel de la red, como las direcciones IP y los números de puerto, y no inspecciona el contenido del tráfico.
  - [`(GSP155)-Configura balanceadores de cargas de aplicaciones`](<./Implementa-Cloud-Load-Balancing-para-Compute-Engine/(GSP155)Configura-balanceadores-de-cargas-de-aplicaciones/>)
    En este lab práctico, aprenderás a configurar un balanceador de cargas de aplicaciones de capa 7 (L7) en máquinas virtuales (VMs) de Compute Engine. Los balanceadores de cargas L7 pueden comprender los protocolos HTTP(S), lo que les permite tomar decisiones de enrutamiento basadas en parámetros como la URL, los encabezados, las cookies y el contenido de la solicitud. Esto permite mejorar el rendimiento y la capacidad de respuesta de las aplicaciones.
- [`(GSP313)-Implementa el balanceo de cargas`](<./(GSP313)Implementa-el-balanceo-de-cargas/>)  
  Configuración de un **Load Balancer** en GCP para distribuir el tráfico entre múltiples instancias, asegurando alta disponibilidad y escalabilidad.
- [`(GSP315)-Configura un entorno de desarrollo de apps en Google Cloud`](<./(GSP315)Configura-un-entorno-de-desarrollo-de-apps-enGoogle-Cloud/>)  
  Configuración de las herramientas y servicios esenciales de Google Cloud para crear un entorno de desarrollo robusto y eficiente.
- [`(GSP322)-Red de Google Cloud segura`](<./(GSP322)Red-de-Google-Cloud-segura/>)
  Diseño e implementación de una red en Google Cloud con políticas de seguridad, reglas de firewall y controles de acceso para proteger los recursos y el tráfico.
- [`(GSP323)-Prepara datos para las APIs de AA en Google Cloud`](<./(GSP323)Prepara-datos-para-las-APIs-de-AA-en-Google-Cloud/>)
  Proceso de preparación, limpieza y transformación de datos para su uso en APIs de aprendizaje automático (AA) dentro de Google Cloud, asegurando calidad y compatibilidad.

_(La lista se irá ampliando conforme agregue más soluciones.)_

---

## � Guías y Referencias Generales

- [`Conceptos de Google Cloud Platform`](./GCP.md)  
  Apuntes sobre la infraestructura global, seguridad, facturación, jerarquía de recursos e IAM.
- [`Redes en Google Cloud (VPC)`](./VPC.MD)
  Explicación sobre la Nube Privada Virtual (VPC), subredes y la diferencia fundamental entre alcance regional y global.
- [`Verificaciones de estado (Health Checks)`](./Health-Checks-Legacy-vs-Global.md)
  Diferencias clave entre las verificaciones de estado heredadas (legacy) y las globales/modernas.
- [`Comandos de GCP`](./Comandos/indice.md)
  Hoja de referencia con los comandos de `gcloud.

---

## �🛠️ Tecnologías y servicios de GCP usados

- Compute Engine
- Cloud Load Balancing
- Cloud Shell / gcloud CLI
- (y otros que se vayan incorporando)

---

## 🎯 Objetivos del repositorio

- Reforzar conceptos clave de arquitectura en la nube.
- Documentar configuraciones y buenas prácticas.
- Mostrar casos de uso reales con GCP.

---

## 📌 Próximos pasos

✔️ Continuar agregando soluciones prácticas de GCP.  
✔️ Integrar diagramas de arquitectura.  
✔️ Documentar comandos y scripts reutilizables.

---

## 📄 Licencia

Este repositorio está bajo la licencia **MIT**, por lo que puedes usarlo y adaptarlo libremente.

---

✍️ \_Autor: [Daniel Jiménez](https://github.com/stonedjjh)
