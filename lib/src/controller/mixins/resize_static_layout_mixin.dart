import 'dart:math';

import 'package:croppy/croppy.dart';
import 'package:flutter/widgets.dart';

/// A mixin for the [CroppableImageController] that allows to keep the layout 
/// static while resizing.
mixin ResizeStaticLayoutMixin on ResizeTransformation {
  Rect? staticCropRect;

  @override
  void onTransformationStart() {
    super.onTransformationStart();
    staticCropRect = null;
  }

  @override
  void onResize({
    required Offset offset,
    required ResizeDirection direction,
  }) {
    super.onResize(offset: offset, direction: direction);

    staticCropRect ??= data.cropRect;

    final newCropRect = data.cropRect;
    final minX = min(newCropRect.left, staticCropRect!.left);
    final minY = min(newCropRect.top, staticCropRect!.top);
    final maxX = max(newCropRect.right, staticCropRect!.right);
    final maxY = max(newCropRect.bottom, staticCropRect!.bottom);

    staticCropRect = Rect.fromLTRB(minX, minY, maxX, maxY);
  }
}
