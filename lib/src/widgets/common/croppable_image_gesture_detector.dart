import 'dart:async';

import 'package:croppy/src/src.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Used for handling zoom with [PointerScrollEvent]
const double _kZoomFactor = 0.001;

/// A [GestureDetector] that handles panning and scaling of the image.
///
/// If the crop shape is an AABB, then this widget will also handle resizing
/// from the corners.
class CroppableImageGestureDetector extends StatefulWidget {
  const CroppableImageGestureDetector({
    super.key,
    required this.gesturePadding,
    required this.controller,
    required this.child,
  });

  /// The padding around the child that is used to detect gestures. The
  /// [child] is padded by this amount on all sides. This is to ensure that
  /// it's easier to grab the corners of the crop shape.
  final double gesturePadding;

  /// The [CroppableImageController] that is used to handle the gestures.
  final CroppableImageController controller;

  /// The child widget that is wrapped by this widget.
  final Widget child;

  @override
  State<CroppableImageGestureDetector> createState() =>
      _CroppableImageGestureDetectorState();
}

class _CroppableImageGestureDetectorState
    extends State<CroppableImageGestureDetector> {
  ScaleUpdateDetails? _lastUpdateDetails;
  Timer? _debounceTimer;

  var _didStart = false;

  void _onScaleStart(ScaleStartDetails details) {}

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (!_didStart) {
      widget.controller.onPanAndScaleStart();
      _didStart = true;
    }

    final _lastScale = _lastUpdateDetails?.scale ?? 1.0;

    widget.controller.onPanAndScale(
      offsetDelta: -details.focalPointDelta,
      scaleDelta: details.scale / _lastScale,
    );

    _lastUpdateDetails = details;
  }

  void _onScaleEnd(ScaleEndDetails details) {
    if (!_didStart) return;
    _didStart = false;

    widget.controller.onPanAndScaleEnd();
    _lastUpdateDetails = null;
  }

  void _onPointerSignalEvent(PointerSignalEvent event) {
    return switch (event) {
      PointerScaleEvent event => _onPointerScaleEvent(event),
      PointerScrollEvent event => _onPointerScrollEvent(event),
      _ => null,
    };
  }

  void _onPointerScaleEvent(PointerScaleEvent event) {
    _debounceTimer?.cancel();

    if (!_didStart) {
      widget.controller.onPanAndScaleStart();
      _didStart = true;
    }

    widget.controller.onPanAndScale(
      offsetDelta: -event.delta,
      scaleDelta: event.scale,
    );

    _resetTime();
  }

  void _onPointerScrollEvent(PointerScrollEvent event) {
    _debounceTimer?.cancel();

    if (!_didStart) {
      widget.controller.onPanAndScaleStart();
      _didStart = true;
    }

    widget.controller.onPanAndScale(
      offsetDelta: -event.delta,
      scaleDelta: 1.0 + event.scrollDelta.dy * _kZoomFactor,
    );

    _resetTime();
  }

  void _onPointerEventEnd() {
    if (!_didStart) return;
    _didStart = false;

    widget.controller.onPanAndScaleEnd();
  }

  void _resetTime() {
    _debounceTimer?.cancel();

    _debounceTimer = Timer(
      const Duration(milliseconds: 100),
      _onPointerEventEnd,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.controller.isTransformationEnabled(
      Transformation.panAndScale,
    );

    return Listener(
      behavior: HitTestBehavior.translucent, // Ensures all events are captured
      onPointerSignal: isEnabled ? _onPointerSignalEvent : null,
      child: GestureDetector(
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
      ),
    );
  }
}
