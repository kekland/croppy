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
