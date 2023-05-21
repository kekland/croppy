// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:croppy/src/src.dart';
import 'package:flutter/widgets.dart';

/// A mixin that adds straightening and perspective functionality to a
/// [BaseCroppableImageController].
mixin StraightenAndPerspectiveTransformation on BaseCroppableImageController {
  /// Returns `true` if the user is currently rotating the crop rect.
  bool get isRotatingZ => _isRotatingZ;
  bool _isRotatingZ = false;

  void _performRotation({
    required double anglePrevious,
    required double angleNew,
    required void Function(Matrix4 transform, double angle) rotate,
  }) {
    final transform = Matrix4.identity();

    final pivot = MatrixUtils.transformPoint(
      data.translatedBaseTransformations,
      data.cropRect.center,
    );

    transform.translate(pivot.dx, pivot.dy);
    rotate(transform, angleNew - anglePrevious);
    transform.translate(-pivot.dx, -pivot.dy);

    data = data.copyWith(currentImageTransform: transform);
    onTransformation(angleNew);
  }

  /// Called when the user starts rotating the crop rect around the Z axis.
  @mustCallSuper
  void onStraightenStart() {
    onTransformationStart();
    _isRotatingZ = true;
  }

  /// Called when the user is rotating the crop rect around the Z axis.
  /// This will update the [BaseCroppableImageController.data] and notify listeners.
  void onStraighten({
    required double angleRad,
  }) {
    _performRotation(
      angleNew: angleRad,
      anglePrevious: _computeRotationZ(data.imageTransform),
      rotate: (transform, angle) => transform.rotateZ(angle),
    );
  }

  /// Called when the user stops rotating the crop rect around the Z axis.
  @mustCallSuper
  void onStraightenEnd() {
    _isRotatingZ = false;
    onTransformationEnd();
  }

  /// Returns `true` if the user is currently rotating the crop rect around the
  /// Y axis.
  bool get isRotatingY => _isRotatingY;
  bool _isRotatingY = false;

  /// Called when the user starts rotating the crop rect around the Y axis.
  @mustCallSuper
  void onRotateYStart() {
    onTransformationStart();
    _isRotatingY = true;
  }

  /// Called when the user is rotating the crop rect around the Y axis.
  /// This will update the [BaseCroppableImageController.data] and notify listeners.
  void onRotateY({
    required double angleRad,
  }) {
    data = data.copyWith(
      baseTransformations: data.baseTransformations.copyWith(
        rotationY: angleRad,
      ),
    );

    onTransformation(angleRad);
  }

  /// Called when the user stops rotating the crop rect around the Y axis.
  @mustCallSuper
  void onRotateYEnd() {
    _isRotatingY = false;
    onTransformationEnd();
  }

  /// Returns `true` if the user is currently rotating the crop rect around the
  /// X axis.
  bool get isRotatingX => _isRotatingX;
  bool _isRotatingX = false;

  /// Called when the user starts rotating the crop rect around the X axis.
  @mustCallSuper
  void onRotateXStart() {
    onTransformationStart();
    _isRotatingX = true;
  }

  /// Called when the user is rotating the crop rect around the X axis.
  /// This will update the [BaseCroppableImageController.data] and notify listeners.
  void onRotateX({
    required double angleRad,
  }) {
    data = data.copyWith(
      baseTransformations: data.baseTransformations.copyWith(
        rotationX: angleRad,
      ),
    );

    onTransformation(angleRad);
  }

  /// Called when the user stops rotating the crop rect around the X axis.
  @mustCallSuper
  void onRotateXEnd() {
    _isRotatingX = false;
    onTransformationEnd();
  }

  /// Returns `true` if the user is currently rotating the crop rect in any
  /// direction.
  bool get isRotating => isRotatingX || isRotatingY || isRotatingZ;

  /// The rotation around X axis of the image in radians.
  final rotationXNotifier = ValueNotifier(0.0);

  /// The rotation around Y axis of the image in radians.
  final rotationYNotifier = ValueNotifier(0.0);

  /// The rotation around Z axis of the image in radians.
  final rotationZNotifier = ValueNotifier(0.0);

  Quaternion _computeRotation([Matrix4? transform]) {
    final Matrix4 _transform =
        transform ?? data.currentImageTransform * data.imageTransform;

    return Quaternion.fromRotation(_transform.getRotation());
  }

  /// Computes the current rotation around Z axis of the image in radians.
  double _computeRotationZ([Matrix4? transform]) {
    return _computeRotation(transform).eulerAngles.yaw;
  }

  @override
  void recomputeValueNotifiers() {
    super.recomputeValueNotifiers();

    final rotation = _computeRotation().eulerAngles;

    rotationXNotifier.value = data.baseTransformations.rotationX;
    rotationYNotifier.value = data.baseTransformations.rotationY;
    rotationZNotifier.value = rotation.yaw;
  }

  @override
  void dispose() {
    rotationXNotifier.dispose();
    rotationYNotifier.dispose();
    rotationZNotifier.dispose();
    super.dispose();
  }
}
