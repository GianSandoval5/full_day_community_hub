import 'package:flutter/material.dart';

import '../../../../app/theme/hub_theme.dart';

class ParticipantCounter extends StatelessWidget {
  const ParticipantCounter({required this.count, super.key});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'NETWORK SIZE',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: HubColors.cyan,
                letterSpacing: 1.7,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            TweenAnimationBuilder<double>(
              tween: Tween(end: count.toDouble()),
              duration: const Duration(milliseconds: 500),
              builder: (context, value, _) => Text(
                value.round().toString().padLeft(2, '0'),
                style: Theme.of(context).textTheme.displayLarge
                    ?.copyWith(color: Colors.white, fontSize: 64),
              ),
            ),
            Text(
              count == 1 ? 'registered node' : 'registered nodes',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(color: Colors.white60),
            ),
          ],
        ),
      ),
    );
  }
}
