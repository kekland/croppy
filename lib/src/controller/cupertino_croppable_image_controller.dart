import 'dart:async';
import 'dart:math';

import 'package:croppy/src/src.dart';
import 'package:flutter/material.dart';

/// A croppable image controller that is similar to the iOS Photos app.
class CupertinoCroppableImageController extends CroppableImageController
    with ResizeStaticLayoutMixin {
  CupertinoCroppableImageController({
    required TickerProvider vsync,
    required super.data,
    required super.imageProvider,
    super.postProcessFn,
  }) {
    _initAnimationControllers(vsync);
  }

  late final AnimationController _imageDataAnimationController;
  late final CurvedAnimation _imageDataAnimation;

  late final AnimationController _viewportScaleAnimationController;
  late final CurvedAnimation _viewportScaleAnimation;

  CroppableImageDataTween? _imageDataTween;

  RectTween? _staticCropRectTween;
  Tween<double>? _viewportScaleTween;

  void _initAnimationControllers(TickerProvider vsync) {
    _imageDataAnimationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 150),
    );

    _imageDataAnimation = CurvedAnimation(
      parent: _imageDataAnimationController,
      curve: Curves.easeInOut,
    );

    _imageDataAnimationController.addListener(() {
      if (_imageDataTween != null) {
        data = _imageDataTween!.evaluate(_imageDataAnimation);
      }

      notifyListeners();
    });

    _viewportScaleAnimationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 150),
    );

    _viewportScaleAnimation = CurvedAnimation(
      parent: _viewportScaleAnimationController,
      curve: Curves.easeInOut,
    );

    _viewportScaleAnimationController.addListener(() {
      if (_viewportScaleTween != null) {
        viewportScale = _viewportScaleTween!.evaluate(
          _viewportScaleAnimation,
        );
      }

      if (_staticCropRectTween != null) {
        staticCropRect = _staticCropRectTween!.evaluate(
          _viewportScaleAnimation,
        );
      }

      notifyListeners();
    });
  }

  @override
  double viewportScale = 1.0;

  @override
  set viewportSize(Size? size) {
    if (viewportSize == size) return;

    super.viewportSize = size;
    setViewportScale(shouldNotify: false);
  }

  double _computeViewportScale({Rect? overrideCropRect}) {
    if (viewportSize == null) return 1.0;

    final cropRect = overrideCropRect ?? data.cropRect;
    final cropSize = cropRect.size;

    final scaleX = viewportSize!.width / cropSize.width;
    final scaleY = viewportSize!.height / cropSize.height;

    final scale = min(scaleX, scaleY);
    return scale;
  }

  void setViewportScale({
    Rect? overrideCropRect,
    bool shouldNotify = true,
  }) {
    viewportScale = _computeViewportScale(overrideCropRect: overrideCropRect);

    if (shouldNotify) {
      notifyListeners();
    }
  }

  void setViewportScaleWithAnimation({Rect? overrideCropRect}) {
    final cropRect = overrideCropRect ?? data.cropRect;

    final scale = _computeViewportScale(
      overrideCropRect: overrideCropRect,
    );

    if (staticCropRect != null) {
      _staticCropRectTween = overrideCropRect != null
          ? RectTween(
              begin: staticCropRect,
              end: cropRect,
            )
          : MaterialRectCenterArcTween(
              begin: staticCropRect,
              end: cropRect,
            );
    } else {
      _staticCropRectTween = null;
    }

    _viewportScaleTween = Tween<double>(
      begin: viewportScale,
      end: scale,
    );

    _viewportScaleAnimationController.forward(from: 0.0);
  }

  @override
  void onStraighten({
    required double angleRad,
  }) {
    if (isRotating) {
      super.onStraighten(angleRad: angleRad);
      normalize();
      setViewportScale();
    } else {
      final oldData = data.copyWith();
      super.onStraighten(angleRad: angleRad);
      normalize();

      _imageDataTween = CroppableImageDataTween(
        begin: oldData,
        end: data,
      );

      setViewportScaleWithAnimation(overrideCropRect: data.cropRect);
      _imageDataAnimationController.forward(from: 0.0);
    }
  }

  @override
  void onPanAndScale({
    required double scale,
    required Offset offset,
  }) {
    super.onPanAndScale(scale: scale, offset: offset);
    setViewportScale();
  }

  @override
  void onPanAndScaleEnd() {
    super.onPanAndScaleEnd();

    final normalizedRect = normalizeWithAnimation();
    setViewportScaleWithAnimation(overrideCropRect: normalizedRect);
  }

  @override
  void onResize({
    required Offset offset,
    required ResizeDirection direction,
  }) {
    super.onResize(offset: offset, direction: direction);
    setViewportScale(overrideCropRect: staticCropRect);
  }

  @override
  void onResizeEnd() {
    super.onResizeEnd();
    normalizeWithAnimation();
    recomputeViewportScaleWithDelay();
  }

  @override
  void onTransformationStart() {
    super.onTransformationStart();

    if (_recomputeViewportScaleTimer?.isActive == true) {
      _recomputeViewportScaleTimer?.cancel();
      setViewportScale();
    }
  }

  @override
  void onBaseTransformation(CroppableImageData newData) {
    _imageDataTween = CroppableImageDataTween(
      begin: data,
      end: newData,
    );

    staticCropRect = null;
    setViewportScaleWithAnimation(overrideCropRect: newData.cropRect);
    _imageDataAnimationController.forward(from: 0.0);
  }

  Timer? _recomputeViewportScaleTimer;
  void recomputeViewportScaleWithDelay() {
    _recomputeViewportScaleTimer?.cancel();
    _recomputeViewportScaleTimer = Timer(
      const Duration(seconds: 1),
      setViewportScaleWithAnimation,
    );
  }

  Rect normalizeWithAnimation() {
    final normalizedAabb = FitAabbInQuadSolver.solve(
      data.cropAabb,
      data.transformedImageQuad,
    );

    if (normalizedAabb == data.cropAabb) {
      return normalizedAabb.rect;
    }

    _imageDataTween = CroppableImageDataTween(
      begin: data,
      end: data.copyWith(
        cropRect: normalizedAabb.rect,
      ),
    );

    _imageDataAnimationController.forward(from: 0.0);
    return normalizedAabb.rect;
  }

  @override
  bool get canReset =>
      data != CroppableImageData.initial(imageSize: data.imageSize);

  @override
  void reset() {
    final oldData = data.copyWith();
    super.reset();

    _imageDataTween = CroppableImageDataTween(
      begin: oldData,
      end: data,
    );

    setViewportScaleWithAnimation(overrideCropRect: data.cropRect);
    _imageDataAnimationController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _imageDataAnimationController.dispose();
    super.dispose();
  }
}
