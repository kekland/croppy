import 'package:croppy/src/src.dart';
import 'package:flutter/widgets.dart';

/// A mixin that provides resizing functionality to a
/// [BaseCroppableImageController].
mixin ResizeTransformation on BaseCroppableImageController {
  /// Returns `true` if the user is currently resizing the crop rect.
  bool get isResizing => _isResizing;
  bool _isResizing = false;

  /// Called when the user starts resizing the crop rect.
  ///
  /// Returns `false` if the resize operation should be cancelled.
  @mustCallSuper
  bool onResizeStart() {
    if (isTransforming) return false;

    onTransformationStart();
    _isResizing = true;
    return true;
  }

  @protected
  CroppableImageData onResizeImpl({
    required CroppableImageData data,
    required Offset offsetDelta,
    required ResizeDirection direction,
  }) {
    final scaledOffset = offsetDelta / viewportScale;

    final rect = data.cropRect;
    Rect newRect;

    switch (direction) {
      case ResizeDirection.toTop:
        newRect = Rect.fromLTRB(
          rect.left,
          rect.top - scaledOffset.dy,
          rect.right,
          rect.bottom,
        );
        break;
      case ResizeDirection.toBottom:
        newRect = Rect.fromLTRB(
          rect.left,
          rect.top,
          rect.right,
          rect.bottom - scaledOffset.dy,
        );
        break;
      case ResizeDirection.toLeft:
        newRect = Rect.fromLTRB(
          rect.left - scaledOffset.dx,
          rect.top,
          rect.right,
          rect.bottom,
        );
        break;
      case ResizeDirection.toRight:
        newRect = Rect.fromLTRB(
          rect.left,
          rect.top,
          rect.right - scaledOffset.dx,
          rect.bottom,
        );
        break;
      case ResizeDirection.toTopLeft:
        newRect = Rect.fromLTRB(
          rect.left - scaledOffset.dx,
          rect.top - scaledOffset.dy,
          rect.right,
          rect.bottom,
        );
        break;
      case ResizeDirection.toTopRight:
        newRect = Rect.fromLTRB(
          rect.left,
          rect.top - scaledOffset.dy,
          rect.right - scaledOffset.dx,
          rect.bottom,
        );
        break;
      case ResizeDirection.toBottomLeft:
        newRect = Rect.fromLTRB(
          rect.left - scaledOffset.dx,
          rect.top,
          rect.right,
          rect.bottom - scaledOffset.dy,
        );
        break;
      case ResizeDirection.toBottomRight:
        newRect = Rect.fromLTRB(
          rect.left,
          rect.top,
          rect.right - scaledOffset.dx,
          rect.bottom - scaledOffset.dy,
        );
        break;
    }

    // Apply checks for minimum crop dimension
    final normalizedSize = normalizeCropSize(newRect.size);

    if (newRect.width != normalizedSize.width) {
      newRect = Rect.fromLTWH(
        rect.left,
        newRect.top,
        normalizedSize.width,
        newRect.height,
      );
    }

    if (newRect.height != normalizedSize.height) {
      newRect = Rect.fromLTWH(
        newRect.left,
        rect.top,
        newRect.width,
        normalizedSize.height,
      );
    }

    return data.copyWithProperCropShape(
      cropShapeFn: cropShapeFn,
      cropRect: newRect,
    );
  }

  /// Called when the user is resizing the crop rect. This will update the
  /// [BaseCroppableImageController.data] and notify listeners.
  void onResize({
    required Offset offsetDelta,
    required ResizeDirection direction,
  }) {
    if (!_isResizing) return;

    data = onResizeImpl(
      data: data,
      offsetDelta: offsetDelta,
      direction: direction,
    );

    onTransformation((offsetDelta, direction));
  }

  /// Called when the user ends resizing the crop rect.
  @mustCallSuper
  void onResizeEnd() {
    if (!_isResizing) return;
    
    _isResizing = false;
    onTransformationEnd();
  }
}
