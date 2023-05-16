import 'dart:typed_data';

import 'package:croppy/src/src.dart';
import 'package:flutter/widgets.dart';

/// A base class for controllers that can be used with this package.
abstract class BaseCroppableImageController extends ChangeNotifier {
  BaseCroppableImageController({
    required this.imageProvider,
    required CroppableImageData data,
  }) : data = data.copyWith();

  /// The image provider that represents the image to be cropped.
  final ImageProvider imageProvider;

  /// The current crop data.
  CroppableImageData data;

  /// The scale of the viewport.
  double get viewportScale;

  CroppableImageData? transformationInitialData;

  Size? _viewportSize;

  /// Size of the available viewport.
  Size? get viewportSize => _viewportSize;

  /// Sets the size of the available viewport.
  @mustCallSuper
  set viewportSize(Size? size) {
    if (_viewportSize == size) return;
    _viewportSize = size;
  }

  /// Called when a transformation starts.
  @mustCallSuper
  void onTransformationStart() {
    transformationInitialData = data.copyWith();
    notifyListeners();
  }

  /// Called when a transformation ends.
  @mustCallSuper
  void onTransformationEnd() {
    transformationInitialData = null;
    data = data.copyWith(
      imageTransform: data.currentImageTransform * data.imageTransform,
      currentImageTransform: Matrix4.identity(),
    );

    normalize();
    notifyListeners();
  }

  void normalize() {
    final normalizedAabb = FitAabbInQuadSolver.solve(
      data.cropAabb,
      data.transformedImageQuad,
    );

    data = data.copyWith(cropRect: normalizedAabb.rect);
  }

  Matrix4 getMatrixForBaseTransformations(
    BaseTransformations newBaseTransformations,
  ) {
    final oldTransform = data.translatedBaseTransformations;
    final newTransform = data.translateTransformation(
      newBaseTransformations.matrix,
    );

    return newTransform * Matrix4.inverted(oldTransform);
  }

  /// Crops the image and returns the cropped image as a [Uint8List].
  @mustCallSuper
  Future<Uint8List> crop() async {
    throw UnimplementedError();
  }
}

/// An abstract controller for images that can be cropped, that provides the
/// different transformations (pan and scale, resize, rotate, etc).
abstract class CroppableImageController extends BaseCroppableImageController
    with
        PanAndScaleTransformation,
        ResizeTransformation,
        StraightenTransformation,
        RotateTransformation,
        MirrorTransformation {
  CroppableImageController({
    required ImageProvider imageProvider,
    required CroppableImageData data,
  }) : super(imageProvider: imageProvider, data: data);
}
