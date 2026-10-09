# Integrar una app externa con el Community Hub

El proyecto compartido se inicializa como un segundo `FirebaseApp`. No se debe
reemplazar el Firebase `[DEFAULT]` de la aplicación del asistente.

## 1. Opciones independientes

Mantén las opciones del Hub en un archivo distinto a `firebase_options.dart`:

```dart
abstract final class CommunityFirebaseOptions {
  static const web = FirebaseOptions(
    apiKey: '<HUB_API_KEY>',
    appId: '<HUB_APP_ID>',
    messagingSenderId: '<HUB_SENDER_ID>',
    projectId: 'full-day-comunnity-hub',
    authDomain: 'full-day-comunnity-hub.firebaseapp.com',
  );
}
```

La configuración web normal de Firebase no es un secreto. Authentication y
Firestore Security Rules son quienes protegen los datos.

Para Android o iOS, registra también el package name o bundle ID real de la app
cliente dentro del proyecto Hub y usa el `appId` específico de esa plataforma.
No reutilices el `appId` móvil del Community Wall en una aplicación con otro
package o bundle ID.

## 2. Crear el segundo Firebase

```dart
final existing = Firebase.apps.where((app) => app.name == 'community');
final communityApp = existing.isNotEmpty
    ? existing.first
    : await Firebase.initializeApp(
        name: 'community',
        options: CommunityFirebaseOptions.currentPlatform,
      );

final communityAuth = FirebaseAuth.instanceFor(app: communityApp);
final communityFirestore = FirebaseFirestore.instanceFor(app: communityApp);
```

## 3. Autenticación independiente

```dart
final communityUser = communityAuth.currentUser ??
    (await communityAuth.signInAnonymously()).user;
```

El UID de `communityUser` pertenece al Hub. No tiene por qué coincidir con el
UID del Firebase personal.

## 4. Registrar al participante

```dart
final participant = communityFirestore
    .collection('participants')
    .doc(communityUser!.uid);

final current = await participant.get();
await participant.set({
  'uid': communityUser.uid,
  'name': profile.name,
  'role': profile.role,
  'community': profile.community,
  'joinedAt': current.data()?['joinedAt'] ?? FieldValue.serverTimestamp(),
  'lastSeenAt': FieldValue.serverTimestamp(),
});
```

## 5. Escuchar mensajes

```dart
final messages = communityFirestore
    .collection('messages')
    .orderBy('createdAt', descending: true)
    .limit(50)
    .snapshots();
```

No se usa polling. Cada cambio llega por el stream de Firestore.

## 6. Enviar un mensaje

```dart
final reference = communityFirestore.collection('messages').doc();
await reference.set({
  'id': reference.id,
  'authorId': communityUser.uid,
  'authorName': profile.name,
  'authorRole': profile.role,
  'authorCommunity': profile.community,
  'text': text.trim(),
  'createdAt': FieldValue.serverTimestamp(),
});
```

El texto debe tener entre 1 y 280 caracteres. Las reglas del Hub vuelven a
validar identidad, campos y longitud en el servidor.
