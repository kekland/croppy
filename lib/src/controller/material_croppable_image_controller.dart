import 'package:croppy/src/src.dart';
import 'package:flutter/material.dart';

class MaterialCroppableImageController
    extends CroppableImageControllerWithMixins with AnimatedControllerMixin {
  MaterialCroppableImageController({
    required TickerProvider vsync,
    required super.imageProvider,
    required super.data,
    super.cropShapeFn,
    super.enabledTransformations,
    super.postProcessFn,
    List<CropAspectRatio?>? allowedAspectRatios,
  }) : allowedAspectRatios =
            allowedAspectRatios ?? _createDefaultAspectRatios(data.imageSize) {
    initAnimationControllers(vsync);
    maybeSetAspectRatioOnInit();
  }

  @override
  final List<CropAspectRatio?> allowedAspectRatios;

  @override
  void onPanAndScale({
    required double scale,
    required Offset offsetDelta,
  }) {
    super.onPanAndScale(scale: scale, offsetDelta: offsetDelta);

    normalize();
    setViewportScale();
  }

  @override
  void onResize({
    required Offset offset,
    required ResizeDirection direction,
  }) {
    super.onResize(offset: offset, direction: direction);

    final newAabb = FitPolygonInQuadSolver.solveWithStaticPointsAndAspectRatio(
      data.cropShape.polygon.shift(data.cropRect.topLeft.vector2),
      data.transformedImageQuad,
      staticCorners: direction.staticCorners,
      aspectRatio: currentAspectRatio?.ratio,
    );

    data = data.copyWith(
      cropRect: newAabb.rect,
    );

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
}

List<CropAspectRatio?> _createDefaultAspectRatios(Size imageSize) {
  return [
    null,
    CropAspectRatio(
      width: imageSize.width.round(),
      height: imageSize.height.round(),
    ),
    CropAspectRatio(
      width: imageSize.height.round(),
      height: imageSize.width.round(),
    ),
    ..._basicAspectRatios,
  ];
}

const _basicAspectRatios = [
  CropAspectRatio(width: 1, height: 1),
  CropAspectRatio(width: 5, height: 4),
  CropAspectRatio(width: 4, height: 5),
  CropAspectRatio(width: 4, height: 3),
  CropAspectRatio(width: 3, height: 4),
  CropAspectRatio(width: 3, height: 2),
  CropAspectRatio(width: 2, height: 3),
  CropAspectRatio(width: 16, height: 9),
  CropAspectRatio(width: 9, height: 16),
];
