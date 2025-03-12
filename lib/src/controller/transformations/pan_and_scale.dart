import 'package:croppy/src/src.dart';
import 'package:flutter/widgets.dart';

/// A mixin for [BaseCroppableImageController] that adds pan and scale
/// functionality.
mixin PanAndScaleTransformation on BaseCroppableImageController {
  /// Whether the user is currently panning and scaling.
  bool get isPanAndScaling => _isPanAndScaling;
  bool _isPanAndScaling = false;

  /// Called when the user starts panning and scaling.
  ///
  /// Returns `false` if the pan and scale operation should be cancelled.
  @mustCallSuper
  bool onPanAndScaleStart() {
    if (isTransforming) return false;

    onTransformationStart();
    _isPanAndScaling = true;
    return true;
  }

  @protected
  CroppableImageData onPanAndScaleImpl({
    required CroppableImageData data,
    required double scaleDelta,
    required Offset offsetDelta,
  }) {
    final scaledOffsetDelta = offsetDelta / viewportScale;

    final rect = data.cropRect;
    final size = normalizeCropSize(
      Size(rect.width / scaleDelta, rect.height / scaleDelta),
    );

    final newRect = Rect.fromCenter(
      center: rect.center + scaledOffsetDelta,
      width: size.width,
      height: size.height,
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
    if (!_isPanAndScaling) return;

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
    if (!_isPanAndScaling) return;

    _isPanAndScaling = false;
    onTransformationEnd();
  }
}
