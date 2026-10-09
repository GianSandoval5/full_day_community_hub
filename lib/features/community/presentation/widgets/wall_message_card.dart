import 'package:flutter/material.dart';

import '../../domain/community_message.dart';

class WallMessageCard extends StatelessWidget {
  const WallMessageCard({required this.message, super.key});

  final CommunityMessage message;

  @override
  Widget build(BuildContext context) {
    final meta = [
      message.authorRole,
      message.authorCommunity,
    ].where((value) => value.isNotEmpty).join(' · ');

    return Card(
      key: ValueKey(message.id),
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              child: Text(
                _initials(message.authorName),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          message.authorName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Text(
                        _relativeTime(message.createdAt),
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: Colors.white38),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    meta,
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: Colors.white54),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message.text,
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(height: 1.35),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.isEmpty || words.first.isEmpty) return '?';
    return words.take(2).map((word) => word[0].toUpperCase()).join();
  }

  String _relativeTime(DateTime? createdAt) {
    if (createdAt == null) return 'now';
    final elapsed = DateTime.now().difference(createdAt);
    if (elapsed.inMinutes < 1) return 'now';
    if (elapsed.inHours < 1) return '${elapsed.inMinutes}m';
    if (elapsed.inDays < 1) return '${elapsed.inHours}h';
    return '${elapsed.inDays}d';
  }
}
