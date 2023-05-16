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
    required Offset offset,
  }) {
    final scaledOffset = offset / viewportScale;

    final initialData = transformationInitialData!;
    final rect = initialData.cropRect;

    final newRect = Rect.fromCenter(
      center: rect.center + scaledOffset,
      width: rect.width * scale,
      height: rect.height * scale,
    );

    data = initialData.copyWith(cropRect: newRect);
    notifyListeners();
  }

  /// Called when the user ends panning and scaling.
  @mustCallSuper
  void onPanAndScaleEnd() {
    _isPanAndScaling = false;
    onTransformationEnd();
  }
}
