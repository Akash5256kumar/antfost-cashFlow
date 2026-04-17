import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

class DecorativeRings extends StatelessWidget {
  final Color color;
  final double size;

  const DecorativeRings({required this.color, required this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(size: Size(size, size), painter: _RingsPainter(color)),
    );
  }
}

class _RingsPainter extends CustomPainter {
  final Color color;
  static const List<double> _ringRatios = [0.15, 0.35, 0.50];

  const _RingsPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppSpacing.ringStroke;

    for (final ratio in _ringRatios) {
      canvas.drawCircle(center, size.width * ratio, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
