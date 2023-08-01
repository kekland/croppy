import 'dart:typed_data';

import 'package:croppy/src/src.dart';
import 'package:flutter/widgets.dart';

/// A function that is called in [crop] as a post-processing function. Use it
/// to, for example, compress the image, or update the state in the preview
/// page.
typedef CroppableImagePostProcessFn = Future<CropImageResult> Function(
  CropImageResult result,
);

/// A base class for controllers that can be used with this package.
abstract class BaseCroppableImageController extends ChangeNotifier {
  BaseCroppableImageController({
    required this.imageProvider,
    required CroppableImageData data,
    this.postProcessFn,
    this.cropShapeFn = aabbCropShapeFn,
  })  : _data = data.copyWith(),
        _resetData = data.copyWith(),
        _initialData = data.copyWith() {
    recomputeValueNotifiers();
  }

  /// The image provider that represents the image to be cropped.
  final ImageProvider imageProvider;

  /// A function that is called in [crop] as a post-processing function. Use it
  /// to, for example, compress the image, or update the state in the preview
  /// page.
  final CroppableImagePostProcessFn? postProcessFn;

  /// A function that provides the crop path for a given size.
  final CropShapeFn cropShapeFn;

  /// The current crop data.
  CroppableImageData _data;

  /// The current crop data.
  CroppableImageData get data => _data;

  /// Sets the current crop data.
  set data(CroppableImageData newData) {
    if (_data == newData) return;

    _data = newData.copyWithProperCropShape(cropShapeFn: cropShapeFn);

    recomputeValueNotifiers();
    notifyListeners();
  }

  /// The initial crop data that was passed to this controller.
  final CroppableImageData _initialData;

  /// The initial crop data that is used when the controller is reset.
  final CroppableImageData _resetData;

  /// The scale of the viewport.
  double get viewportScale;

  /// The state at the start of a transformation.
  CroppableImageData? transformationInitialData;

  Size? _viewportSize;

  /// Size of the available viewport.
  Size? get viewportSize => _viewportSize;

  /// Whether the controller is currently transforming.
  final isTransformingNotifier = ValueNotifier<bool>(false);

  /// Sets the size of the available viewport.
  @mustCallSuper
  set viewportSize(Size? size) {
    if (_viewportSize == size) return;
    _viewportSize = size;
  }

  /// Sets the size of the available viewport in the [build] method.
  @mustCallSuper
  void setViewportSizeInBuild(Size? size) {
    if (viewportSize == size) return;
    viewportSize = size;
  }

  /// Called when a transformation starts.
  @mustCallSuper
  void onTransformationStart() {
    transformationInitialData = data.copyWith();
    isTransformingNotifier.value = true;
    notifyListeners();
  }

  dynamic lastTransformationArgs;

  /// Called during a transformation.
  @mustCallSuper
  void onTransformation(dynamic args) {
    lastTransformationArgs = args;
    notifyListeners();
  }

  /// Called when a transformation ends.
  @mustCallSuper
  void onTransformationEnd() {
    transformationInitialData = null;
    isTransformingNotifier.value = false;

    data = data.copyWith(
      imageTransform: data.currentImageTransform * data.imageTransform,
      currentImageTransform: Matrix4.identity(),
    );

    notifyListeners();
  }

  /// Called when a base transformation is applied. Implementers can override
  /// this to update the [data] and notify listeners.
  void onBaseTransformation(CroppableImageData newData) {
    data = newData;
    notifyListeners();
  }

  Rect getNormalizedRect(CroppableImageData data) {
    final normalizedAabb = FitPolygonInQuadSolver.solve(
      data.cropShape.polygon.shift(data.cropRect.topLeft.vector2),
      data.transformedImageQuad,
    );

    return normalizedAabb.rect;
  }

  @protected
  Rect normalizeImpl() {
    return getNormalizedRect(data);
  }

  /// Normalizes the crop rect to fit inside the transformed image quad.
  void normalize() {
    data = data.copyWith(cropRect: normalizeImpl());
  }

  /// Returns the transformation matrix that is needed to transform the crop
  /// rect from the current base transformations to the new base
  /// transformations.
  Matrix4 getMatrixForBaseTransformations(
    BaseTransformations newBaseTransformations,
  ) {
    var oldTransform = data.translatedBaseTransformations;
    final newTransform = data
        .copyWith(baseTransformations: newBaseTransformations)
        .translatedBaseTransformations;

    return newTransform * Matrix4.inverted(oldTransform);
  }

  /// Whether the controller can be reset to its initial state, i.e. whether
  /// the image has been transformed.
  final canResetNotifier = ValueNotifier(false);

  /// Whether the current data is different from the initial data.
  final isChangedNotifier = ValueNotifier(false);

  /// Resets the controller to its initial state.
  void reset() {
    data = _resetData;
    notifyListeners();
  }

  /// Recomputes the value notifiers. This is called when the [data] changes.
  @mustCallSuper
  void recomputeValueNotifiers() {
    canResetNotifier.value = data != _resetData;
    isChangedNotifier.value = data != _initialData;
  }

  /// Crops the image and returns the cropped image as a [Uint8List].
  @mustCallSuper
  Future<CropImageResult> crop() async {
    final image = await obtainImage(imageProvider);
    final result = await cropImage(image, data);

    if (postProcessFn != null) {
      return postProcessFn!(result);
    } else {
      return result;
    }
  }
}

/// An abstract controller for images that can be cropped, that provides the
/// different transformations (pan and scale, resize, rotate, etc).
abstract class CroppableImageController extends BaseCroppableImageController
    with
        PanAndScaleTransformation,
        ResizeTransformation,
        StraightenAndPerspectiveTransformation,
        RotateTransformation,
        MirrorTransformation {
  CroppableImageController({
    required super.imageProvider,
    required super.data,
    super.postProcessFn,
    super.cropShapeFn,
    this.enabledTransformations = Transformation.values,
  });

  /// A list of transformations that are enabled.
  final List<Transformation> enabledTransformations;

  /// Whether the given transformation is enabled.
  ///
  /// This is used in the UI to determine whether to show the transformation
  /// button, or whether to accept the gestures.
  bool isTransformationEnabled(Transformation t) {
    return enabledTransformations.contains(t);
  }
}

/// An abstract controller for images with mixins for the different
/// display properties (aspect ratio, resize static layout, viewport scale).
abstract class CroppableImageControllerWithMixins
    extends CroppableImageController
    with AspectRatioMixin, ResizeStaticLayoutMixin, ViewportScaleComputerMixin {
  CroppableImageControllerWithMixins({
    required super.imageProvider,
    required super.data,
    super.postProcessFn,
    super.cropShapeFn,
    super.enabledTransformations,
  });
}
