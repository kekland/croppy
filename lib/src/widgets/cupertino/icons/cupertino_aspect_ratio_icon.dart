//Copy this CustomPainter code to the Bottom of the File
import 'package:flutter/cupertino.dart';

/// A SFSymbols `aspectratio-fill` icon.
class CupertinoAspectRatioIcon extends StatelessWidget {
  const CupertinoAspectRatioIcon({
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
          height: size * 0.7815940210098449,
          child: CustomPaint(
            painter: _CupertinoAspectRatioIconPainter(
              color ?? CupertinoTheme.of(context).primaryContrastingColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _CupertinoAspectRatioIconPainter extends CustomPainter {
  const _CupertinoAspectRatioIconPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Path path_1 = Path();
    path_1.moveTo(0, size.height * 0.3825297);
    path_1.lineTo(0, size.height * 0.3049383);
    path_1.lineTo(size.width * 0.6569159, size.height * 0.3049383);
    path_1.cubicTo(
        size.width * 0.7260426,
        size.height * 0.3049383,
        size.width * 0.7625123,
        size.height * 0.3510590,
        size.width * 0.7625123,
        size.height * 0.4378742);
    path_1.lineTo(size.width * 0.7625123, size.height);
    path_1.lineTo(size.width * 0.7018669, size.height);
    path_1.lineTo(size.width * 0.7018669, size.height * 0.4465557);
    path_1.cubicTo(
        size.width * 0.7018669,
        size.height * 0.4064035,
        size.width * 0.6836320,
        size.height * 0.3825297,
        size.width * 0.6526731,
        size.height * 0.3825297);
    path_1.lineTo(size.width * 0.5203563, size.height * 0.3825297);
    path_1.lineTo(size.width * 0.5203563, size.height);
    path_1.lineTo(size.width * 0.4597109, size.height);
    path_1.lineTo(size.width * 0.4597109, size.height * 0.3825297);
    path_1.close();
    path_1.moveTo(size.width * 0.1331641, size.height * 0.9994611);
    path_1.lineTo(size.width * 0.8668363, size.height * 0.9994611);
    path_1.cubicTo(size.width * 0.9558958, size.height * 0.9994611, size.width,
        size.height * 0.9435715, size.width, size.height * 0.8317980);
    path_1.lineTo(size.width, size.height * 0.1687471);
    path_1.cubicTo(
        size.width,
        size.height * 0.05697244,
        size.width * 0.9558958,
        size.height * 0.0005425947,
        size.width * 0.8668363,
        size.height * 0.0005425947);
    path_1.lineTo(size.width * 0.1331641, size.height * 0.0005425947);
    path_1.cubicTo(size.width * 0.04452932, size.height * 0.0005425947, 0,
        size.height * 0.05697244, 0, size.height * 0.1687471);
    path_1.lineTo(0, size.height * 0.8317980);
    path_1.cubicTo(
        0,
        size.height * 0.9435715,
        size.width * 0.04452932,
        size.height * 0.9994611,
        size.width * 0.1331641,
        size.height * 0.9994611);
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = color;
    canvas.drawPath(path_1, paint1Fill);
  }

  @override
  bool shouldRepaint(_CupertinoAspectRatioIconPainter oldDelegate) =>
      oldDelegate.color != color;
}
