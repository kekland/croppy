import 'package:croppy/src/src.dart';
import 'package:flutter/material.dart';

class MaterialCroppableImageController extends CroppableImageController
    with AspectRatioMixin, ViewportScaleComputer, ResizeStaticLayoutMixin {
  MaterialCroppableImageController({
    required TickerProvider vsync,
    required super.imageProvider,
    required super.data,
    super.cropShapeFn,
    super.enabledTransformations,
    super.postProcessFn,
    List<CropAspectRatio?>? allowedAspectRatios,
  }) : allowedAspectRatios =
            allowedAspectRatios ?? createDefaultAspectRatios(data.imageSize) {
    _initAnimationControllers(vsync);
    maybeSetAspectRatioOnInit();
  }

  @override
  final List<CropAspectRatio?> allowedAspectRatios;

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
  void onPanAndScale({
    required double scale,
    required Offset offsetDelta,
  }) {
    super.onPanAndScale(scale: scale, offsetDelta: offsetDelta);
    normalize();
  }

  @override
  void onResize({
    required Offset offset,
    required ResizeDirection direction,
  }) {
    super.onResize(offset: offset, direction: direction);

    final points = <Vector2>[];

    switch (direction) {
      case ResizeDirection.toTopLeft:
        points.add(data.cropRect.topLeft.vector2);
        break;
      case ResizeDirection.toTopRight:
        points.add(data.cropRect.topRight.vector2);
        break;
      case ResizeDirection.toBottomLeft:
        points.add(data.cropRect.bottomLeft.vector2);
        break;
      case ResizeDirection.toBottomRight:
        points.add(data.cropRect.bottomRight.vector2);
        break;
      case ResizeDirection.toLeft:
        points.add(data.cropRect.topLeft.vector2);
        points.add(data.cropRect.bottomLeft.vector2);
        break;
      case ResizeDirection.toRight:
        points.add(data.cropRect.topRight.vector2);
        points.add(data.cropRect.bottomRight.vector2);
        break;
      case ResizeDirection.toTop:
        points.add(data.cropRect.topLeft.vector2);
        points.add(data.cropRect.topRight.vector2);
        break;
      case ResizeDirection.toBottom:
        points.add(data.cropRect.bottomLeft.vector2);
        points.add(data.cropRect.bottomRight.vector2);
        break;
    }

    late final Aabb2 aabb;

    if (points.length == 1) {
      aabb = FitPolygonInQuadSolver.solve(
        Polygon2(points),
        data.transformedImageQuad,
      );
    } else {
      aabb = FitPolygonInQuadSolver.solve(
        Polygon2(points),
        data.transformedImageQuad,
      );
    }

    switch (direction) {
      case ResizeDirection.toTopLeft:
        data = data.copyWith(
          cropRect: Rect.fromLTRB(
            aabb.min.x,
            aabb.min.y,
            data.cropRect.right,
            data.cropRect.bottom,
          ),
        );
        break;
      case ResizeDirection.toTopRight:
        data = data.copyWith(
          cropRect: Rect.fromLTRB(
            data.cropRect.left,
            aabb.min.y,
            aabb.max.x,
            data.cropRect.bottom,
          ),
        );
        break;
      case ResizeDirection.toBottomLeft:
        data = data.copyWith(
          cropRect: Rect.fromLTRB(
            aabb.min.x,
            data.cropRect.top,
            data.cropRect.right,
            aabb.max.y,
          ),
        );
        break;
      case ResizeDirection.toBottomRight:
        data = data.copyWith(
          cropRect: Rect.fromLTRB(
            data.cropRect.left,
            data.cropRect.top,
            aabb.max.x,
            aabb.max.y,
          ),
        );
        break;
      case ResizeDirection.toLeft:
        data = data.copyWith(
          cropRect: Rect.fromLTRB(
            aabb.min.x,
            data.cropRect.top,
            data.cropRect.right,
            data.cropRect.bottom,
          ),
        );
        break;
      case ResizeDirection.toRight:
        data = data.copyWith(
          cropRect: Rect.fromLTRB(
            data.cropRect.left,
            data.cropRect.top,
            aabb.max.x,
            data.cropRect.bottom,
          ),
        );
        break;
      case ResizeDirection.toTop:
        data = data.copyWith(
          cropRect: Rect.fromLTRB(
            data.cropRect.left,
            aabb.min.y,
            data.cropRect.right,
            data.cropRect.bottom,
          ),
        );
        break;
      case ResizeDirection.toBottom:
        data = data.copyWith(
          cropRect: Rect.fromLTRB(
            data.cropRect.left,
            data.cropRect.top,
            data.cropRect.right,
            aabb.max.y,
          ),
        );
        break;
    }

    computeStaticCropRectDuringResize();
    setViewportScale(overrideCropRect: staticCropRect);
  }

  @override
  void onResizeEnd() {
    super.onResizeEnd();
    setViewportScaleWithAnimation();
  }

  @override
  void onStraighten({
    required double angleRad,
  }) {
    super.onStraighten(angleRad: angleRad);
    normalize();
    setViewportScale();
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

  @override
  void reset() {
    data = data.copyWith(
      baseTransformations: data.baseTransformations.normalized,
    );

    animatedNormalizeAfterTransform(
      () => super.reset(),
    );
  }

  // TODO: Move this to a mixin
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
}
