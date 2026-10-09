import 'package:flutter/material.dart' show Key, Size;
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

  testWidgets('expands and closes the QR with a Hero transition', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(CommunityHubApp(repository: _FakeRepository()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    await tester.tap(find.byKey(const Key('qr-card')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));

    expect(find.byKey(const Key('qr-expanded')), findsOneWidget);
    expect(find.byKey(const Key('qr-close-button')), findsOneWidget);

    await tester.tap(find.byKey(const Key('qr-close-button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.byKey(const Key('qr-expanded')), findsNothing);
    expect(find.byKey(const Key('qr-card')), findsOneWidget);
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
