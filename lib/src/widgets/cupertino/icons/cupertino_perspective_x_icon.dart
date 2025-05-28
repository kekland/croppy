//Copy this CustomPainter code to the Bottom of the File
import 'package:flutter/cupertino.dart';

/// A SFSymbols `trapezoid-and-line-vertical-fill` icon.
class CupertinoPerspectiveXIcon extends StatelessWidget {
  const CupertinoPerspectiveXIcon({
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
          width: size / 1.1755088137613896,
          height: size,
          child: CustomPaint(
            painter: _CupertinoPerspectiveXIconPainter(
              color ?? CupertinoTheme.of(context).primaryContrastingColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _CupertinoPerspectiveXIconPainter extends CustomPainter {
  const _CupertinoPerspectiveXIconPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Path path_1 = Path();
    path_1.moveTo(size.width * 0.1086550, size.height * 0.8347879);
    path_1.lineTo(size.width * 0.8908586, size.height * 0.8347879);
    path_1.cubicTo(
        size.width * 0.9715726,
        size.height * 0.8347879,
        size.width * 1.013645,
        size.height * 0.7935892,
        size.width * 0.9960327,
        size.height * 0.7311691);
    path_1.lineTo(size.width * 0.8575973, size.height * 0.2534334);
    path_1.cubicTo(
        size.width * 0.8399848,
        size.height * 0.1922597,
        size.width * 0.7944908,
        size.height * 0.1606325,
        size.width * 0.7240459,
        size.height * 0.1606325);
    path_1.lineTo(size.width * 0.2759556, size.height * 0.1606325);
    path_1.cubicTo(
        size.width * 0.2050238,
        size.height * 0.1606325,
        size.width * 0.1595298,
        size.height * 0.1922597,
        size.width * 0.1419193,
        size.height * 0.2534334);
    path_1.lineTo(size.width * 0.003969479, size.height * 0.7311691);
    path_1.cubicTo(
        size.width * -0.01364112,
        size.height * 0.7935892,
        size.width * 0.02842865,
        size.height * 0.8347879,
        size.width * 0.1086550,
        size.height * 0.8347879);
    path_1.close();
    path_1.moveTo(size.width * 0.5004909, size.height * 0.9954233);
    path_1.cubicTo(
        size.width * 0.4774995,
        size.height * 0.9954233,
        size.width * 0.4633128,
        size.height * 0.9825200,
        size.width * 0.4633128,
        size.height * 0.9621295);
    path_1.lineTo(size.width * 0.4633128, size.height * 0.03329171);
    path_1.cubicTo(size.width * 0.4633128, size.height * 0.01248440,
        size.width * 0.4774995, 0, size.width * 0.5004909, 0);
    path_1.cubicTo(
        size.width * 0.5229949,
        0,
        size.width * 0.5371811,
        size.height * 0.01248440,
        size.width * 0.5371811,
        size.height * 0.03329171);
    path_1.lineTo(size.width * 0.5371811, size.height * 0.9621295);
    path_1.cubicTo(
        size.width * 0.5371811,
        size.height * 0.9825200,
        size.width * 0.5229949,
        size.height * 0.9954233,
        size.width * 0.5004909,
        size.height * 0.9954233);
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = color;
    canvas.drawPath(path_1, paint1Fill);
  }

  @override
  bool shouldRepaint(_CupertinoPerspectiveXIconPainter oldDelegate) =>
      oldDelegate.color != color;
}
