import 'package:croppy/src/src.dart';
import 'package:flutter/material.dart';

class ResizableGestureDetector extends StatelessWidget {
  const ResizableGestureDetector({
    super.key,
    required this.controller,
    required this.child,
    required this.gesturePadding,
  });

  final ResizeTransformation controller;
  final Widget child;
  final double gesturePadding;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Positioned(
          left: gesturePadding,
          top: gesturePadding,
          right: gesturePadding,
          bottom: gesturePadding,
          child: child,
        ),

        // Corners
        Positioned(
          left: 0.0,
          top: 0.0,
          width: gesturePadding * 2,
          height: gesturePadding * 2,
          child: _ResizeGestureDetector(
            controller: controller,
            direction: ResizeDirection.toTopLeft,
          ),
        ),
        Positioned(
          right: 0.0,
          top: 0.0,
          width: gesturePadding * 2,
          height: gesturePadding * 2,
          child: _ResizeGestureDetector(
            controller: controller,
            direction: ResizeDirection.toTopRight,
          ),
        ),
        Positioned(
          left: 0.0,
          bottom: 0.0,
          width: gesturePadding * 2,
          height: gesturePadding * 2,
          child: _ResizeGestureDetector(
            controller: controller,
            direction: ResizeDirection.toBottomLeft,
          ),
        ),
        Positioned(
          right: 0.0,
          bottom: 0.0,
          width: gesturePadding * 2,
          height: gesturePadding * 2,
          child: _ResizeGestureDetector(
            controller: controller,
            direction: ResizeDirection.toBottomRight,
          ),
        ),

        // Sides
        Positioned(
          left: gesturePadding * 2,
          top: 0.0,
          right: gesturePadding * 2,
          height: gesturePadding * 2,
          child: _ResizeGestureDetector(
            controller: controller,
            direction: ResizeDirection.toTop,
          ),
        ),
        Positioned(
          left: gesturePadding * 2,
          bottom: 0.0,
          right: gesturePadding * 2,
          height: gesturePadding * 2,
          child: _ResizeGestureDetector(
            controller: controller,
            direction: ResizeDirection.toBottom,
          ),
        ),
        Positioned(
          left: 0.0,
          top: gesturePadding * 2,
          width: gesturePadding * 2,
          bottom: gesturePadding * 2,
          child: _ResizeGestureDetector(
            controller: controller,
            direction: ResizeDirection.toLeft,
          ),
        ),
        Positioned(
          right: 0.0,
          top: gesturePadding * 2,
          width: gesturePadding * 2,
          bottom: gesturePadding * 2,
          child: _ResizeGestureDetector(
            controller: controller,
            direction: ResizeDirection.toRight,
          ),
        ),
      ],
    );
  }
}

class _ResizeGestureDetector extends StatefulWidget {
  const _ResizeGestureDetector({
    required this.controller,
    required this.direction,
  });

  final ResizeTransformation controller;
  final ResizeDirection direction;

  @override
  State<_ResizeGestureDetector> createState() => _ResizeGestureDetectorState();
}

class _ResizeGestureDetectorState extends State<_ResizeGestureDetector> {
  late DragStartDetails _dragStartDetails;

  void _onPanStart(DragStartDetails details) {
    _dragStartDetails = details;
    widget.controller.onResizeStart();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final delta = details.globalPosition - _dragStartDetails.globalPosition;

    widget.controller.onResize(
      offset: -delta,
      direction: widget.direction,
    );
  }

  void _onPanEnd(DragEndDetails details) {
    widget.controller.onResizeEnd();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: const SizedBox.expand(),
    );
  }
}
