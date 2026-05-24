# ☁️ Google Cloud Platform – Soluciones y Prácticas

<p align="left"> <a href="https://cloud.google.com" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/google_cloud/google_cloud-icon.svg" alt="gcp" width="40" height="40"/> </a> </p>

Bienvenido a este repositorio, donde documento mis soluciones, prácticas y aprendizajes en **Google Cloud Platform (GCP)**.  
El objetivo es consolidar conocimientos, aplicar buenas prácticas y compartir ejemplos que pueden servir de guía a otros estudiantes y profesionales de la nube.

---

## 📂 Estructura del repositorio

Cada carpeta corresponde a un reto, práctica o solución implementada en GCP. Dentro encontrarás los pasos, código y configuraciones necesarias.

- Implementa Cloud Load Balancing para Compute Engine
  - [`(GSP007)-Configura balanceadores de cargas de red`](<./Implementa-Cloud-Load-Balancing-para-Compute-Engine/(GSP007)Configurar-balanceadores-de-cargas-de-red/README.md>)
    En este lab práctico, aprenderás a configurar un balanceador de cargas de red (NLB) de transferencia que se ejecute en máquinas virtuales (VMs) de Compute Engine. Un NLB de capa 4 (L4) controla el tráfico según la información a nivel de la red, como las direcciones IP y los números de puerto, y no inspecciona el contenido del tráfico.
  - [`(GSP155)-Configura balanceadores de cargas de aplicaciones`](<./Implementa-Cloud-Load-Balancing-para-Compute-Engine/(GSP155)Configura-balanceadores-de-cargas-de-aplicaciones/README.md>)
    En este lab práctico, aprenderás a configurar un balanceador de cargas de aplicaciones de capa 7 (L7) en máquinas virtuales (VMs) de Compute Engine. Los balanceadores de cargas L7 pueden comprender los protocolos HTTP(S), lo que les permite tomar decisiones de enrutamiento basadas en parámetros como la URL, los encabezados, las cookies y el contenido de la solicitud. Esto permite mejorar el rendimiento y la capacidad de respuesta de las aplicaciones.
- [`(GSP101)-Implementa un sitio web y soluciona problemas`](<./(GSP101)Implementa-un-sitio-web-y-soluciona-problemas/README.md>)  
  Tu desafío es implementar el sitio en la nube pública. Para ello, debes completar las tareas que aparecen a continuación. En este ejercicio, usarás un servidor web Apache sencillo como marcador de posición para el sitio nuevo. ¡Buena suerte!
- [`(GSP303)-Configura el RDP seguro con un host de bastión de Windows`](<./(GSP303)Configura-el-RDP-seguro-con-un-host-de-bastión-de-Windows/README.md>)
  Implementar la máquina de Windows segura que no está configurada para la comunicación externa dentro de una nueva subred de VPC. Luego, implementar Microsoft Internet Information Server en dicha máquina segura. A los fines de este lab, todos los recursos se deben aprovisionar en la siguiente región y zona
- [`(GSP304)-Crea e implementa una imagen de Docker para un clúster de Kubernetes`](<./(GSP304)Crea-e-implementa-una-imagen-de Docker-para-un-clúster-de-Kubernetes/README.md>)
  Tu equipo de desarrollo desea adoptar un enfoque de microservicios alojados en contenedores para la arquitectura de aplicaciones. Debes probar la aplicación de ejemplo que te proporcionaron para garantizar que se pueda implementar en un contenedor de Google Kubernetes. El grupo de desarrollo proporcionó una aplicación sencilla en Go, llamada `echo-web`, con un Dockerfile y el contexto asociado, para que puedas crear una imagen de Docker inmediatamente.
- [`(GSP305)-Escala horizontalmente una aplicación alojada en contenedores y actualízala en un clúster de Kubernetes`](<./(GSP305)Escala-horizontalmente-una-aplicación-alojada-en-contenedores-y-actualízala-en-un-clúster-de-Kubernetes/README.md>)
  Debes actualizar el código v1 de la aplicación `echo-app` en ejecución en la implementación `echo-web` al código v2 que recibiste. También debes escalar la aplicación horizontalmente a 2 instancias y confirmar que se estén ejecutando.
- [`(GSP306)-Migra una base de datos MySQL a Google Cloud SQL`](<./(GSP306)Migra-una-base-de-datos-MySQL-a-Google-Cloud-SQL/README.md>)
  Tu desafío es migrar la base de datos a Cloud SQL y, luego, volver a configurar la aplicación para que ya no dependa de la base de datos MySQL local. ¡Buena suerte!
- [`(GSP313)-Implementa el balanceo de cargas`](<./(GSP313)Implementa-el-balanceo-de-cargas/README.md>)  
  Configuración de un **Load Balancer** en GCP para distribuir el tráfico entre múltiples instancias, asegurando alta disponibilidad y escalabilidad.
- [`(GSP315)-Configura un entorno de desarrollo de apps en Google Cloud`](<./(GSP315)Configura-un-entorno-de-desarrollo-de-apps-enGoogle-Cloud/README.md>)  
  Configuración de las herramientas y servicios esenciales de Google Cloud para crear un entorno de desarrollo robusto y eficiente.
- [`(GSP322)-Red de Google Cloud segura`](<./(GSP322)Red-de-Google-Cloud-segura/README.md>)
  Diseño e implementación de una red en Google Cloud con políticas de seguridad, reglas de firewall y controles de acceso para proteger los recursos y el tráfico.
- [`(GSP323)-Prepara datos para las APIs de AA en Google Cloud`](<./(GSP323)Prepara-datos-para-las-APIs-de-AA-en-Google-Cloud/README.md>)
  Proceso de preparación, limpieza y transformación de datos para su uso en APIs de aprendizaje automático (AA) dentro de Google Cloud, asegurando calidad y compatibilidad.
- [`(GSP510)-Administra Kubernetes en Google Cloud`](<./(GSP510)Administra-Kubernetes-en-Google-Cloud/README.md>)
  Como parte del entorno de la zona de pruebas, tus desarrolladores crearon un repositorio de Artifact Registry llamado ==cluster name==, que incluye un fragmento de código con una aplicación de ejemplo básica que implementarás en un clúster.

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
