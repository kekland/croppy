import 'dart:math';

import 'package:croppy/src/src.dart';
import 'package:flutter/cupertino.dart';

class CupertinoImageTransformationToolbar extends StatelessWidget {
  const CupertinoImageTransformationToolbar({
    super.key,
    required this.controller,
  });

  final CroppableImageController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CupertinoKnob(
          value: controller.rotationZ * 180 / pi,
          extent: 45,
          onChanged: (v) {
            controller.onStraighten(angleRad: v);
          },
          inactiveChild: const _CupertinoStraightenIconWidget(
            color: CupertinoColors.white,
          ),
        ),
        const SizedBox(height: 8.0),
        CupertinoRotationSlider(
          value: controller.rotationZ,
          extent: pi / 4,
          onStart: controller.onStraightenStart,
          onEnd: controller.onStraightenEnd,
          onChanged: (v) {
            controller.onStraighten(angleRad: v);
          },
        ),
      ],
    );
  }
}

class _CupertinoStraightenIconWidget extends StatelessWidget {
  const _CupertinoStraightenIconWidget({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24.0,
      height: 24.0,
      child: CustomPaint(
        painter: _CupertinoStraightenIconPainter(color),
      ),
    );
  }
}

class _CupertinoStraightenIconPainter extends CustomPainter {
  _CupertinoStraightenIconPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final circlePath = Path()
      ..addOval(
        Rect.fromCircle(
          center: size.center(Offset.zero),
          radius: size.width / 2 - 3.0,
        ),
      );

    final linePath = Path()
      ..addRect(
        Rect.fromCenter(
          center: size.center(Offset.zero),
          width: size.width,
          height: 1.0,
        ),
      );

    final path = Path.combine(PathOperation.xor, circlePath, linePath);
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_CupertinoStraightenIconPainter oldDelegate) => true;
}
