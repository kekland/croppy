import 'package:croppy/src/src.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// A GestureDetector that allows resizing an AABB crop rect from its corners
/// and sides.
class ResizableGestureDetector extends StatelessWidget {
  const ResizableGestureDetector({
    super.key,
    required this.controller,
    required this.child,
    required this.gesturePadding,
  });

  /// The [CroppableImageController] that is used to handle the gestures.
  final CroppableImageController controller;

  /// The child widget that is wrapped by this widget.
  final Widget child;

  /// The padding around the child that is used to detect gestures.
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

  final CroppableImageController controller;
  final ResizeDirection direction;

  @override
  State<_ResizeGestureDetector> createState() => _ResizeGestureDetectorState();
}

class _ResizeGestureDetectorState extends State<_ResizeGestureDetector> {
  void _onPanStart(DragStartDetails details) {
    widget.controller.onResizeStart();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    widget.controller.onResize(
      offsetDelta: -details.delta,
      direction: widget.direction,
    );
  }

  void _onPanEnd() {
    widget.controller.onResizeEnd();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.controller.isTransformationEnabled(
      Transformation.resize,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      dragStartBehavior: DragStartBehavior.down,
      onPanStart: isEnabled ? _onPanStart : null,
      onPanUpdate: isEnabled ? _onPanUpdate : null,
      onPanEnd: isEnabled ? (_) => _onPanEnd() : null,
      onPanCancel: isEnabled ? _onPanEnd : null,
      child: const SizedBox.expand(),
    );
  }
}
