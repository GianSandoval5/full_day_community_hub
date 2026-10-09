import 'package:flutter/material.dart';

import '../../../app/theme/hub_theme.dart';
import '../domain/community_message.dart';
import '../domain/community_repository.dart';
import 'widgets/empty_wall_state.dart';
import 'widgets/live_indicator.dart';
import 'widgets/participant_counter.dart';
import 'widgets/qr_placeholder.dart';
import 'widgets/wall_message_card.dart';

class CommunityWallScreen extends StatelessWidget {
  const CommunityWallScreen({required this.repository, super.key});

  final CommunityRepository repository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topRight,
            radius: 1.2,
            colors: [Color(0xFF123554), HubColors.background],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 960;
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: wide ? 42 : 18,
                  vertical: wide ? 28 : 18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _WallHeader(),
                    SizedBox(height: wide ? 28 : 18),
                    Expanded(
                      child: wide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  width: 330,
                                  child: _Sidebar(repository: repository),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: _Messages(repository: repository),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                SizedBox(
                                  height: 160,
                                  child: _CompactCounter(
                                    repository: repository,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Expanded(
                                  child: _Messages(repository: repository),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _WallHeader extends StatelessWidget {
  const _WallHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [HubColors.flutterBlue, HubColors.cyan],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.hub_rounded, color: Colors.white),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FULL DAY COMMUNITY HUB',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                'Flutter + Firebase  ·  Build your node · Join the network',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: Colors.white54),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        const LiveIndicator(),
      ],
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.repository});

  final CommunityRepository repository;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StreamBuilder(
          stream: repository.watchParticipants(),
          builder: (context, snapshot) {
            return ParticipantCounter(count: snapshot.data?.length ?? 0);
          },
        ),
        const SizedBox(height: 16),
        const QrPlaceholder(),
        const Spacer(),
        Text(
          'BUILD · CONNECT · SHIP',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: HubColors.firebaseAmber,
            letterSpacing: 2.1,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _CompactCounter extends StatelessWidget {
  const _CompactCounter({required this.repository});

  final CommunityRepository repository;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: repository.watchParticipants(),
      builder: (context, snapshot) {
        final count = snapshot.data?.length ?? 0;
        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            child: Row(
              children: [
                Text(
                  count.toString().padLeft(2, '0'),
                  style: Theme.of(context).textTheme.displayLarge
                      ?.copyWith(fontSize: 50),
                ),
                const SizedBox(width: 14),
                const Expanded(child: Text('REGISTERED\nNODES')),
                const Icon(Icons.hub_outlined, color: HubColors.cyan, size: 38),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Messages extends StatelessWidget {
  const _Messages({required this.repository});

  final CommunityRepository repository;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CommunityMessage>>(
      stream: repository.watchMessages(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _WallError(message: snapshot.error.toString());
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final messages = snapshot.data!;
        if (messages.isEmpty) return const EmptyWallState();

        return ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return TweenAnimationBuilder<double>(
              key: ValueKey(messages[index].id),
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 420),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) => Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 18 * (1 - value)),
                  child: child,
                ),
              ),
              child: WallMessageCard(message: messages[index]),
            );
          },
        );
      },
    );
  }
}

class _WallError extends StatelessWidget {
  const _WallError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_rounded, size: 44),
              const SizedBox(height: 12),
              Text(
                'Could not read the Community Hub',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
