import 'dart:math' as math;

import 'package:flutter/material.dart';

const _qrHeroTag = 'community-hub-qr';

class QrPlaceholder extends StatelessWidget {
  const QrPlaceholder({this.url, super.key});

  final String? url;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Semantics(
        button: true,
        label: 'Ampliar codigo QR',
        child: InkWell(
          key: const Key('qr-card'),
          mouseCursor: SystemMouseCursors.click,
          onTap: () => _showExpandedQr(context),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Hero(
                  tag: _qrHeroTag,
                  child: _QrMark(size: 72, iconSize: 42),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'JOIN THE NETWORK',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        url ?? 'QR ready for the workshop URL',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: Colors.white54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showExpandedQr(BuildContext context) {
    Navigator.of(context).push<void>(
      PageRouteBuilder<void>(
        opaque: false,
        barrierColor: Colors.black87,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context)
            .modalBarrierDismissLabel,
        transitionDuration: const Duration(milliseconds: 420),
        reverseTransitionDuration: const Duration(milliseconds: 320),
        pageBuilder: (context, animation, secondaryAnimation) {
          return _ExpandedQr(url: url);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
              reverseCurve: Curves.easeIn,
            ),
            child: child,
          );
        },
      ),
    );
  }
}

class _ExpandedQr extends StatelessWidget {
  const _ExpandedQr({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            child: const SizedBox.expand(),
          ),
          Center(
            child: GestureDetector(
              onTap: () {},
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final size = math.min(
                    420.0,
                    math.min(
                      constraints.maxWidth * 0.72,
                      constraints.maxHeight * 0.66,
                    ),
                  );

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Hero(
                        tag: _qrHeroTag,
                        createRectTween: (begin, end) =>
                            MaterialRectCenterArcTween(begin: begin, end: end),
                        child: _QrMark(
                          key: const Key('qr-expanded'),
                          size: size,
                          iconSize: size * 0.68,
                          expanded: true,
                        ),
                      ),
                      if (url != null) ...[
                        const SizedBox(height: 24),
                        Text(
                          url!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: SafeArea(
              minimum: const EdgeInsets.all(20),
              child: IconButton.filled(
                key: const Key('qr-close-button'),
                tooltip: 'Cerrar',
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QrMark extends StatelessWidget {
  const _QrMark({
    required this.size,
    required this.iconSize,
    this.expanded = false,
    super.key,
  });

  final double size;
  final double iconSize;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: expanded ? Colors.white : Colors.transparent,
      borderRadius: BorderRadius.circular(expanded ? 28 : 14),
      clipBehavior: Clip.antiAlias,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(expanded ? 28 : 14),
          border: Border.all(color: expanded ? Colors.white : Colors.white24),
          boxShadow: expanded
              ? const [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 40,
                    spreadRadius: 8,
                  ),
                ]
              : null,
        ),
        child: Icon(
          Icons.qr_code_2_rounded,
          size: iconSize,
          color: expanded ? const Color(0xFF06111F) : null,
        ),
      ),
    );
  }
}
