import 'package:croppy/src/src.dart';
import 'package:flutter/material.dart';

class CupertinoImageCropHandlesGestureDetector extends StatefulWidget {
  const CupertinoImageCropHandlesGestureDetector({
    super.key,
    required this.gesturePadding,
    required this.controller,
    required this.child,
  });

  final double gesturePadding;
  final CroppableImageController controller;
  final Widget child;

  @override
  State<CupertinoImageCropHandlesGestureDetector> createState() =>
      _CupertinoImageCropHandlesGestureDetectorState();
}

class _CupertinoImageCropHandlesGestureDetectorState
    extends State<CupertinoImageCropHandlesGestureDetector> {
  late ScaleStartDetails _scaleStartDetails;

  void _onScaleStart(ScaleStartDetails details) {
    _scaleStartDetails = details;
    widget.controller.onPanAndScaleStart();
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final delta = details.focalPoint - _scaleStartDetails.focalPoint;

    widget.controller.onPanAndScale(
      offset: -delta,
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
