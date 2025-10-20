import 'dart:math';
import 'dart:ui';

import 'package:croppy/src/geometry/_geometry.dart';
import 'package:equatable/equatable.dart';

/// A set of base transformations that can be applied to an image.
class BaseTransformations extends Equatable {
  const BaseTransformations({
    required this.rotationX,
    required this.rotationY,
    required this.rotationZ,
    required this.scaleX,
    required this.scaleY,
    required this.perspectiveDepth,
  });

  BaseTransformations.initial(Size imageSize)
      : this(
          rotationX: 0,
          rotationY: 0,
          rotationZ: 0,
          scaleX: 1,
          scaleY: 1,
          perspectiveDepth: 0.001 / (imageSize.longestSide / 1000.0),
        );

  final double rotationX;
  final double rotationY;
  final double rotationZ;
  final double scaleX;
  final double scaleY;

  /// Perspective depth is computed as follows:
  /// For an image with width W and height H:
  /// - dimension = max(W, H)
  /// - depth = 0.001 / (dimension / 1000)
  /// 
  /// This ensures that larger images have a smaller perspective effect,
  /// while smaller images have a more pronounced effect. As a result,
  /// the perspective effect appears consistent across different image sizes.
  final double perspectiveDepth;

  /// Returns a [Matrix4] representing all of the transformations.
  Matrix4 get matrix => scaleMatrix * rotationMatrix;

  /// Returns a [Matrix4] representing the rotation transformations.
  Matrix4 get rotationMatrix {
    final matrix = Matrix4.identity();
    matrix.setEntry(3, 2, perspectiveDepth);
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
    double? perspectiveDepth,
  }) {
    return BaseTransformations(
      rotationX: rotationX ?? this.rotationX,
      rotationY: rotationY ?? this.rotationY,
      rotationZ: rotationZ ?? this.rotationZ,
      scaleX: scaleX ?? this.scaleX,
      scaleY: scaleY ?? this.scaleY,
      perspectiveDepth: perspectiveDepth ?? this.perspectiveDepth,
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
      perspectiveDepth: lerpDouble(a.perspectiveDepth, b.perspectiveDepth, t)!,
    );
  }

  @override
  List<Object?> get props => [
        rotationX,
        rotationY,
        rotationZ,
        scaleX,
        scaleY,
        perspectiveDepth,
      ];
}
