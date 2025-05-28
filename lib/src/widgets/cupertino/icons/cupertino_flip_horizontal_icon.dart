//Copy this CustomPainter code to the Bottom of the File
import 'package:flutter/cupertino.dart';

/// A SFSymbols
/// `arrow-left-and-right-righttriangle-left-righttriangle-right-fill` icon.
class CupertinoFlipHorizontalIcon extends StatelessWidget {
  const CupertinoFlipHorizontalIcon({
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
          height: size * 0.8908227228633697,
          child: CustomPaint(
            painter: _CupertinoFlipHorizontalIconPainter(
              color ?? CupertinoTheme.of(context).primaryContrastingColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _CupertinoFlipHorizontalIconPainter extends CustomPainter {
  const _CupertinoFlipHorizontalIconPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Path path_1 = Path();
    path_1.moveTo(0, size.height * 0.9356252);
    path_1.cubicTo(0, size.height * 0.9704324, size.width * 0.02039081,
        size.height, size.width * 0.06414611, size.height);
    path_1.lineTo(size.width * 0.4018688, size.height);
    path_1.cubicTo(
        size.width * 0.4524214,
        size.height,
        size.width * 0.4753592,
        size.height * 0.9747247,
        size.width * 0.4753592,
        size.height * 0.9179774);
    path_1.lineTo(size.width * 0.4753592, size.height * 0.3481168);
    path_1.cubicTo(
        size.width * 0.4753592,
        size.height * 0.3061518,
        size.width * 0.4473232,
        size.height * 0.2837390,
        size.width * 0.4171618,
        size.height * 0.2837390);
    path_1.cubicTo(
        size.width * 0.3967710,
        size.height * 0.2837390,
        size.width * 0.3772302,
        size.height * 0.2942300,
        size.width * 0.3632113,
        size.height * 0.3161662);
    path_1.lineTo(size.width * 0.01316905, size.height * 0.8865054);
    path_1.cubicTo(size.width * 0.003823275, size.height * 0.9017653, 0,
        size.height * 0.9194082, 0, size.height * 0.9356252);
    path_1.close();
    path_1.moveTo(size.width * 0.5246364, size.height * 0.9179774);
    path_1.cubicTo(
        size.width * 0.5246364,
        size.height * 0.9747247,
        size.width * 0.5475786,
        size.height,
        size.width * 0.5981304,
        size.height);
    path_1.lineTo(size.width * 0.9354280, size.height);
    path_1.cubicTo(size.width * 0.9796070, size.height, size.width,
        size.height * 0.9704324, size.width, size.height * 0.9356252);
    path_1.cubicTo(
        size.width,
        size.height * 0.9194082,
        size.width * 0.9957500,
        size.height * 0.9017653,
        size.width * 0.9864061,
        size.height * 0.8865054);
    path_1.lineTo(size.width * 0.6363628, size.height * 0.3161662);
    path_1.cubicTo(
        size.width * 0.6227690,
        size.height * 0.2942300,
        size.width * 0.6028023,
        size.height * 0.2837390,
        size.width * 0.5824137,
        size.height * 0.2837390);
    path_1.cubicTo(
        size.width * 0.5522505,
        size.height * 0.2837390,
        size.width * 0.5246364,
        size.height * 0.3061518,
        size.width * 0.5246364,
        size.height * 0.3481168);
    path_1.close();
    path_1.moveTo(size.width * 0.06584523, size.height * 0.1669053);
    path_1.lineTo(size.width * 0.1796940, size.height * 0.2618029);
    path_1.cubicTo(
        size.width * 0.2030585,
        size.height * 0.2818312,
        size.width * 0.2310958,
        size.height * 0.2699094,
        size.width * 0.2310958,
        size.height * 0.2370056);
    path_1.lineTo(size.width * 0.2310958, size.height * 0.1688127);
    path_1.lineTo(size.width * 0.7684779, size.height * 0.1688127);
    path_1.lineTo(size.width * 0.7684779, size.height * 0.2370056);
    path_1.cubicTo(
        size.width * 0.7684779,
        size.height * 0.2699094,
        size.width * 0.7969402,
        size.height * 0.2818312,
        size.width * 0.8203042,
        size.height * 0.2618029);
    path_1.lineTo(size.width * 0.9341535, size.height * 0.1669053);
    path_1.cubicTo(
        size.width * 0.9498702,
        size.height * 0.1535528,
        size.width * 0.9494482,
        size.height * 0.1292321,
        size.width * 0.9341535,
        size.height * 0.1163567);
    path_1.lineTo(size.width * 0.8203042, size.height * 0.02098240);
    path_1.cubicTo(
        size.width * 0.7977884,
        size.height * 0.001907488,
        size.width * 0.7684779,
        size.height * 0.01192182,
        size.width * 0.7684779,
        size.height * 0.04625661);
    path_1.lineTo(size.width * 0.7684779, size.height * 0.1134956);
    path_1.lineTo(size.width * 0.2310958, size.height * 0.1134956);
    path_1.lineTo(size.width * 0.2310958, size.height * 0.04625661);
    path_1.cubicTo(
        size.width * 0.2310958,
        size.height * 0.01287555,
        size.width * 0.2030585,
        size.height * 0.0009537417,
        size.width * 0.1796940,
        size.height * 0.02098240);
    path_1.lineTo(size.width * 0.06584523, size.height * 0.1163567);
    path_1.cubicTo(
        size.width * 0.05012724,
        size.height * 0.1292321,
        size.width * 0.05055224,
        size.height * 0.1540298,
        size.width * 0.06584523,
        size.height * 0.1669053);
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = color;
    canvas.drawPath(path_1, paint1Fill);
  }

  @override
  bool shouldRepaint(_CupertinoFlipHorizontalIconPainter oldDelegate) =>
      oldDelegate.color != color;
}
