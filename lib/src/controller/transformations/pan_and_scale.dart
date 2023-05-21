import 'package:croppy/src/src.dart';
import 'package:flutter/widgets.dart';

/// A mixin for [BaseCroppableImageController] that adds pan and scale
/// functionality.
mixin PanAndScaleTransformation on BaseCroppableImageController {
  /// Whether the user is currently panning and scaling.
  bool get isPanAndScaling => _isPanAndScaling;
  bool _isPanAndScaling = false;

  /// Called when the user starts panning and scaling.
  @mustCallSuper
  void onPanAndScaleStart() {
    onTransformationStart();
    _isPanAndScaling = true;
  }

  /// Called when the user is panning and scaling. This will update the
  /// [BaseCroppableImageController.data] and notify listeners.
  void onPanAndScale({
    required double scale,
    required Offset offsetDelta,
  }) {
    final scaledOffsetDelta = offsetDelta / viewportScale;

    final initialSize = transformationInitialData!.cropRect.size;
    final rect = data.cropRect;

    final newRect = Rect.fromCenter(
      center: rect.center + scaledOffsetDelta,
      width: initialSize.width * scale,
      height: initialSize.height * scale,
    );

    data = data.copyWith(cropRect: newRect);
    onTransformation((scale, offsetDelta));
  }

  /// Called when the user ends panning and scaling.
  @mustCallSuper
  void onPanAndScaleEnd() {
    _isPanAndScaling = false;
    onTransformationEnd();
  }
}
