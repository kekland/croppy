//Copy this CustomPainter code to the Bottom of the File
import 'package:flutter/cupertino.dart';

/// A SFSymbols `trapezoid-and-line-horizontal-fill` icon.
class CupertinoPerspectiveYIcon extends StatelessWidget {
  const CupertinoPerspectiveYIcon({
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
          height: size * 0.7310248486644371,
          child: CustomPaint(
            painter: _CupertinoPerspectiveYIconPainter(
              color ?? CupertinoTheme.of(context).primaryContrastingColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _CupertinoPerspectiveYIconPainter extends CustomPainter {
  const _CupertinoPerspectiveYIconPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Path path_1 = Path();
    path_1.moveTo(size.width * 0.2699467, size.height * 0.8814292);
    path_1.lineTo(size.width * 0.7172417, size.height * 0.9883085);
    path_1.cubicTo(
        size.width * 0.7978538,
        size.height * 1.007534,
        size.width * 0.8515938,
        size.height * 0.9487231,
        size.width * 0.8515938,
        size.height * 0.8407146);
    path_1.lineTo(size.width * 0.8515938, size.height * 0.1513683);
    path_1.cubicTo(
        size.width * 0.8515938,
        size.height * 0.04335804,
        size.width * 0.7978538,
        size.height * -0.01601951,
        size.width * 0.7172417,
        size.height * 0.003773004);
    path_1.lineTo(size.width * 0.2699467, size.height * 0.1112178);
    path_1.cubicTo(
        size.width * 0.1905749,
        size.height * 0.1298796,
        size.width * 0.1484088,
        size.height * 0.1881261,
        size.width * 0.1484088,
        size.height * 0.2797371);
    path_1.lineTo(size.width * 0.1484088, size.height * 0.7123458);
    path_1.cubicTo(
        size.width * 0.1484088,
        size.height * 0.8033876,
        size.width * 0.1905749,
        size.height * 0.8622039,
        size.width * 0.2699467,
        size.height * 0.8814292);
    path_1.close();
    path_1.moveTo(size.width * 0.03307158, size.height * 0.5387365);
    path_1.cubicTo(size.width * 0.01240185, size.height * 0.5387365, 0,
        size.height * 0.5223366, 0, size.height * 0.4963240);
    path_1.cubicTo(
        0,
        size.height * 0.4691800,
        size.width * 0.01240185,
        size.height * 0.4533459,
        size.width * 0.03307158,
        size.height * 0.4533459);
    path_1.lineTo(size.width * 0.9669305, size.height * 0.4533459);
    path_1.cubicTo(size.width * 0.9876011, size.height * 0.4533459, size.width,
        size.height * 0.4691800, size.width, size.height * 0.4963240);
    path_1.cubicTo(
        size.width,
        size.height * 0.5223366,
        size.width * 0.9876011,
        size.height * 0.5387365,
        size.width * 0.9669305,
        size.height * 0.5387365);
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = color;
    canvas.drawPath(path_1, paint1Fill);
  }

  @override
  bool shouldRepaint(_CupertinoPerspectiveYIconPainter oldDelegate) =>
      oldDelegate.color != color;
}
