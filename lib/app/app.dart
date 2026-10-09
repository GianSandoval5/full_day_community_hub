import 'package:flutter/material.dart';

import '../core/firebase/hub_firebase.dart';
import '../features/community/domain/community_repository.dart';
import '../features/community/presentation/community_wall_screen.dart';
import 'theme/hub_theme.dart';

class CommunityHubApp extends StatefulWidget {
  const CommunityHubApp({super.key, this.repository});

  final CommunityRepository? repository;

  @override
  State<CommunityHubApp> createState() => _CommunityHubAppState();
}

class _CommunityHubAppState extends State<CommunityHubApp> {
  late final Future<CommunityRepository> _repository = widget.repository == null
      ? HubFirebase.connect()
      : Future.value(widget.repository);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Full Day Community Hub',
      debugShowCheckedModeBanner: false,
      theme: HubTheme.dark(),
      home: FutureBuilder<CommunityRepository>(
        future: _repository,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _BootstrapError(error: snapshot.error.toString());
          }
          if (!snapshot.hasData) return const _HubSplash();
          return CommunityWallScreen(repository: snapshot.data!);
        },
      ),
    );
  }
}

class _HubSplash extends StatelessWidget {
  const _HubSplash();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.hub_rounded, size: 72, color: HubColors.cyan),
            SizedBox(height: 24),
            Text(
              'FULL DAY COMMUNITY HUB',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 10),
            Text('Connecting communities...'),
            SizedBox(height: 28),
            SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ),
      ),
    );
  }
}

class _BootstrapError extends StatelessWidget {
  const _BootstrapError({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.settings_suggest_outlined, size: 52),
                    const SizedBox(height: 18),
                    Text(
                      'Community Hub setup required',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Enable Anonymous Authentication and create Cloud Firestore in the Hub Firebase project.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      error,
                      textAlign: TextAlign.center,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
