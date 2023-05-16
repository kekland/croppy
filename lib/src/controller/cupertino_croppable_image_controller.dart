import 'dart:math';

import 'package:croppy/src/src.dart';
import 'package:flutter/widgets.dart';

/// A croppable image controller that is similar to the iOS Photos app.
class CupertinoCroppableImageController extends CroppableImageController {
  CupertinoCroppableImageController({
    required super.data,
    required super.imageProvider,
  });

  @override
  double viewportScale = 1.0;

  @override
  set viewportSize(Size? size) {
    if (viewportSize == size) return;

    final isInitial = viewportSize == null;
    super.viewportSize = size;

    _computeViewportScale(shouldNotify: !isInitial);
  }

  void _computeViewportScale({
    // bool animate = true,
    Rect? overrideCropRect,
    bool shouldNotify = true,
  }) {
    if (viewportSize == null) return;

    final cropRect = overrideCropRect ?? data.cropRect;
    final cropSize = cropRect.size;

    final scaleX = viewportSize!.width / cropSize.width;
    final scaleY = viewportSize!.height / cropSize.height;

    final scale = min(scaleX, scaleY);
    viewportScale = scale;

    if (shouldNotify) {
      notifyListeners();
    }
  }
}
