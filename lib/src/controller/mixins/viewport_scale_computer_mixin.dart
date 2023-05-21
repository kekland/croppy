import 'dart:math';

import 'package:croppy/src/src.dart';
import 'package:flutter/widgets.dart';

mixin ViewportScaleComputerMixin on BaseCroppableImageController {
  @override
  double viewportScale = 1.0;

  void setViewportScale({
    Rect? overrideCropRect,
    bool shouldNotify = true,
  }) {
    viewportScale = computeViewportScale(overrideCropRect: overrideCropRect);

    if (shouldNotify) {
      notifyListeners();
    }
  }

  @override
  set viewportSize(Size? size) {
    if (viewportSize == size) return;

    super.viewportSize = size;
    setViewportScale(shouldNotify: false);
  }

  @override
  void setViewportSizeInBuild(Size? size) {
    if (viewportSize == size) return;
    final shouldNotifyAfterFrame = viewportSize != null;

    super.setViewportSizeInBuild(size);

    if (shouldNotifyAfterFrame) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  double computeViewportScale({Rect? overrideCropRect}) {
    if (viewportSize == null) return 1.0;

    final cropRect = overrideCropRect ?? data.cropRect;
    final cropSize = cropRect.size;

    final scaleX = viewportSize!.width / cropSize.width;
    final scaleY = viewportSize!.height / cropSize.height;

    final scale = min(scaleX, scaleY);
    return scale;
  }
}
