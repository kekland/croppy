import 'package:croppy/src/src.dart';
import 'package:flutter/material.dart';

class MaterialImageCropperHandles extends StatelessWidget {
  const MaterialImageCropperHandles({
    super.key,
    required this.controller,
    required this.gesturePadding,
  });

  final CroppableImageController controller;
  final double gesturePadding;

  @override
  Widget build(BuildContext context) {
    final cropShape = controller.data.cropShape;

    return CroppableImageGestureDetector(
      controller: controller,
      gesturePadding: gesturePadding,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          ListenableBuilder(
            listenable: controller.isTransformingNotifier,
            builder: (context, child) => AnimatedOpacity(
              opacity: controller.isTransformingNotifier.value ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
              child: child,
            ),
            child: CustomPaint(
              painter: _MaterialImageCropperGuidesPainter(cropShape),
            ),
          ),
          ListenableBuilder(
            listenable: controller.isTransformingNotifier,
            builder: (context, child) => AnimatedOpacity(
              opacity: controller.isTransformingNotifier.value &&
                      controller.isRotatingZ
                  ? 1.0
                  : 0.0,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
              child: child,
            ),
            child: ClipPath(
              clipper: CropShapeClipper(cropShape),
              child: CustomPaint(
                painter: _MaterialImageCropperFineGuidesPainter(),
              ),
            ),
          ),
          if (cropShape.type == CropShapeType.aabb)
            CustomPaint(
              painter: _MaterialImageCropperCornersPainter(cropShape),
            ),
        ],
      ),
    );
  }
}

class _MaterialImageCropperCornersPainter extends CustomPainter {
  _MaterialImageCropperCornersPainter(this.cropShape);
  final CropShape cropShape;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    final path = cropShape.getTransformedPathForSize(size);

    for (final point in path.toApproximatePolygon().vertices) {
      canvas.drawCircle(point.offset, 4.0, paint);
    }
  }

  @override
  bool shouldRepaint(_MaterialImageCropperCornersPainter oldDelegate) =>
      oldDelegate.cropShape != cropShape;
}

class _MaterialImageCropperGuidesPainter extends CustomPainter {
  _MaterialImageCropperGuidesPainter(this.cropShape);
  final CropShape cropShape;

  @override
  void paint(Canvas canvas, Size size) {
    final framePaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final guidePaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final path = cropShape.getTransformedPathForSize(size);

    canvas.drawPath(path.toUiPath(), framePaint);
    canvas.clipPath(cropShape.getTransformedPathForSize(size).toUiPath());

    canvas.drawLine(
      Offset(size.width / 3, 0.0),
      Offset(size.width / 3, size.height),
      guidePaint,
    );

    canvas.drawLine(
      Offset(size.width * 2 / 3, 0.0),
      Offset(size.width * 2 / 3, size.height),
      guidePaint,
    );

    canvas.drawLine(
      Offset(0.0, size.height / 3),
      Offset(size.width, size.height / 3),
      guidePaint,
    );

    canvas.drawLine(
      Offset(0.0, size.height * 2 / 3),
      Offset(size.width, size.height * 2 / 3),
      guidePaint,
    );
  }

  @override
  bool shouldRepaint(_MaterialImageCropperGuidesPainter oldDelegate) => false;
}

class _MaterialImageCropperFineGuidesPainter extends CustomPainter {
  _MaterialImageCropperFineGuidesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final guidePaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(size.width / 9, 0.0),
      Offset(size.width / 9, size.height),
      guidePaint,
    );

    canvas.drawLine(
      Offset(size.width * 2 / 9, 0.0),
      Offset(size.width * 2 / 9, size.height),
      guidePaint,
    );

    canvas.drawLine(
      Offset(size.width * 4 / 9, 0.0),
      Offset(size.width * 4 / 9, size.height),
      guidePaint,
    );

    canvas.drawLine(
      Offset(size.width * 5 / 9, 0.0),
      Offset(size.width * 5 / 9, size.height),
      guidePaint,
    );

    canvas.drawLine(
      Offset(size.width * 7 / 9, 0.0),
      Offset(size.width * 7 / 9, size.height),
      guidePaint,
    );

    canvas.drawLine(
      Offset(size.width * 8 / 9, 0.0),
      Offset(size.width * 8 / 9, size.height),
      guidePaint,
    );

    canvas.drawLine(
      Offset(0.0, size.height / 9),
      Offset(size.width, size.height / 9),
      guidePaint,
    );

    canvas.drawLine(
      Offset(0.0, size.height * 2 / 9),
      Offset(size.width, size.height * 2 / 9),
      guidePaint,
    );

    canvas.drawLine(
      Offset(0.0, size.height * 4 / 9),
      Offset(size.width, size.height * 4 / 9),
      guidePaint,
    );

    canvas.drawLine(
      Offset(0.0, size.height * 5 / 9),
      Offset(size.width, size.height * 5 / 9),
      guidePaint,
    );

    canvas.drawLine(
      Offset(0.0, size.height * 7 / 9),
      Offset(size.width, size.height * 7 / 9),
      guidePaint,
    );

    canvas.drawLine(
      Offset(0.0, size.height * 8 / 9),
      Offset(size.width, size.height * 8 / 9),
      guidePaint,
    );
  }

  @override
  bool shouldRepaint(_MaterialImageCropperFineGuidesPainter oldDelegate) =>
      false;
}
