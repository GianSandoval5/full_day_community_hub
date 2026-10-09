import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/community_message.dart';
import '../domain/community_repository.dart';
import '../domain/participant.dart';
import 'community_data_source.dart';

class FirebaseCommunityRepository implements CommunityRepository {
  FirebaseCommunityRepository(this._dataSource);

  final CommunityDataSource _dataSource;

  @override
  Stream<List<Participant>> watchParticipants() {
    return _dataSource.watchParticipants().map(
      (documents) => documents.map(_participantFromDocument).toList(),
    );
  }

  @override
  Stream<List<CommunityMessage>> watchMessages({int limit = 50}) {
    return _dataSource
        .watchMessages(limit: limit)
        .map((documents) => documents.map(_messageFromDocument).toList());
  }

  Participant _participantFromDocument(CommunityDocument document) {
    final data = document.data;
    return Participant(
      uid: _string(data['uid'], fallback: document.id),
      name: _string(data['name'], fallback: 'Anonymous node'),
      role: _string(data['role'], fallback: 'Flutter Developer'),
      community: _string(data['community'], fallback: 'Community'),
      joinedAt: _dateTime(data['joinedAt']),
      lastSeenAt: _dateTime(data['lastSeenAt']),
    );
  }

  CommunityMessage _messageFromDocument(CommunityDocument document) {
    final data = document.data;
    return CommunityMessage(
      id: _string(data['id'], fallback: document.id),
      authorId: _string(data['authorId']),
      authorName: _string(data['authorName'], fallback: 'Anonymous node'),
      authorRole: _string(data['authorRole'], fallback: 'Flutter Developer'),
      authorCommunity: _string(data['authorCommunity'], fallback: 'Community'),
      text: _string(data['text']),
      createdAt: _dateTime(data['createdAt']),
    );
  }

  String _string(Object? value, {String fallback = ''}) {
    return value is String && value.trim().isNotEmpty ? value : fallback;
  }

  DateTime? _dateTime(Object? value) {
    return value is Timestamp ? value.toDate() : null;
  }
}
