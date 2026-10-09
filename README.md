# Full Day Community Hub

Community Wall en tiempo real para el workshop **Flutter + Firebase**.

```text
BUILD YOUR NODE · JOIN THE NETWORK · SHIP IT
```

El proyecto contiene el backend Firebase compartido y el Wall Flutter Web que
se proyecta durante el evento. Los asistentes se conectan a este proyecto como
un segundo `FirebaseApp` llamado `community`.

## Stack

- Flutter y Material 3
- Firebase Core
- Anonymous Authentication
- Cloud Firestore realtime streams
- Firebase Hosting clásico
- Firebase Spark Plan

No usa Functions, Cloud Run, App Hosting ni servicios que requieran billing.

## Preparación manual en Firebase Console

El workspace está configurado para el proyecto existente
`full-day-comunnity-hub`.

1. Abre Firebase Console.
2. En Authentication → Sign-in method, habilita **Anonymous**.
3. Crea la base Cloud Firestore predeterminada.
4. Conserva el plan Spark.
5. Publica las reglas únicamente después de revisarlas:

```bash
firebase use full-day-comunnity-hub
firebase deploy --only firestore:rules
```

No se incluye `.firebaserc` para evitar seleccionar un proyecto de forma
silenciosa. Comprueba siempre el proyecto activo antes de cualquier deploy.

## Ejecutar localmente

```bash
flutter pub get
flutter run -d chrome
```

Si Anonymous Authentication o Firestore todavía no están habilitados, la app
muestra una pantalla de configuración en lugar de fallar sin explicación.

## Verificaciones

```bash
dart format .
flutter analyze
flutter test
flutter build web
```

## Hosting clásico

`firebase.json` usa `build/web` y una rewrite a `index.html`.

```bash
flutter build web
firebase use full-day-comunnity-hub
firebase deploy --only hosting
```

No ejecutes deploy sin confirmar antes el proyecto seleccionado.

## Probar realtime con dos usuarios

1. Abre el Wall en Chrome normal.
2. Ejecuta el Node en otro perfil de navegador o en incógnito.
3. Completa My Space y entra a Community.
4. Envía `Hola Full Day 🚀`.
5. El mensaje debe aparecer en ambos clientes sin refrescar.

## Estructura principal

```text
lib/
├── app/
├── core/firebase/
└── features/community/
    ├── domain/
    ├── data/
    └── presentation/
```

La UI conoce `CommunityRepository`; solamente infraestructura conoce Firebase.

## Documentación

- [Integración de asistentes](docs/attendee-integration.md)
- [Especificación detallada](docs/instructions.md)
- [Definición general del sistema](../docs/system-overview.md)
