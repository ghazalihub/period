import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class DashedCircle extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color? strokeColor;
  final double dashLength;
  final int dashCount;

  const DashedCircle({
    super.key,
    required this.size,
    this.strokeWidth = 3,
    this.strokeColor,
    this.dashLength = 3,
    this.dashCount = 120,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final finalStrokeColor = strokeColor ?? colors.predictionCircleOuter;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _DashedCirclePainter(
          strokeWidth: strokeWidth,
          strokeColor: finalStrokeColor,
          dashLength: dashLength,
          dashCount: dashCount,
        ),
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  final double strokeWidth;
  final Color strokeColor;
  final double dashLength;
  final int dashCount;

  _DashedCirclePainter({
    required this.strokeWidth,
    required this.strokeColor,
    required this.dashLength,
    required this.dashCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - dashLength - 10;
    final paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < dashCount; i++) {
      final angle = (i * 360) / dashCount;
      final radian = (angle * pi) / 180;

      final startX = center.dx + cos(radian) * radius;
      final startY = center.dy + sin(radian) * radius;
      final endX = center.dx + cos(radian) * (radius + dashLength);
      final endY = center.dy + sin(radian) * (radius + dashLength);

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
