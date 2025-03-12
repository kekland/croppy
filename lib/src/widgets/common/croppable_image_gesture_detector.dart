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
    required this.showGestureHandlesOn,
    required this.child,
  });

  /// The padding around the child that is used to detect gestures. The
  /// [child] is padded by this amount on all sides. This is to ensure that
  /// it's easier to grab the corners of the crop shape.
  final double gesturePadding;

  /// This list is used to decide if handles should be shown.
  /// If [cropShape.type] is contained in this list, handles will be shown.
  final List<CropShapeType> showGestureHandlesOn;

  /// The [CroppableImageController] that is used to handle the gestures.
  final CroppableImageController controller;

  /// The child widget that is wrapped by this widget.
  final Widget child;

  @override
  State<CroppableImageGestureDetector> createState() =>
      _CroppableImageGestureDetectorState();
}

class _CroppableImageGestureDetectorState
    extends State<CroppableImageGestureDetector>
    with SingleTickerProviderStateMixin {
  // Used for double-tap
  late final AnimationController _doubleTapAnimation;
  late double _doubleTapLastScale;

  // Used for mouse wheel and pinch-to-zoom on trackpads
  ScaleUpdateDetails? _lastUpdateDetails;
  Timer? _debounceTimer;
  var _didStart = false;

  @override
  void initState() {
    super.initState();

    _doubleTapAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _doubleTapAnimation.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        widget.controller.onPanAndScaleStart();
        _doubleTapLastScale = 1.0;
      } else if (status == AnimationStatus.completed) {
        widget.controller.onPanAndScaleEnd();
      }
    });

    _doubleTapAnimation.addListener(() {
      final scaleDelta =
          (1.0 + _doubleTapAnimation.value) / _doubleTapLastScale;
      _doubleTapLastScale = _doubleTapLastScale * scaleDelta;

      widget.controller.onPanAndScale(
        offsetDelta: Offset.zero,
        scaleDelta: scaleDelta,
      );
    });
  }

  @override
  void dispose() {
    _doubleTapAnimation.dispose();
    _debounceTimer?.cancel();

    super.dispose();
  }

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

  void _onDoubleTap() {
    if (_doubleTapAnimation.isAnimating) return;

    _doubleTapLastScale = 1.0;
    _doubleTapAnimation.forward(from: 0.0);
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
        onDoubleTap: isEnabled ? _onDoubleTap : null,
        // Only show gesture handles when shape is specified in showGestureHandlesOn
        child: widget.showGestureHandlesOn.contains(widget.controller.data.cropShape.type)
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