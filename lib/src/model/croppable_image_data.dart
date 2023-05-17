import 'dart:math';
import 'dart:ui';

import 'package:croppy/src/src.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

@immutable
class CroppableImageData extends Equatable {
  const CroppableImageData({
    required this.imageSize,
    required this.cropRect,
    required this.cropShape,
    required this.imageTransform,
    required this.currentImageTransform,
    required this.baseTransformations,
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
        cropShape = cropPathFn(imageSize),
        imageTransform = Matrix4.identity(),
        currentImageTransform = Matrix4.identity(),
        baseTransformations = const BaseTransformations.initial();

  /// The size of the image to be cropped.
  final Size imageSize;

  /// The rectangle containing the crop area.
  final Rect cropRect;

  /// The shape of the crop area.
  final CropShape cropShape;

  /// The transformation applied to the image.
  final Matrix4 imageTransform;

  /// The inverse of [imageTransform].
  Matrix4 get inverseImageTransform => Matrix4.inverted(imageTransform);

  /// The current in-progress transformation applied to the image.
  ///
  /// This is set to [Matrix.identity] once a transformation is finished.
  final Matrix4 currentImageTransform;

  /// The "base" transformation applied to the image.
  ///
  /// This is the transformation that is applied to the image before any other
  /// transformations are applied. For example:
  ///
  /// - 90-degree rotations
  /// - Flips
  /// - Perspective transformations
  final BaseTransformations baseTransformations;

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

  /// Copies this [CroppableImageData] with the given parameters.
  CroppableImageData copyWith({
    Size? imageSize,
    Rect? cropRect,
    CropShape? cropShape,
    Matrix4? imageTransform,
    Matrix4? currentImageTransform,
    BaseTransformations? baseTransformations,
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
      imageTransform: lerpMatrix4(a.imageTransform, b.imageTransform, t),
      currentImageTransform:
          lerpMatrix4(a.currentImageTransform, b.currentImageTransform, t),
      baseTransformations: BaseTransformations.lerp(
        a.baseTransformations,
        b.baseTransformations,
        t,
      )!,
    );
  }

  @override
  List<Object?> get props => [
        imageSize,
        cropRect,
        cropShape,
        imageTransform,
        currentImageTransform,
        baseTransformations,
      ];
}

/// A set of base transformations that can be applied to an image.
class BaseTransformations extends Equatable {
  const BaseTransformations({
    required this.rotationX,
    required this.rotationY,
    required this.rotationZ,
    required this.scaleX,
    required this.scaleY,
  });

  const BaseTransformations.initial()
      : this(rotationX: 0, rotationY: 0, rotationZ: 0, scaleX: 1, scaleY: 1);

  final double rotationX;
  final double rotationY;
  final double rotationZ;
  final double scaleX;
  final double scaleY;

  /// Returns a [Matrix4] representing all of the transformations.
  Matrix4 get matrix => scaleMatrix * rotationMatrix;

  /// Returns a [Matrix4] representing the rotation transformations.
  Matrix4 get rotationMatrix {
    final matrix = Matrix4.identity();
    matrix.setEntry(3, 2, 0.001);
    matrix.rotateZ(rotationZ);
    matrix.rotateY(rotationY);
    matrix.rotateX(rotationX);
    return matrix;
  }

  /// Returns a [Matrix4] representing the scale transformations.
  Matrix4 get scaleMatrix {
    final matrix = Matrix4.identity();
    matrix.scale(scaleX, scaleY);
    return matrix;
  }

  /// Copies this [BaseTransformations] with the given parameters.
  BaseTransformations copyWith({
    double? rotationX,
    double? rotationY,
    double? rotationZ,
    double? scaleX,
    double? scaleY,
  }) {
    return BaseTransformations(
      rotationX: rotationX ?? this.rotationX,
      rotationY: rotationY ?? this.rotationY,
      rotationZ: rotationZ ?? this.rotationZ,
      scaleX: scaleX ?? this.scaleX,
      scaleY: scaleY ?? this.scaleY,
    );
  }

  /// Returns a copy of this [BaseTransformations] with all of the rotation
  /// values normalized to be between 0 and 2π.
  BaseTransformations get normalized {
    return copyWith(
      rotationX: rotationX % (2 * pi),
      rotationY: rotationY % (2 * pi),
      rotationZ: rotationZ % (2 * pi),
    );
  }

  /// Linearly interpolates between two [BaseTransformations]s.
  static BaseTransformations? lerp(
    BaseTransformations? a,
    BaseTransformations? b,
    double t,
  ) {
    if (a == null || b == null) return null;

    return BaseTransformations(
      rotationX: lerpDouble(a.rotationX, b.rotationX, t)!,
      rotationY: lerpDouble(a.rotationY, b.rotationY, t)!,
      rotationZ: lerpDouble(a.rotationZ, b.rotationZ, t)!,
      scaleX: lerpDouble(a.scaleX, b.scaleX, t)!,
      scaleY: lerpDouble(a.scaleY, b.scaleY, t)!,
    );
  }

  @override
  List<Object?> get props => [
        rotationX,
        rotationY,
        rotationZ,
        scaleX,
        scaleY,
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
