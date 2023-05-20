import 'dart:async';

import 'package:croppy/src/src.dart';
import 'package:flutter/material.dart';

/// A croppable image controller that is similar to the iOS Photos app.
class CupertinoCroppableImageController extends CroppableImageController
    with AspectRatioMixin, ResizeStaticLayoutMixin, ViewportScaleComputer {
  CupertinoCroppableImageController({
    required TickerProvider vsync,
    required super.data,
    required super.imageProvider,
    super.postProcessFn,
    super.cropShapeFn,
    super.enabledTransformations,
    List<CropAspectRatio?>? allowedAspectRatios,
  }) : allowedAspectRatios =
            allowedAspectRatios ?? createDefaultAspectRatios(data.imageSize) {
    _initAnimationControllers(vsync);
    maybeSetAspectRatioOnInit();
  }

  late final AnimationController _imageDataAnimationController;
  late final CurvedAnimation _imageDataAnimation;

  late final AnimationController _viewportScaleAnimationController;
  late final CurvedAnimation _viewportScaleAnimation;

  CroppableImageDataTween? _imageDataTween;

  RectTween? _staticCropRectTween;
  Tween<double>? _viewportScaleTween;

  /// Allowed aspect ratios for the aspect ratio toolbar.
  @override
  final List<CropAspectRatio?> allowedAspectRatios;

  /// Whether the guide lines are visible.
  final guideLinesVisibility = ValueNotifier<bool>(false);

  final toolbarNotifier = ValueNotifier<CupertinoCroppableImageToolbar>(
    CupertinoCroppableImageToolbar.transform,
  );

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

    _viewportScaleAnimationController.addStatusListener((status) {
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

    _viewportScaleAnimationController.forward(from: 0.0);
  }

  @override
  void onStraighten({
    required double angleRad,
  }) {
    if (isRotatingZ) {
      super.onStraighten(angleRad: angleRad);
      normalize();
      setViewportScale();
    } else {
      animatedNormalizeAfterTransform(
        () {
          super.onStraighten(angleRad: angleRad);
          normalize();
        },
      );
    }
  }

  @override
  void onRotateX({
    required double angleRad,
  }) {
    if (isRotatingX) {
      super.onRotateX(angleRad: angleRad);
      normalize();
      setViewportScale();
    } else {
      animatedNormalizeAfterTransform(
        () {
          super.onRotateX(angleRad: angleRad);
          normalize();
        },
      );
    }
  }

  @override
  void onRotateY({
    required double angleRad,
  }) {
    if (isRotatingY) {
      super.onRotateY(angleRad: angleRad);
      normalize();
      setViewportScale();
    } else {
      animatedNormalizeAfterTransform(
        () {
          super.onRotateY(angleRad: angleRad);
          normalize();
        },
      );
    }
  }

  @override
  void onPanAndScale({
    required double scale,
    required Offset offsetDelta,
  }) {
    super.onPanAndScale(scale: scale, offsetDelta: offsetDelta);
    _staticCropRectTween?.end = data.cropRect;
    setViewportScale();
  }

  @override
  void onPanAndScaleEnd() {
    super.onPanAndScaleEnd();

    final normalizedRect = normalizeWithAnimation();
    setViewportScaleWithAnimation(overrideCropRect: normalizedRect);
  }

  @override
  void onResizeStart() {
    super.onResizeStart();

    if (_viewportScaleAnimationController.isAnimating) {
      _viewportScaleAnimationController.stop();
    }
  }

  @override
  void onResize({
    required Offset offset,
    required ResizeDirection direction,
  }) {
    super.onResize(offset: offset, direction: direction);
    computeStaticCropRectDuringResize();

    _staticCropRectTween?.end = staticCropRect;
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
      setViewportScaleWithAnimation();
    }

    showGuideLines();
  }

  @override
  void onTransformationEnd() {
    super.onTransformationEnd();
    maybeHideGuideLines();
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

    showGuideLines();
    maybeHideGuideLines();
  }

  @override
  set currentAspectRatio(CropAspectRatio? newAspectRatio) {
    if (aspectRatioNotifier.value == newAspectRatio) return;

    animatedNormalizeAfterTransform(
      () => super.currentAspectRatio = newAspectRatio,
    );

    notifyListeners();
  }

  Timer? _recomputeViewportScaleTimer;
  void recomputeViewportScaleWithDelay() {
    _recomputeViewportScaleTimer?.cancel();
    _recomputeViewportScaleTimer = Timer(
      const Duration(seconds: 1),
      setViewportScaleWithAnimation,
    );
  }

  Timer? _hideGuideLinesTimer;

  void showGuideLines() {
    _hideGuideLinesTimer?.cancel();
    guideLinesVisibility.value = true;
  }

  void maybeHideGuideLines() {
    _hideGuideLinesTimer?.cancel();
    _hideGuideLinesTimer = Timer(
      const Duration(seconds: 1),
      () => guideLinesVisibility.value = false,
    );
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

    _imageDataAnimationController.forward(from: 0.0);
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
    _imageDataAnimationController.forward(from: 0.0);
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

  void toggleToolbar(CupertinoCroppableImageToolbar toolbar) {
    if (toolbarNotifier.value == toolbar) {
      toolbarNotifier.value = CupertinoCroppableImageToolbar.transform;
    } else {
      toolbarNotifier.value = toolbar;
    }
  }

  @override
  void dispose() {
    _imageDataAnimationController.dispose();
    super.dispose();
  }
}

enum CupertinoCroppableImageToolbar {
  transform,
  aspectRatio,
}
