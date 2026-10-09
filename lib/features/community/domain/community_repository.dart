import 'community_message.dart';
import 'participant.dart';

abstract interface class CommunityRepository {
  Stream<List<Participant>> watchParticipants();

  Stream<List<CommunityMessage>> watchMessages({int limit = 50});
}
