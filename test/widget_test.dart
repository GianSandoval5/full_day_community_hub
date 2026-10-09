import 'package:flutter_test/flutter_test.dart';
import 'package:full_day_community_hub/app/app.dart';
import 'package:full_day_community_hub/features/community/domain/community_message.dart';
import 'package:full_day_community_hub/features/community/domain/community_repository.dart';
import 'package:full_day_community_hub/features/community/domain/participant.dart';

void main() {
  testWidgets('renders the live Community Wall', (tester) async {
    await tester.pumpWidget(CommunityHubApp(repository: _FakeRepository()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('FULL DAY COMMUNITY HUB'), findsOneWidget);
    expect(find.text('LIVE'), findsOneWidget);
    expect(find.text('The network is ready.'), findsOneWidget);
  });
}

class _FakeRepository implements CommunityRepository {
  @override
  Stream<List<CommunityMessage>> watchMessages({int limit = 50}) {
    return Stream.value(const []);
  }

  @override
  Stream<List<Participant>> watchParticipants() {
    return Stream.value(const []);
  }
}
