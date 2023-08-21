// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:croppy/src/src.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// TODO: Document this
class CroppedHeroImageWidget extends SingleChildRenderObjectWidget {
  const CroppedHeroImageWidget({
    super.key,
    required this.controller,
    required super.child,
    this.gesturePadding = 0.0,
  });

  final CroppableImageController controller;
  final double gesturePadding;

  @override
  CroppedHeroImageRenderObject createRenderObject(BuildContext context) {
    final staticCropRect = (controller is ResizeStaticLayoutMixin)
        ? (controller as ResizeStaticLayoutMixin).staticCropRect
        : null;

    return CroppedHeroImageRenderObject(
      controller.data,
      controller.viewportScale,
      gesturePadding,
      staticCropRect,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    CroppedHeroImageRenderObject renderObject,
  ) {
    renderObject.imageData = controller.data;
    renderObject.viewportScale = controller.viewportScale;
    renderObject.gesturePadding = gesturePadding;
    renderObject.staticCropRect = (controller is ResizeStaticLayoutMixin)
        ? (controller as ResizeStaticLayoutMixin).staticCropRect
        : null;
  }
}

// TODO: Reduce code duplication with CroppableImageRenderObject

class CroppedHeroImageRenderObject extends RenderBox
    with RenderObjectWithChildMixin {
  CroppedHeroImageRenderObject(
    CroppableImageData imageData,
    double viewportScale,
    double gestureSafeArea, [
    Rect? staticCropRect,
  ])  : _imageData = imageData,
        _viewportScale = viewportScale,
        _gesturePadding = gestureSafeArea,
        _staticCropRect = staticCropRect;

  CroppableImageData _imageData;
  CroppableImageData get imageData => _imageData;
  set imageData(CroppableImageData value) {
    if (_imageData == value) return;

    if (_imageData.cropRect != value.cropRect) {
      markNeedsLayout();
    } else {
      markNeedsPaint();
    }

    _imageData = value;
  }

  double _viewportScale;
  double get viewportScale => _viewportScale;
  set viewportScale(double value) {
    if (_viewportScale == value) return;
    _viewportScale = value;
    markNeedsLayout();
  }

  double _gesturePadding;
  double get gesturePadding => _gesturePadding;
  set gesturePadding(double value) {
    if (_gesturePadding == value) return;
    _gesturePadding = value;
    markNeedsLayout();
  }

  Rect? _staticCropRect;
  Rect? get staticCropRect => _staticCropRect;
  set staticCropRect(Rect? value) {
    if (value == _staticCropRect) return;
    _staticCropRect = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    var scaledSize = Size(
      imageData.cropRect.width,
      imageData.cropRect.height,
    );

    var layoutSize = staticCropRect?.size ?? scaledSize;
    layoutSize *= viewportScale;

    layoutSize =
        constraints.constrainSizeAndAttemptToPreserveAspectRatio(layoutSize);

    child!.layout(
      BoxConstraints.tight(imageData.imageSize),
      parentUsesSize: false,
    );

    final padding = Offset(gesturePadding * 2, gesturePadding * 2);
    final layoutSizeWithPadding = layoutSize + padding;

    size = layoutSizeWithPadding;
  }

  final _clipPathLayer = LayerHandle<ClipPathLayer>();
  final _transformLayer = LayerHandle<TransformLayer>();
  void paintCroppedImage(
    PaintingContext context,
    Offset offset,
    Rect bounds,
    Path clipPath,
    Matrix4 transform,
  ) {
    _clipPathLayer.layer = context.pushClipPath(
      false,
      offset,
      bounds,
      clipPath,
      (context, offset) {
        _transformLayer.layer = context.pushTransform(
          false,
          offset,
          transform,
          (context, offset) {
            context.paintChild(child!, offset);
          },
          oldLayer: _transformLayer.layer,
        );
      },
      clipBehavior: Clip.antiAlias,
      oldLayer: _clipPathLayer.layer,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    var additionalOffset = Offset.zero;

    if (staticCropRect != null) {
      additionalOffset = (imageData.cropRect.topLeft - staticCropRect!.topLeft);
      additionalOffset *= viewportScale;
    }

    final _offset = offset + Offset(gesturePadding, gesturePadding);
    final _layoutCropRect = staticCropRect ?? imageData.cropRect;

    final scaleTransform = Matrix4.identity()..scale(viewportScale);
    final translationTransform = Matrix4.identity()
      ..translate(-_layoutCropRect.left, -_layoutCropRect.top);

    final Matrix4 matrix =
        scaleTransform * translationTransform * imageData.totalImageTransform;

    final cropRect =
        additionalOffset & (imageData.cropRect.size * viewportScale);

    paintCroppedImage(
      context,
      _offset,
      additionalOffset & (imageData.cropRect.size * viewportScale),
      _imageData.cropShape
          .getTransformedPath(
            -cropRect.topLeft,
            viewportScale,
          )
          .toUiPath(),
      matrix,
    );
  }
}
