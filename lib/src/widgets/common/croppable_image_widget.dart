// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:ui';

import 'package:croppy/src/src.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class CroppableImageWidget extends RenderObjectWidget
    with SlottedMultiChildRenderObjectWidgetMixin<EditableImageSlot> {
  const CroppableImageWidget({
    super.key,
    required this.controller,
    required this.image,
    required this.cropHandles,
    this.gesturePadding = 0.0,
  });

  final Widget image;
  final Widget cropHandles;
  final CroppableImageController controller;
  final double gesturePadding;

  @override
  CroppableImageRenderObject createRenderObject(BuildContext context) {
    final staticCropRect = (controller is ResizeStaticLayoutMixin)
        ? (controller as ResizeStaticLayoutMixin).staticCropRect
        : null;

    return CroppableImageRenderObject(
      controller.data,
      controller.viewportScale,
      gesturePadding,
      staticCropRect,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    CroppableImageRenderObject renderObject,
  ) {
    renderObject.imageData = controller.data;
    renderObject.viewportScale = controller.viewportScale;
    renderObject.gesturePadding = gesturePadding;
    renderObject.staticCropRect = (controller is ResizeStaticLayoutMixin)
        ? (controller as ResizeStaticLayoutMixin).staticCropRect
        : null;
  }

  @override
  Widget? childForSlot(slot) {
    switch (slot) {
      case EditableImageSlot.image:
        return image;
      case EditableImageSlot.handles:
        return cropHandles;
    }
  }

  @override
  Iterable<EditableImageSlot> get slots => EditableImageSlot.values;
}

enum EditableImageSlot {
  image,
  handles,
}

class CroppableImageRenderObject extends RenderBox
    with SlottedContainerRenderObjectMixin<EditableImageSlot> {
  CroppableImageRenderObject(
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
    _imageData = value;
    markNeedsLayout();
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

  RenderBox? get image => childForSlot(EditableImageSlot.image);
  RenderBox? get handles => childForSlot(EditableImageSlot.handles);

  @override
  void performLayout() {
    var scaledSize = Size(
      imageData.cropRect.width,
      imageData.cropRect.height,
    );

    var layoutSize = staticCropRect?.size ?? scaledSize;

    scaledSize *= viewportScale;
    layoutSize *= viewportScale;

    scaledSize =
        constraints.constrainSizeAndAttemptToPreserveAspectRatio(scaledSize);

    layoutSize =
        constraints.constrainSizeAndAttemptToPreserveAspectRatio(layoutSize);

    image!.layout(
      BoxConstraints.tight(imageData.imageSize),
      parentUsesSize: false,
    );

    final padding = Offset(gesturePadding * 2, gesturePadding * 2);
    final sizeWithPadding = scaledSize + padding;
    final layoutSizeWithPadding = layoutSize + padding;

    handles!.layout(
      BoxConstraints.tight(sizeWithPadding),
      parentUsesSize: false,
    );

    size = layoutSizeWithPadding;
  }

  final _imageFilterLayer = LayerHandle<ImageFilterLayer>();
  void paintBackgroundImage(
    PaintingContext context,
    Offset offset,
    Matrix4 transform,
  ) {
    _imageFilterLayer.layer = ImageFilterLayer(
      imageFilter: null,
      offset: offset,
    );

    _imageFilterLayer.layer!.imageFilter = ImageFilter.matrix(
      transform.storage,
    );

    context.pushLayer(
      _imageFilterLayer.layer!,
      (context, offset) {
        context.paintChild(image!, offset);
      },
      Offset.zero,
    );
  }

  final _transformLayer = LayerHandle<TransformLayer>();
  final _clipRectLayer = LayerHandle<ClipRectLayer>();
  void paintCroppedImage(
    PaintingContext context,
    Offset offset,
    Rect clipRect,
    Matrix4 transform,
  ) {
    _clipRectLayer.layer = context.pushClipRect(
      false,
      offset,
      clipRect,
      (context, offset) {
        _transformLayer.layer = context.pushTransform(
          false,
          offset,
          transform,
          (context, offset) {
            context.paintChild(image!, offset);
          },
          oldLayer: _transformLayer.layer,
        );
      },
      clipBehavior: Clip.antiAlias,
      oldLayer: _clipRectLayer.layer,
    );
  }

  void paintHandles(PaintingContext context, Offset offset) {
    context.paintChild(
      handles!,
      offset,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (image == null || handles == null) return;

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

    paintBackgroundImage(context, _offset, matrix);
    paintCroppedImage(
      context,
      _offset,
      additionalOffset & (imageData.cropRect.size * viewportScale),
      matrix,
    );
    paintHandles(context, offset + additionalOffset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return handles!.hitTest(
      result,
      position: position,
    );
  }
}
