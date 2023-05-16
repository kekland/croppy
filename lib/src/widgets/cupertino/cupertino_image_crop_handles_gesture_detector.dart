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

  void _onScaleEnd() {
    widget.controller.onPanAndScaleEnd();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      onScaleEnd: (_) => _onScaleEnd(),
      child: ResizableGestureDetector(
        controller: widget.controller,
        gesturePadding: widget.gesturePadding,
        child: widget.child,
      ),
    );
  }
}
