import 'dart:math';

import 'package:croppy/croppy.dart';
import 'package:flutter/widgets.dart';

/// A mixin for the [CroppableImageController] that allows to keep the layout
/// static while resizing.
mixin ResizeStaticLayoutMixin on ResizeTransformation {
  Rect? staticCropRect;

  void computeStaticCropRectDuringResize() {
    staticCropRect ??= data.cropRect;

    final newCropRect = data.cropRect;
    final minX = min(newCropRect.left, staticCropRect!.left);
    final minY = min(newCropRect.top, staticCropRect!.top);
    final maxX = max(newCropRect.right, staticCropRect!.right);
    final maxY = max(newCropRect.bottom, staticCropRect!.bottom);

    staticCropRect = Rect.fromLTRB(minX, minY, maxX, maxY);
  }
}
