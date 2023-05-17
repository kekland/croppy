import 'package:croppy/src/src.dart';
import 'package:flutter/cupertino.dart';

class CupertinoImageCropHandles extends StatelessWidget {
  const CupertinoImageCropHandles({
    super.key,
    required this.controller,
    required this.gesturePadding,
  });

  final CroppableImageController controller;
  final double gesturePadding;

  Widget _buildHandles(BuildContext context, bool areGuideLinesVisible) {
    final fineGuidesChild = AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      opacity: controller.isRotating && areGuideLinesVisible ? 1.0 : 0.0,
      child: CustomPaint(
        painter: _CupertinoImageCropperFineGuidesPainter(),
      ),
    );

    final guidesChild = AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      opacity: areGuideLinesVisible ? 1.0 : 0.0,
      child: CustomPaint(
        painter: _CupertinoImageCropperGuidesPainter(),
      ),
    );

    final cropShape = controller.data.cropShape;

    Widget child = Stack(
      fit: StackFit.passthrough,
      children: [
        CustomPaint(
          painter: cropShape.type == CropShapeType.aabb
              ? const _CupertinoImageRectCropHandlesPainter()
              : _CupertinoImageCustomCropHandlesPainter(cropShape: cropShape),
        ),
        ClipPath(
          clipper: _CupertinoImageCropHandlesClipper(cropShape),
          child: guidesChild,
        ),
        ClipPath(
          clipper: _CupertinoImageCropHandlesClipper(cropShape),
          child: fineGuidesChild,
        )
      ],
    );

    return CupertinoImageCropHandlesGestureDetector(
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
  const _CupertinoImageRectCropHandlesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const color = CupertinoColors.white;
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
  });

  final CropShape cropShape;

  @override
  void paint(Canvas canvas, Size size) {
    final cropPath = cropShape.getTransformedPathForSize(size);

    const color = CupertinoColors.white;
    final pathPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw the path
    canvas.drawPath(cropPath, pathPaint);
    canvas.clipPath(cropPath);
  }

  @override
  bool shouldRepaint(_CupertinoImageCustomCropHandlesPainter oldDelegate) =>
      oldDelegate.cropShape != cropShape;
}

class _CupertinoImageCropperGuidesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const color = CupertinoColors.white;
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
  @override
  void paint(Canvas canvas, Size size) {
    final color = CupertinoColors.white.withOpacity(0.3);

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

class _CupertinoImageCropHandlesClipper extends CustomClipper<Path> {
  _CupertinoImageCropHandlesClipper(this.cropShape);

  final CropShape cropShape;

  @override
  Path getClip(Size size) => cropShape.getTransformedPathForSize(size);

  @override
  bool shouldReclip(_CupertinoImageCropHandlesClipper oldClipper) =>
      oldClipper.cropShape != cropShape;
}
