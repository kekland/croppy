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

  @protected
  CroppableImageData onPanAndScaleImpl({
    required CroppableImageData data,
    required double scaleDelta,
    required Offset offsetDelta,
  }) {
    final scaledOffsetDelta = offsetDelta / viewportScale;

    final rect = data.cropRect;

    final newRect = Rect.fromCenter(
      center: rect.center + scaledOffsetDelta,
      width: rect.width / scaleDelta,
      height: rect.height / scaleDelta,
    );

    return data.copyWithProperCropShape(
      cropShapeFn: cropShapeFn,
      cropRect: newRect,
    );
  }

  /// Called when the user is panning and scaling. This will update the
  /// [BaseCroppableImageController.data] and notify listeners.
  void onPanAndScale({
    required double scaleDelta,
    required Offset offsetDelta,
  }) {
    data = onPanAndScaleImpl(
      data: data,
      scaleDelta: scaleDelta,
      offsetDelta: offsetDelta,
    );

    onTransformation((scaleDelta, offsetDelta));
  }

  /// Called when the user ends panning and scaling.
  @mustCallSuper
  void onPanAndScaleEnd() {
    _isPanAndScaling = false;
    onTransformationEnd();
  }
}
