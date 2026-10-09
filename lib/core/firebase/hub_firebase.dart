import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../firebase_options.dart';
import '../../features/community/data/community_data_source.dart';
import '../../features/community/data/firebase_community_repository.dart';
import '../../features/community/domain/community_repository.dart';

abstract final class HubFirebase {
  static Future<CommunityRepository> connect() async {
    // WORKSHOP STEP: the Wall uses the Hub as its local [DEFAULT] app.
    final app = Firebase.apps.isEmpty
        ? await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          )
        : Firebase.app();

    final auth = FirebaseAuth.instanceFor(app: app);
    if (auth.currentUser == null) {
      await auth.signInAnonymously();
    }

    final firestore = FirebaseFirestore.instanceFor(app: app);
    return FirebaseCommunityRepository(CommunityDataSource(firestore));
  }
}
