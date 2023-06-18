import 'package:croppy/src/src.dart';
import 'package:flutter/cupertino.dart';

class CupertinoImageCropHandles extends StatelessWidget {
  const CupertinoImageCropHandles({
    super.key,
    required this.controller,
    required this.gesturePadding,
    this.handleColor = CupertinoColors.white,
    this.guideColor = CupertinoColors.white,
    this.fineGuideColor = const Color.fromRGBO(255, 255, 255, 0.3),
  });

  final CroppableImageController controller;
  final double gesturePadding;

  final Color handleColor;
  final Color guideColor;
  final Color fineGuideColor;

  Widget _buildHandles(BuildContext context, bool areGuideLinesVisible) {
    final fineGuidesChild = AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      opacity: controller.isRotating && areGuideLinesVisible ? 1.0 : 0.0,
      child: CustomPaint(
        painter: _CupertinoImageCropperFineGuidesPainter(color: fineGuideColor),
      ),
    );

    final guidesChild = AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      opacity: areGuideLinesVisible ? 1.0 : 0.0,
      child: CustomPaint(
        painter: _CupertinoImageCropperGuidesPainter(guideColor),
      ),
    );

    final cropShape = controller.data.cropShape;

    Widget child = Stack(
      fit: StackFit.passthrough,
      children: [
        CustomPaint(
          painter: cropShape.type == CropShapeType.aabb
              ? _CupertinoImageRectCropHandlesPainter(
                  handleColor,
                )
              : _CupertinoImageCustomCropHandlesPainter(
                  cropShape: cropShape,
                  color: handleColor,
                ),
        ),
        ClipPath(
          clipper: CropShapeClipper(cropShape),
          child: guidesChild,
        ),
        ClipPath(
          clipper: CropShapeClipper(cropShape),
          child: fineGuidesChild,
        )
      ],
    );

    return CroppableImageGestureDetector(
      controller: controller,
      gesturePadding: gesturePadding,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (controller is CupertinoCroppableImageController) {
      return ValueListenableBuilder(
        valueListenable: (controller as CupertinoCroppableImageController)
            .guideLinesVisibility,
        builder: (conetxt, isVisible, child) =>
            _buildHandles(context, isVisible),
      );
    }

    return _buildHandles(context, true);
  }
}

class _CupertinoImageRectCropHandlesPainter extends CustomPainter {
  const _CupertinoImageRectCropHandlesPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rectPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw the rectangle
    canvas.drawRect(Offset.zero & size, rectPaint);

    const handleThickness = 2.0;
    final handlePaint = Paint()
      ..color = color
      ..strokeWidth = handleThickness
      ..style = PaintingStyle.stroke;

    // Draw the edge handles
    canvas.drawLine(
      Offset(-handleThickness / 2, size.height / 2 - 15.0),
      Offset(-handleThickness / 2, size.height / 2 + 15.0),
      handlePaint,
    );

    canvas.drawLine(
      Offset(size.width + handleThickness / 2, size.height / 2 - 15.0),
      Offset(size.width + handleThickness / 2, size.height / 2 + 15.0),
      handlePaint,
    );

    canvas.drawLine(
      Offset(size.width / 2 - 15.0, -handleThickness / 2),
      Offset(size.width / 2 + 15.0, -handleThickness / 2),
      handlePaint,
    );

    canvas.drawLine(
      Offset(size.width / 2 - 15.0, size.height + handleThickness / 2),
      Offset(size.width / 2 + 15.0, size.height + handleThickness / 2),
      handlePaint,
    );

    // Draw the corner handles
    final path = Path();
    path.moveTo(-handleThickness / 2, 15.0);
    path.lineTo(-handleThickness / 2, -handleThickness / 2);
    path.lineTo(15.0, -handleThickness / 2);

    path.moveTo(size.width + handleThickness / 2, 15.0);
    path.lineTo(size.width + handleThickness / 2, -handleThickness / 2);
    path.lineTo(size.width - 15.0, -handleThickness / 2);

    path.moveTo(-handleThickness / 2, size.height - 15.0);
    path.lineTo(-handleThickness / 2, size.height + handleThickness / 2);
    path.lineTo(15.0, size.height + handleThickness / 2);

    path.moveTo(size.width + handleThickness / 2, size.height - 15.0);
    path.lineTo(
        size.width + handleThickness / 2, size.height + handleThickness / 2);
    path.lineTo(size.width - 15.0, size.height + handleThickness / 2);

    canvas.drawPath(path, handlePaint);
  }

  @override
  bool shouldRepaint(_CupertinoImageRectCropHandlesPainter oldDelegate) =>
      false;
}

class _CupertinoImageCustomCropHandlesPainter extends CustomPainter {
  _CupertinoImageCustomCropHandlesPainter({
    required this.cropShape,
    required this.color,
  });

  final Color color;
  final CropShape cropShape;

  @override
  void paint(Canvas canvas, Size size) {
    final cropPath = cropShape.getTransformedPathForSize(size);

    final pathPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw the path
    canvas.drawPath(cropPath.toUiPath(), pathPaint);
    canvas.clipPath(cropPath.toUiPath());
  }

  @override
  bool shouldRepaint(_CupertinoImageCustomCropHandlesPainter oldDelegate) =>
      oldDelegate.cropShape != cropShape;
}

class _CupertinoImageCropperGuidesPainter extends CustomPainter {
  _CupertinoImageCropperGuidesPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final guidePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0;

    // Draw the guides
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
  bool shouldRepaint(_CupertinoImageCropperGuidesPainter oldDelegate) => false;
}

class _CupertinoImageCropperFineGuidesPainter extends CustomPainter {
  _CupertinoImageCropperFineGuidesPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final guidePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.0;

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
  bool shouldRepaint(_CupertinoImageCropperFineGuidesPainter oldDelegate) =>
      false;
}
