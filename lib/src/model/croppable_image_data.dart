import 'package:croppy/src/src.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:croppy/src/utils/path.dart' as vg;

@immutable
class CroppableImageData extends Equatable {
  const CroppableImageData({
    required this.imageSize,
    required this.cropRect,
    required this.cropShape,
    required this.baseTransformations,
    required this.imageTransform,
    required this.currentImageTransform,
  });

  CroppableImageData.initial({
    required this.imageSize,
    required this.cropShape,
  })  : cropRect = Rect.fromLTWH(0, 0, imageSize.width, imageSize.height),
        imageTransform = Matrix4.identity(),
        currentImageTransform = Matrix4.identity(),
        baseTransformations = const BaseTransformations.initial();

  CroppableImageData.initialWithCropPathFn({
    required this.imageSize,
    required CropShapeFn cropPathFn,
  })  : cropRect = Rect.fromLTWH(0, 0, imageSize.width, imageSize.height),
        cropShape = cropPathFn(
          vg.globalPathBuilder,
          imageSize,
        ),
        imageTransform = Matrix4.identity(),
        currentImageTransform = Matrix4.identity(),
        baseTransformations = const BaseTransformations.initial();

  static Future<CroppableImageData> fromImageProvider(
    ImageProvider imageProvider, {
    CropShapeFn cropPathFn = aabbCropShapeFn,
  }) async {
    final image = await obtainImage(imageProvider);
    return CroppableImageData.initialWithCropPathFn(
      imageSize: Size(
        image.width.toDouble(),
        image.height.toDouble(),
      ),
      cropPathFn: cropPathFn,
    );
  }

  /// The size of the image to be cropped.
  final Size imageSize;

  /// The rectangle containing the crop area.
  final Rect cropRect;

  /// The shape of the crop area.
  final CropShape cropShape;

  /// The "base" transformation applied to the image.
  ///
  /// - 90-degree rotations
  /// - Flips
  /// - Perspective transformations
  final BaseTransformations baseTransformations;

  /// The transformation applied to the image.
  final Matrix4 imageTransform;

  /// The inverse of [imageTransform].
  Matrix4 get inverseImageTransform => Matrix4.inverted(imageTransform);

  /// The current in-progress transformation applied to the image.
  ///
  /// This is set to [Matrix.identity] once a transformation is finished.
  final Matrix4 currentImageTransform;

  /// Translates the given [transformation] to the center of the image.
  Matrix4 translateTransformation(Matrix4 transformation) {
    return Matrix4.copy(transformation)
      ..leftTranslate(
        imageSize.width / 2,
        imageSize.height / 2,
      )
      ..translate(
        -imageSize.width / 2,
        -imageSize.height / 2,
      );
  }

  /// Returns the base transformation matrix, translated to the center of the
  /// image.
  Matrix4 get translatedBaseTransformations =>
      translateTransformation(baseTransformations.matrix);

  /// The total transformation applied to the image.
  Matrix4 get totalImageTransform =>
      translatedBaseTransformations * currentImageTransform * imageTransform;

  /// The original quad of the image, before any transformations are applied.
  Quad2 get originalImageQuad => Quad2.fromSize(imageSize);

  /// The transformed quad of the image.
  Quad2 get transformedImageQuad =>
      originalImageQuad.transform(totalImageTransform);

  /// An axis-aligned bounding box of the crop area.
  Aabb2 get cropAabb => cropRect.aabb2;

  /// Whether the crop area is normalized.
  bool get isNormalized {
    for (final v in cropAabb.vertices) {
      if (!transformedImageQuad.containsPoint(v)) {
        return false;
      }
    }

    return true;
  }

  /// Copies this [CroppableImageData] with the given parameters.
  CroppableImageData copyWith({
    Size? imageSize,
    Rect? cropRect,
    CropShape? cropShape,
    BaseTransformations? baseTransformations,
    Matrix4? imageTransform,
    Matrix4? currentImageTransform,
  }) {
    return CroppableImageData(
      imageSize: imageSize ?? this.imageSize,
      cropRect: cropRect ?? this.cropRect,
      cropShape: cropShape ?? this.cropShape,
      imageTransform: imageTransform ?? this.imageTransform,
      currentImageTransform:
          currentImageTransform ?? this.currentImageTransform,
      baseTransformations: baseTransformations ?? this.baseTransformations,
    );
  }

  /// Copies this [CroppableImageData] with the given parameters and
  /// automatically sets the proper crop shape.
  CroppableImageData copyWithProperCropShape({
    Size? imageSize,
    Rect? cropRect,
    BaseTransformations? baseTransformations,
    Matrix4? imageTransform,
    Matrix4? currentImageTransform,
    required CropShapeFn cropShapeFn,
  }) {
    return copyWith(
      imageSize: imageSize ?? this.imageSize,
      cropRect: cropRect ?? this.cropRect,
      imageTransform: imageTransform ?? this.imageTransform,
      currentImageTransform:
          currentImageTransform ?? this.currentImageTransform,
      baseTransformations: baseTransformations ?? this.baseTransformations,
      cropShape: cropShapeFn(
        vg.globalPathBuilder,
        (cropRect ?? this.cropRect).size,
      ),
    );
  }

  /// Linearly interpolates between two [CroppableImageData]s.
  static CroppableImageData? lerp(
    CroppableImageData? a,
    CroppableImageData? b,
    double t,
  ) {
    if (a == null || b == null) return null;

    return CroppableImageData(
      imageSize: Size.lerp(a.imageSize, b.imageSize, t)!,
      cropRect: Rect.lerp(a.cropRect, b.cropRect, t)!,
      cropShape: CropShape.lerp(a.cropShape, b.cropShape, t)!,
      baseTransformations: BaseTransformations.lerp(
        a.baseTransformations,
        b.baseTransformations,
        t,
      )!,
      imageTransform: lerpMatrix4(a.imageTransform, b.imageTransform, t),
      currentImageTransform:
          lerpMatrix4(a.currentImageTransform, b.currentImageTransform, t),
    );
  }

  @override
  List<Object?> get props => [
        imageSize,
        cropRect,
        cropShape,
        baseTransformations,
        imageTransform.storage,
        currentImageTransform.storage,
      ];
}

/// A tween that interpolates between two [CroppableImageData]s.
class CroppableImageDataTween extends Tween<CroppableImageData> {
  CroppableImageDataTween({super.begin, super.end});

  @override
  CroppableImageData lerp(double t) {
    return CroppableImageData.lerp(begin, end, t)!;
  }
}
