import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityDataSource {
  CommunityDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Stream<List<CommunityDocument>> watchParticipants() {
    return _firestore
        .collection('participants')
        .orderBy('joinedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (document) =>
                    CommunityDocument(id: document.id, data: document.data()),
              )
              .toList(growable: false),
        );
  }

  Stream<List<CommunityDocument>> watchMessages({required int limit}) {
    return _firestore
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (document) =>
                    CommunityDocument(id: document.id, data: document.data()),
              )
              .toList(growable: false),
        );
  }
}

class CommunityDocument {
  const CommunityDocument({required this.id, required this.data});

  final String id;
  final Map<String, dynamic> data;
}
