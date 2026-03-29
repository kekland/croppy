import 'package:flutter/cupertino.dart';

/// A double-headed vertical arrow icon representing vertical stretch.
class CupertinoStretchYIcon extends StatelessWidget {
  const CupertinoStretchYIcon({
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
        painter: _CupertinoStretchYIconPainter(
          color ?? CupertinoColors.white,
        ),
      ),
    );
  }
}

class _CupertinoStretchYIconPainter extends CustomPainter {
  const _CupertinoStretchYIconPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Double-headed vertical arrow (↕), filled as a single shape.
    final path = Path()
      ..moveTo(w * 0.50, h * 0.04) // top tip
      ..lineTo(w * 0.70, h * 0.22) // upper-right arrowhead
      ..lineTo(w * 0.58, h * 0.22) // inner right-upper
      ..lineTo(w * 0.58, h * 0.78) // inner right-lower
      ..lineTo(w * 0.70, h * 0.78) // lower-right arrowhead
      ..lineTo(w * 0.50, h * 0.96) // bottom tip
      ..lineTo(w * 0.30, h * 0.78) // lower-left arrowhead
      ..lineTo(w * 0.42, h * 0.78) // inner left-lower
      ..lineTo(w * 0.42, h * 0.22) // inner left-upper
      ..lineTo(w * 0.30, h * 0.22) // upper-left arrowhead
      ..close();

    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_CupertinoStretchYIconPainter old) =>
      old.color != color;
}
