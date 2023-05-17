import 'dart:math';

import 'package:croppy/src/src.dart';
import 'package:flutter/widgets.dart';

/// A mixin that adds straightening functionality to a
/// [BaseCroppableImageController].
mixin StraightenTransformation on BaseCroppableImageController {
  /// Returns `true` if the user is currently rotating the crop rect.
  bool get isRotating => _isRotating;
  bool _isRotating = false;

  /// Called when the user starts rotating the crop rect.
  @mustCallSuper
  void onStraightenStart() {
    onTransformationStart();
    _isRotating = true;
  }

  /// Called when the user is rotating the crop rect. This will update the
  /// [BaseCroppableImageController.data] and notify listeners.
  void onStraighten({
    required double angleRad,
  }) {
    final rotation = data.imageTransform.getRotation();
    final angle = atan2(rotation.right.y, rotation.right.x);

    final transform = Matrix4.identity();

    final pivot = MatrixUtils.transformPoint(
      data.translatedBaseTransformations,
      data.cropRect.center,
    );

    transform.translate(pivot.dx, pivot.dy);
    transform.rotateZ(angleRad - angle);
    transform.translate(-pivot.dx, -pivot.dy);

    data = data.copyWith(currentImageTransform: transform);
    notifyListeners();
  }

  /// Called when the user stops rotating the crop rect.
  @mustCallSuper
  void onStraightenEnd() {
    _isRotating = false;
    onTransformationEnd();
  }

  /// The cached rotation around Z axis of the image in radians.
  double? _cachedRotationZ;

  /// Computes the current rotation around Z axis of the image in radians.
  double _computeRotationZ() {
    final Matrix4 transform = data.currentImageTransform * data.imageTransform;
    final rotation = transform.getRotation();
    final angle = atan2(rotation.right.y, rotation.right.x);

    return angle;
  }

  /// Returns the current rotation around Z axis of the image in radians.
  double get rotationZ {
    _cachedRotationZ ??= _computeRotationZ();
    return _cachedRotationZ!;
  }

  @override
  void clearCachedParams() {
    super.clearCachedParams();
    _cachedRotationZ = null;
  }
}
