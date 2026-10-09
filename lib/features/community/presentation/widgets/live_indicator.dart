import 'package:flutter/material.dart';

import '../../../../app/theme/hub_theme.dart';

class LiveIndicator extends StatefulWidget {
  const LiveIndicator({super.key});

  @override
  State<LiveIndicator> createState() => _LiveIndicatorState();
}

class _LiveIndicatorState extends State<LiveIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: HubColors.live.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: HubColors.live.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeTransition(
            opacity: Tween<double>(begin: 0.35, end: 1).animate(_controller),
            child: const DecoratedBox(
              decoration: BoxDecoration(
                color: HubColors.live,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: HubColors.live, blurRadius: 10)],
              ),
              child: SizedBox.square(dimension: 8),
            ),
          ),
          const SizedBox(width: 9),
          Text(
            'LIVE',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: HubColors.live,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
