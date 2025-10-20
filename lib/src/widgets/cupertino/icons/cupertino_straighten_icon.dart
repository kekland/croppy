import 'package:flutter/cupertino.dart';

/// A SFSymbols `circle-and-line-horizontal-fill` icon.
class CupertinoStraightenIcon extends StatelessWidget {
  const CupertinoStraightenIcon({
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
      child: Center(
        child: SizedBox(
          width: size,
          height: size * 0.7284062960242369,
          child: CustomPaint(
            painter: _CupertinoStraightenIconPainter(
              color ?? CupertinoTheme.of(context).primaryContrastingColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _CupertinoStraightenIconPainter extends CustomPainter {
  const _CupertinoStraightenIconPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Path path_1 = Path();
    path_1.moveTo(0, size.height * 0.4997562);
    path_1.cubicTo(
        0,
        size.height * 0.4786881,
        size.width * 0.01249107,
        size.height * 0.4610493,
        size.width * 0.02748035,
        size.height * 0.4610493);
    path_1.lineTo(size.width * 0.9725179, size.height * 0.4610493);
    path_1.cubicTo(size.width * 0.9875088, size.height * 0.4610493, size.width,
        size.height * 0.4786881, size.width, size.height * 0.4997562);
    path_1.cubicTo(
        size.width,
        size.height * 0.5208262,
        size.width * 0.9875088,
        size.height * 0.5389532,
        size.width * 0.9725179,
        size.height * 0.5389532);
    path_1.lineTo(size.width * 0.02748035, size.height * 0.5389532);
    path_1.cubicTo(size.width * 0.01249107, size.height * 0.5389532, 0,
        size.height * 0.5208262, 0, size.height * 0.4997562);
    path_1.close();
    path_1.moveTo(size.width * 0.5003563, size.height * 0.9995133);
    path_1.cubicTo(
        size.width * 0.6991445,
        size.height * 0.9995133,
        size.width * 0.8643804,
        size.height * 0.7726625,
        size.width * 0.8643804,
        size.height * 0.4997562);
    path_1.cubicTo(size.width * 0.8643804, size.height * 0.2263602,
        size.width * 0.6987863, 0, size.width * 0.4999982, 0);
    path_1.cubicTo(
        size.width * 0.3008563,
        0,
        size.width * 0.1363311,
        size.height * 0.2263602,
        size.width * 0.1363311,
        size.height * 0.4997562);
    path_1.cubicTo(
        size.width * 0.1363311,
        size.height * 0.7726625,
        size.width * 0.3012133,
        size.height * 0.9995133,
        size.width * 0.5003563,
        size.height * 0.9995133);
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = color;
    canvas.drawPath(path_1, paint1Fill);
  }

  @override
  bool shouldRepaint(_CupertinoStraightenIconPainter oldDelegate) =>
      oldDelegate.color != color;
}
