import 'package:flutter_test/flutter_test.dart';
import 'package:full_day_community_hub/features/community/domain/community_message.dart';
import 'package:full_day_community_hub/features/community/domain/participant.dart';

void main() {
  test('CommunityMessage uses value equality', () {
    const first = CommunityMessage(
      id: 'message-1',
      authorId: 'community-user',
      authorName: 'Gian',
      authorRole: 'Mobile Architect',
      authorCommunity: 'Flutter Piura',
      text: 'Hola Full Day 🚀',
    );
    const second = CommunityMessage(
      id: 'message-1',
      authorId: 'community-user',
      authorName: 'Gian',
      authorRole: 'Mobile Architect',
      authorCommunity: 'Flutter Piura',
      text: 'Hola Full Day 🚀',
    );

    expect(first, second);
  });

  test('Participant uses value equality', () {
    const first = Participant(
      uid: 'community-user',
      name: 'Gian',
      role: 'Mobile Architect',
      community: 'Flutter Piura',
    );
    const second = Participant(
      uid: 'community-user',
      name: 'Gian',
      role: 'Mobile Architect',
      community: 'Flutter Piura',
    );

    expect(first, second);
  });
}
