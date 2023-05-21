import 'package:croppy/croppy.dart';
import 'package:flutter/material.dart';

mixin AnimatedControllerMixin on CroppableImageControllerWithMixins {
  late final AnimationController imageDataAnimationController;
  late final CurvedAnimation _imageDataAnimation;

  late final AnimationController viewportScaleAnimationController;
  late final CurvedAnimation _viewportScaleAnimation;

  CroppableImageDataTween? _imageDataTween;

  RectTween? _staticCropRectTween;
  Tween<double>? _viewportScaleTween;

  void initAnimationControllers(TickerProvider vsync) {
    imageDataAnimationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 150),
    );

    _imageDataAnimation = CurvedAnimation(
      parent: imageDataAnimationController,
      curve: Curves.easeInOut,
    );

    imageDataAnimationController.addListener(() {
      if (_imageDataTween != null) {
        data = _imageDataTween!.evaluate(_imageDataAnimation);
      }

      notifyListeners();
    });

    viewportScaleAnimationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 150),
    );

    _viewportScaleAnimation = CurvedAnimation(
      parent: viewportScaleAnimationController,
      curve: Curves.easeInOut,
    );

    viewportScaleAnimationController.addListener(() {
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

    viewportScaleAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_staticCropRectTween != null) {
          staticCropRect = null;
          notifyListeners();
        }
      }
    });
  }

  void setViewportScaleWithAnimation({Rect? overrideCropRect}) {
    final cropRect = overrideCropRect ?? data.cropRect;

    final scale = computeViewportScale(
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

    viewportScaleAnimationController.forward(from: 0.0);
  }

  @override
  void onBaseTransformation(CroppableImageData newData) {
    _imageDataTween = CroppableImageDataTween(
      begin: data,
      end: newData,
    );

    staticCropRect = null;
    setViewportScaleWithAnimation(overrideCropRect: newData.cropRect);
    imageDataAnimationController.forward(from: 0.0);
  }

  @override
  void reset() {
    data = data.copyWith(
      baseTransformations: data.baseTransformations.normalized,
    );

    animatedNormalizeAfterTransform(
      () => super.reset(),
    );
  }

  @override
  set currentAspectRatio(CropAspectRatio? newAspectRatio) {
    if (aspectRatioNotifier.value == newAspectRatio) return;

    animatedNormalizeAfterTransform(
      () => super.currentAspectRatio = newAspectRatio,
    );

    notifyListeners();
  }

  Rect normalizeWithAnimation() {
    final oldData = data.copyWith();

    normalize();
    final normalizedAabb = data.cropAabb;

    data = oldData;

    if (normalizedAabb == data.cropAabb) {
      return normalizedAabb.rect;
    }

    _imageDataTween = CroppableImageDataTween(
      begin: data,
      end: data.copyWith(
        cropRect: normalizedAabb.rect,
      ),
    );

    imageDataAnimationController.forward(from: 0.0);
    return normalizedAabb.rect;
  }

  void animatedNormalizeAfterTransform(VoidCallback action) {
    final oldData = data.copyWith();
    action();

    _imageDataTween = CroppableImageDataTween(
      begin: oldData,
      end: data,
    );

    setViewportScaleWithAnimation(overrideCropRect: data.cropRect);
    imageDataAnimationController.forward(from: 0.0);
  }

  @override
  void onTransformationStart() {
    super.onTransformationStart();

    if (imageDataAnimationController.isAnimating) {
      imageDataAnimationController.stop();
      data = _imageDataTween!.end!;
    }
  }

  @override
  void onTransformation(dynamic args) {
    super.onTransformation(args);
    _staticCropRectTween?.end = data.cropRect;
  }

  void setStaticCropRectTweenEnd(Rect? end) {
    _staticCropRectTween?.end = end;
  }

  @override
  void dispose() {
    imageDataAnimationController.dispose();
    viewportScaleAnimationController.dispose();
    super.dispose();
  }
}
