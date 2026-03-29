import 'package:flutter/cupertino.dart';

/// A double-headed horizontal arrow icon representing horizontal stretch.
class CupertinoStretchXIcon extends StatelessWidget {
  const CupertinoStretchXIcon({
    super.key,
    this.color,
    this.size = 22.0,
  });

  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _CupertinoStretchXIconPainter(
          color ?? CupertinoColors.white,
        ),
      ),
    );
  }
}

class _CupertinoStretchXIconPainter extends CustomPainter {
  const _CupertinoStretchXIconPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Double-headed horizontal arrow (←→), filled as a single shape.
    final path = Path()
      ..moveTo(w * 0.04, h * 0.50) // left tip
      ..lineTo(w * 0.22, h * 0.30) // upper-left arrowhead
      ..lineTo(w * 0.22, h * 0.42) // inner upper-left
      ..lineTo(w * 0.78, h * 0.42) // inner upper-right
      ..lineTo(w * 0.78, h * 0.30) // upper-right arrowhead
      ..lineTo(w * 0.96, h * 0.50) // right tip
      ..lineTo(w * 0.78, h * 0.70) // lower-right arrowhead
      ..lineTo(w * 0.78, h * 0.58) // inner lower-right
      ..lineTo(w * 0.22, h * 0.58) // inner lower-left
      ..lineTo(w * 0.22, h * 0.70) // lower-left arrowhead
      ..close();

    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_CupertinoStretchXIconPainter old) =>
      old.color != color;
}
