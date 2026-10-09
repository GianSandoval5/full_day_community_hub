> **Documento específico del Hub**
>
> La relación entre el Hub, el Node, el Firebase personal de prueba y los
> Firebase personales de los asistentes está unificada en
> [`../../docs/system-overview.md`](../../docs/system-overview.md).
> Ese documento es la fuente principal para decisiones que afecten a ambos
> proyectos. Este archivo conserva la especificación detallada del Hub.
>
> Estado actual: GO de implementación recibido. El deploy sigue requiriendo
> autorización explícita.

Quiero que construyas un proyecto profesional llamado **Full Day Community Hub** usando **Flutter + Firebase**, pensado para un workshop presencial donde múltiples asistentes tendrán sus propias aplicaciones Flutter independientes y se conectarán a este Hub central como un segundo proyecto Firebase.

## 1. Objetivo general

Necesito una aplicación central que funcione como el **Community Hub del evento**.

Cada asistente tendrá:

- Su propia app Flutter.
- Su propio Firebase Project.
- Su propio Firebase Authentication.
- Su propio Firestore.
- Su propio Firebase Hosting.
- Su propia URL desplegada.

Pero además, cada app inicializará este proyecto **Full Day Community Hub** como un segundo `FirebaseApp` llamado `community`.

Arquitectura conceptual:

```text
APP ASISTENTE
│
├── Firebase [DEFAULT]
│   └── Proyecto Firebase personal
│
└── Firebase [community]
    └── FULL DAY COMMUNITY HUB
            │
            ├── Anonymous Authentication
            └── Cloud Firestore
```

Este proyecto que vas a construir corresponde al:

```text
FULL DAY COMMUNITY HUB
```

y también tendrá una aplicación Flutter Web tipo **Community Wall**, que yo proyectaré en una pantalla durante el evento.

---

# 2. Restricción fundamental

TODO debe funcionar usando exclusivamente:

## Firebase Spark Plan

No debe requerir:

- Blaze Plan
- Tarjeta de crédito
- Cloud Functions
- Cloud Run
- Servicios que obliguen a habilitar billing

Usar solamente servicios compatibles con el nivel gratuito necesarios para este workshop:

- Firebase Authentication
- Anonymous Authentication
- Cloud Firestore
- Firebase Hosting clásico

NO usar Firebase App Hosting.

La aplicación Flutter Web se desplegará mediante:

```bash
flutter build web
firebase deploy --only hosting
```

Antes de implementar cualquier dependencia o comando, verifica en documentación oficial vigente de Flutter y Firebase cuál es la forma actual recomendada.

No uses versiones antiguas copiadas de tutoriales.

---

# 3. Stack

Usar:

- Flutter estable actual
- Dart estable correspondiente
- Firebase Core
- Firebase Authentication
- Cloud Firestore
- FlutterFire CLI
- Firebase CLI
- Material 3

Evita dependencias innecesarias.

Si necesitas manejo de estado, utiliza una solución sencilla, mantenible y apropiada para workshop. Prefiero Riverpod si realmente aporta valor, pero no quiero sobrearquitectura.

---

# 4. Arquitectura

Quiero que el proyecto refleje experiencia de **Mobile Architect**.

Usa una combinación pragmática de:

- Feature First
- Screaming Architecture
- Repository Pattern
- Separación Presentation / Domain / Data cuando tenga sentido
- Dependency inversion
- Interfaces para repositorios

Pero NO hagas una Clean Architecture ceremonial con decenas de archivos vacíos.

La estructura debe comunicar inmediatamente qué hace la aplicación.

Por ejemplo:

```text
lib/
│
├── app/
│   ├── app.dart
│   ├── router/
│   └── theme/
│
├── core/
│   ├── firebase/
│   ├── errors/
│   └── constants/
│
├── features/
│   │
│   ├── community/
│   │   ├── domain/
│   │   ├── data/
│   │   └── presentation/
│   │
│   ├── participants/
│   │   ├── domain/
│   │   ├── data/
│   │   └── presentation/
│   │
│   └── wall/
│       └── presentation/
│
└── main.dart
```

Puedes mejorarla si encuentras una alternativa más limpia.

---

# 5. Experiencia principal

Quiero una aplicación Flutter Web elegante que pueda proyectarse en una pantalla grande durante el evento.

Título:

# FULL DAY COMMUNITY HUB

Subtítulo:

```text
Flutter + Firebase
Build your node · Join the network
```

Debe tener estética:

- Dark
- Moderna
- Tecnológica
- Profesional
- Mobile Architect / Developer Conference
- Nada infantil
- Nada parecido a un template genérico administrativo

Paleta sugerida:

- Fondo oscuro
- Azul Flutter
- Cyan
- Algunos acentos inspirados en Firebase

Utiliza Material 3 y responsive design.

Debe verse bien en:

- 1920x1080
- Laptop
- Tablet
- Navegador móvil

---

# 6. Community Wall

La pantalla principal debe ser un **Community Wall en tiempo real**.

Diseño conceptual:

```text
┌──────────────────────────────────────────────────────┐
│ FULL DAY COMMUNITY HUB                    LIVE ●    │
│ Flutter + Firebase                                  │
│                                                      │
│          42 DEVELOPERS CONECTADOS                    │
│                                                      │
│  ┌──────────────────────────────────────────────┐   │
│  │ Gian Sandoval                                │   │
│  │ Mobile Architect · Flutter Piura             │   │
│  │                                              │   │
│  │ "Hola Full Day 🚀"                           │   │
│  │                                  ❤️ 12 🔥 8 │   │
│  └──────────────────────────────────────────────┘   │
│                                                      │
│  ┌──────────────────────────────────────────────┐   │
│  │ María                                        │   │
│  │ Flutter Developer                            │   │
│  │                                              │   │
│  │ "Firebase funcionando 🔥"                    │   │
│  └──────────────────────────────────────────────┘   │
│                                                      │
│              BUILD · CONNECT · SHIP                  │
└──────────────────────────────────────────────────────┘
```

Los mensajes deben aparecer automáticamente mediante Firestore realtime streams.

No utilizar polling.

---

# 7. Participantes

Crear colección:

```text
participants
```

Documento:

```text
participants/{uid}
```

Modelo mínimo:

```text
uid
name
role
community
joinedAt
lastSeenAt
```

Opcional:

```text
photoUrl
github
linkedin
```

Para el workshop quiero mantenerlo simple.

El participante debe poder registrarse en el Hub proporcionando:

- nombre
- rol
- comunidad

Ejemplo:

```text
Gian Sandoval
Mobile Architect
Flutter Piura
```

No necesito correo/password para entrar al Hub.

Usar:

# Firebase Anonymous Authentication

Cada aplicación cliente hará algo conceptualmente equivalente a:

```dart
FirebaseAuth.instanceFor(app: communityApp)
```

y después:

```dart
signInAnonymously()
```

El UID anónimo será la identidad del usuario dentro del Community Hub.

---

# 8. Mensajes

Crear colección:

```text
messages
```

Documento:

```text
messages/{messageId}
```

Modelo:

```text
id
authorId
authorName
authorRole
authorCommunity
text
createdAt
```

Opcional:

```text
reactions
```

Los mensajes deben ordenarse por:

```text
createdAt DESC
```

El muro debe actualizarse automáticamente.

Limitar longitud del mensaje, por ejemplo:

```text
280 caracteres
```

No permitir mensajes vacíos.

---

# 9. Reacciones

Si no complica demasiado el workshop, implementar reacciones simples:

```text
🔥
❤️
🚀
👏
```

No quiero una arquitectura demasiado compleja.

Una estructura posible:

```text
messages/{messageId}/reactions/{uid}
```

con:

```text
type
createdAt
```

Un usuario solo debería tener una reacción de cada tipo o una reacción activa, elige el modelo más sencillo y mantenible.

La UI debe actualizar contadores en realtime.

---

# 10. Seguridad Firestore

MUY IMPORTANTE:

NO utilizar:

```javascript
allow read, write: if true;
```

Quiero reglas de seguridad razonables incluso siendo un workshop.

Crear:

```text
firestore.rules
```

La regla general debe exigir:

```text
request.auth != null
```

Para participants:

- Puede leer un usuario autenticado.
- Puede crear su propio documento.
- `uid` debe coincidir con `request.auth.uid`.
- No debe poder modificar el participante de otra persona.

Conceptualmente:

```text
participants/{userId}

request.auth.uid == userId
```

Para messages:

- Usuario autenticado puede leer.
- Usuario autenticado puede crear.
- `authorId` debe ser igual a `request.auth.uid`.
- El texto debe tener longitud limitada.
- No aceptar campos arbitrarios.
- Un usuario solo puede modificar/eliminar sus propios mensajes.

Usa validaciones de campos con:

```text
keys().hasOnly(...)
```

si corresponde.

Usa:

```text
request.time
```

o timestamps del servidor cuando resulte apropiado.

No confíes solamente en validaciones del cliente.

---

# 11. Firebase indexes

Crear:

```text
firestore.indexes.json
```

solo si realmente se requiere algún índice compuesto.

No crear índices innecesarios.

---

# 12. Configuración Firebase

No hardcodear información privada.

La configuración normal de Firebase Web puede vivir en `firebase_options.dart`, ya que no debe tratarse como una credencial secreta, pero la seguridad debe depender de:

- Firebase Authentication
- Firestore Security Rules

Documenta claramente esta diferencia.

Crear documentación de cómo configurar:

```bash
flutterfire configure
```

Generar:

```text
firebase_options.dart
```

El repositorio NO debe asumir que ya existe mi proyecto Firebase.

---

# 13. README MUY IMPORTANTE

Crear un README profesional.

Debe explicar:

## Requisitos

- Flutter
- Firebase CLI
- FlutterFire CLI
- Cuenta Google

## Paso 1

Crear proyecto Firebase:

```text
full-day-community-hub
```

## Paso 2

Habilitar:

```text
Authentication
→ Sign-in method
→ Anonymous
```

## Paso 3

Crear:

```text
Cloud Firestore
```

## Paso 4

Ejecutar configuración FlutterFire.

## Paso 5

Aplicar reglas Firestore.

## Paso 6

Ejecutar Flutter Web localmente.

## Paso 7

Inicializar Firebase Hosting.

## Paso 8

Compilar:

```bash
flutter build web
```

## Paso 9

Deploy:

```bash
firebase deploy --only hosting
```

Indica explícitamente:

```text
Este proyecto funciona con Firebase Spark Plan.
No es necesario registrar tarjeta de crédito.
```

---

# 14. Necesito que las apps de los asistentes puedan conectarse

Este es uno de los puntos MÁS IMPORTANTES.

Además del Community Wall, genera documentación:

```text
docs/
└── attendee-integration.md
```

Ese documento debe explicar cómo una aplicación Flutter externa puede inicializar este Firebase como un proyecto secundario.

Ejemplo conceptual:

```dart
final communityApp = await Firebase.initializeApp(
  name: 'community',
  options: const FirebaseOptions(
    apiKey: '...',
    appId: '...',
    messagingSenderId: '...',
    projectId: '...',
  ),
);
```

Pero crea una implementación limpia.

Después:

```dart
final communityAuth =
    FirebaseAuth.instanceFor(app: communityApp);

final communityFirestore =
    FirebaseFirestore.instanceFor(app: communityApp);
```

Después:

```dart
await communityAuth.signInAnonymously();
```

Y finalmente explicar cómo:

```text
1. registrar participante
2. escuchar mensajes
3. publicar mensaje
4. reaccionar
```

Incluye snippets completos y reutilizables.

---

# 15. Crear un paquete/helper reutilizable

Si resulta limpio, crea dentro del proyecto una carpeta:

```text
integration/
```

o:

```text
examples/attendee_client/
```

con código que yo pueda copiar durante el workshop.

Por ejemplo:

```text
community_client.dart
community_repository.dart
community_participant.dart
community_message.dart
```

Quiero que integrar el Hub en la app de los asistentes requiera muy pocos pasos.

Idealmente:

```dart
final community = CommunityClient(...);

await community.connect();

await community.join(
  name: 'Gian Sandoval',
  role: 'Mobile Architect',
  community: 'Flutter Piura',
);

community.messages();

community.sendMessage('Hola Full Day 🚀');
```

No es obligatorio exactamente este API, pero quiero una experiencia equivalente y limpia.

---

# 16. Pantallas del Community Wall

Crear como mínimo:

## Splash / Loading

```text
FULL DAY COMMUNITY HUB

Connecting communities...
```

## Community Wall

Mostrar:

- logo/nombre del evento
- indicador LIVE
- cantidad de participantes
- mensajes en realtime
- reacciones
- nombre
- rol
- comunidad

## Empty State

Cuando nadie se haya conectado:

```text
Waiting for the community...

Build your node.
Join the network.
```

Debe verse bien proyectado en pantalla.

---

# 17. Animaciones

Agregar animaciones sutiles.

Ejemplos:

- mensaje nuevo aparece con fade + slide
- contador de participantes cambia suavemente
- LIVE indicator pulsa lentamente
- tarjetas tienen entrada ligera

No quiero:

- animaciones exageradas
- partículas innecesarias
- efectos infantiles
- consumo excesivo

---

# 18. QR

Dejar preparado visualmente un espacio para mostrar un QR.

El QR servirá posteriormente para:

- repositorio GitHub
- URL del workshop
- URL del Community Hub

No hardcodees un QR falso.

Crear un componente reutilizable donde luego pueda pasar la URL.

---

# 19. Estado vacío final

Cuando no haya mensajes, mostrar:

```text
The network is ready.

Be the first node to say hello.
```

---

# 20. Momento final del workshop

La experiencia final que quiero lograr es esta:

Cada asistente escribe desde SU aplicación:

```text
Una palabra sobre lo que te llevas hoy.
```

Por ejemplo:

```text
Arquitectura
Flutter
Firebase
Comunidad
Realtime
Mobile
Networking
```

Todos esos mensajes aparecen instantáneamente en el Community Wall proyectado.

Quiero que la UI permita que ese momento se vea impresionante.

Puedes agregar un modo:

```text
Community Wall Mode
```

que maximice los mensajes para proyección.

---

# 21. Arquitectura conceptual final

La solución debe respetar:

```text
                    ATTENDEE APP

                         UI
                          │
                ┌─────────┴─────────┐
                │                   │
          MY APPLICATION        COMMUNITY
                │                   │
          ProfileRepository   CommunityRepository
                │                   │
           Firebase #1          Firebase #2
          [DEFAULT APP]       [community APP]
                │                   │
         Personal Auth        Anonymous Auth
         Personal DB          Shared Firestore
```

Mientras que este proyecto implementará:

```text
           FULL DAY COMMUNITY HUB

              Firebase Project
                     │
            ┌────────┴────────┐
            │                 │
       Anonymous Auth     Cloud Firestore
                              │
                 ┌────────────┴─────────────┐
                 │                          │
            participants                messages
                 │                          │
                 └────────────┬─────────────┘
                              │
                         Flutter Web
                              │
                       COMMUNITY WALL
```

---

# 22. Código

Quiero código:

- limpio
- documentado donde realmente aporte
- null safe
- sin warnings
- sin TODO innecesarios
- sin código muerto
- sin archivos vacíos
- sin abstracciones sin uso
- sin secrets
- sin dependencias abandonadas

Aplicar:

```bash
dart format .
flutter analyze
```

y corregir todos los problemas razonables.

Si hay tests útiles, agrega tests unitarios para:

- modelos
- validaciones
- repositories donde tenga sentido

No necesito cobertura artificial.

---

# 23. Git

Crear un `.gitignore` correcto.

No hacer commit de:

- archivos locales
- caches
- credentials
- archivos temporales

Sí mantener en Git:

```text
firestore.rules
firestore.indexes.json
firebase.json
```

cuando corresponda.

---

# 24. Entrega

No quiero solamente scaffolding.

Quiero una aplicación funcional.

Al finalizar:

1. Muéstrame la estructura final.
2. Indícame qué archivos importantes creaste.
3. Ejecuta `flutter analyze`.
4. Ejecuta los tests.
5. Indícame cualquier paso que requiera interacción manual en Firebase Console.
6. Explícame cómo crear mi proyecto Firebase Community Hub.
7. Explícame cómo probar dos usuarios simultáneos.
8. Explícame cómo abrir dos navegadores diferentes y verificar realtime.
9. Explícame cómo conectaremos posteriormente la app individual de los asistentes.
10. No habilites ningún servicio de pago.
11. No cambies a Blaze Plan.
12. No registres tarjeta.
13. No hagas deploy a producción sin indicármelo primero.

Prioriza primero que todo funcione localmente.

---

# 25. Criterio de éxito

Consideraré terminado el proyecto cuando pueda hacer esto:

### Navegador 1

```text
Gian Sandoval
Mobile Architect
Flutter Piura

"Hola Full Day 🚀"
```

### Navegador 2

```text
María
Flutter Developer
GDG

"Firebase funcionando 🔥"
```

y ambos mensajes aparezcan inmediatamente en:

```text
FULL DAY COMMUNITY WALL
```

sin refrescar la página.

Después debo poder conectar una app Flutter externa usando el segundo:

```text
FirebaseApp(name: 'community')
```

autenticar anónimamente y participar en exactamente el mismo feed.

---

# 26. Importante durante el desarrollo

No supongas silenciosamente decisiones importantes.

Si encuentras una diferencia entre:

- una solución rápida para demo
- una solución arquitectónicamente adecuada

elige una solución intermedia apropiada para un **workshop técnico dirigido por un Mobile Architect**.

El código debe ser suficientemente sencillo para explicarlo en vivo, pero suficientemente profesional para publicarlo posteriormente como proyecto open source.

Empieza inspeccionando el entorno actual, verifica las versiones instaladas y construye el proyecto de extremo a extremo.
