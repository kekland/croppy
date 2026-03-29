import 'package:flutter/cupertino.dart';

/// An icon that represents the homography / perspective-correction tool.
/// Draws a skewed quadrilateral (representing a box seen at an angle) with
/// a small inner rectangle (representing the rectified output).
class CupertinoHomographyIcon extends StatelessWidget {
  const CupertinoHomographyIcon({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _HomographyIconPainter(color: color),
      size: const Size(24, 24),
    );
  }
}

class _HomographyIconPainter extends CustomPainter {
  const _HomographyIconPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final outerPaint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    // Skewed outer quadrilateral — the "box seen at an angle".
    final outer = Path()
      ..moveTo(w * 0.22, h * 0.08) // TL
      ..lineTo(w * 0.88, h * 0.18) // TR
      ..lineTo(w * 0.80, h * 0.88) // BR
      ..lineTo(w * 0.08, h * 0.80) // BL
      ..close();
    canvas.drawPath(outer, outerPaint);

    // Small inner rectangle — the "corrected output".
    final innerPaint = Paint()
      ..color = color.withOpacity(0.55)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    canvas.drawRect(
      Rect.fromLTRB(w * 0.32, h * 0.32, w * 0.68, h * 0.68),
      innerPaint,
    );
  }

  @override
  bool shouldRepaint(_HomographyIconPainter old) => old.color != color;
}
