import 'package:croppy/src/src.dart';
import 'package:flutter/material.dart';

class CroppableImageGestureDetector extends StatefulWidget {
  const CroppableImageGestureDetector({
    super.key,
    required this.gesturePadding,
    required this.controller,
    required this.child,
  });

  final double gesturePadding;
  final CroppableImageController controller;
  final Widget child;

  @override
  State<CroppableImageGestureDetector> createState() =>
      _CroppableImageGestureDetectorState();
}

class _CroppableImageGestureDetectorState
    extends State<CroppableImageGestureDetector> {
  void _onScaleStart(ScaleStartDetails details) {
    widget.controller.onPanAndScaleStart();
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    widget.controller.onPanAndScale(
      offsetDelta: -details.focalPointDelta,
      scale: 1 / details.scale,
    );
  }

  void _onScaleEnd(ScaleEndDetails details) {
    widget.controller.onPanAndScaleEnd();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.controller.isTransformationEnabled(
      Transformation.panAndScale,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onScaleStart: isEnabled ? _onScaleStart : null,
      onScaleUpdate: isEnabled ? _onScaleUpdate : null,
      onScaleEnd: isEnabled ? _onScaleEnd : null,
      // Don't use ResizableGestureDetector if we have a non-aabb crop shape
      child: widget.controller.data.cropShape.type == CropShapeType.aabb
          ? ResizableGestureDetector(
              controller: widget.controller,
              gesturePadding: widget.gesturePadding,
              child: widget.child,
            )
          : Padding(
              padding: EdgeInsets.all(widget.gesturePadding),
              child: widget.child,
            ),
    );
  }
}
