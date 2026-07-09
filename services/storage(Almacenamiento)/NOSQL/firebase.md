# Firebase (Plataforma móvil y base de datos NoSQL)

## Descripción general
Firebase es una plataforma de Google Cloud que ofrece servicios integrados para el desarrollo de aplicaciones móviles y web. Incluye una base de datos NoSQL orientada a documentos (Cloud Firestore), autenticación, hosting, funciones serverless, análisis y más, facilitando la creación de aplicaciones escalables sin gestionar infraestructura.

## Características principales
- **Serverless**: No requiere aprovisionamiento ni gestión de servidores; la infraestructura subyacente es administrada por Google.
- **Basada en documento**: Los datos se almacenan como documentos JSON dentro de colecciones, permitiendo esquemas flexibles y consultas estructuradas.
- **Cache en memoria**: Firebase utiliza caché en memoria en el cliente y en el backend, lo que permite lecturas rápidas y operación sin conexión a internet (offline).
- **Sincronización en tiempo real**: Cambios en los datos se replican instantáneamente a todos los clientes suscritos.
- **Seguridad integrada**: Reglas de seguridad basadas en Firebase Authentication e IAM; cifrado en reposo y en tránsito (HTTPS/TLS).
- **Escalabilidad automática**: La capacidad se ajusta automáticamente según la carga sin intervención manual.
- **Modos de operación (Nativo vs. Datastore)**: Cloud Firestore puede funcionar en dos modos sobre la misma infraestructura: el **Modo Nativo**, optimizado para las funciones de tiempo real y caché en el cliente móvil/web, y el **Modo Datastore**, que desactiva el tiempo real para enfocarse en backends tradicionales de alta escala, operaciones servidor a servidor y total compatibilidad con aplicaciones heredadas de App Engine.

## Datos clave
- **Tamaño**: Ilimitado; se paga por uso (pay‑as‑you‑go) según la cantidad de lecturas, escrituras y almacenamiento.
- **Tamaño máximo por documento**: 1 MiB.
- **Subida paralela**: Para operaciones de gran volumen se emplea carga paralela y reintentos automáticos.
- **Modelo de costos**: Facturación por operaciones (lectura/escritura) y por GB‑mes almacenado.

## Seguridad y cumplimiento
- **Cifrado en reposo**: Los datos se cifran por defecto con claves gestionadas por Google.
- **Transporte seguro**: Todas las comunicaciones utilizan HTTPS/TLS.
- **Control de acceso**: Configurable mediante reglas de seguridad y Firebase Authentication.

## Casos de uso típicos
- Aplicaciones móviles con sincronización en tiempo real.
- Juegos multijugador que requieren datos actualizados al instante.
- Aplicaciones web progresivas (PWA) que necesitan operar offline.
- Prototipos rápidos y MVPs con infraestructura gestionada.

## Enlaces relacionados
- **[Documentación oficial de Firebase](https://firebase.google.com/docs)** – Guías, referencia y mejores prácticas.
- **[Firestore](https://firebase.google.com/docs/firestore)** – Base de datos NoSQL orientada a documentos.
- **[Firebase Authentication](https://firebase.google.com/docs/auth)** – Gestión de usuarios y seguridad.
- **[Firebase Hosting](https://firebase.google.com/docs/hosting)** – Hosting estático y funciones serverless.
