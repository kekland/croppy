import 'package:croppy/src/src.dart';
import 'package:flutter/widgets.dart';

/// A mixin for the [CroppableImageController] that allows to keep the aspect
/// ratio of the crop rect.
mixin AspectRatioMixin on CroppableImageController {
  /// Allowed aspect ratios for the aspect ratio toolbar.
  ///
  /// A `null` value means that the crop rect can be resized freely.
  List<CropAspectRatio?> get allowedAspectRatios;

  @override
  void onResize({
    required Offset offsetDelta,
    required ResizeDirection direction,
  }) {
    super.onResize(offsetDelta: offsetDelta, direction: direction);
    if (currentAspectRatio == null) return;

    data = transformationInitialData!.copyWith(
      cropRect: onResizeCorrectAspectRatio(
        rect: data.cropRect,
        direction: direction,
      ),
    );

    notifyListeners();
  }

  /// Corrects the aspect ratio of the given [rect] according to the given
  /// [direction] during resizing.
  Rect onResizeCorrectAspectRatio({
    required Rect rect,
    required ResizeDirection direction,
  }) {
    if (currentAspectRatio == null) return rect;

    final ar = currentAspectRatio!.ratio;

    late final Rect correctedRect;
    switch (direction) {
      case ResizeDirection.toTop:
        final pivot = rect.bottomCenter;
        final height = rect.height;
        final width = height * ar;

        correctedRect = Rect.fromLTRB(
          pivot.dx - width / 2,
          pivot.dy - height,
          pivot.dx + width / 2,
          pivot.dy,
        );

        break;
      case ResizeDirection.toBottom:
        final pivot = rect.topCenter;
        final height = rect.height;
        final width = height * ar;

        correctedRect = Rect.fromLTRB(
          pivot.dx - width / 2,
          pivot.dy,
          pivot.dx + width / 2,
          pivot.dy + height,
        );

        break;
      case ResizeDirection.toLeft:
        final pivot = rect.centerRight;
        final width = rect.width;
        final height = width / ar;

        correctedRect = Rect.fromLTRB(
          pivot.dx - width,
          pivot.dy - height / 2,
          pivot.dx,
          pivot.dy + height / 2,
        );

        break;
      case ResizeDirection.toRight:
        final pivot = rect.centerLeft;
        final width = rect.width;
        final height = width / ar;

        correctedRect = Rect.fromLTRB(
          pivot.dx,
          pivot.dy - height / 2,
          pivot.dx + width,
          pivot.dy + height / 2,
        );

        break;
      case ResizeDirection.toTopLeft:
        final pivot = rect.bottomRight;
        final width = rect.width;
        final height = width / ar;

        correctedRect = Rect.fromLTRB(
          pivot.dx - width,
          pivot.dy - height,
          pivot.dx,
          pivot.dy,
        );

        break;
      case ResizeDirection.toTopRight:
        final pivot = rect.bottomLeft;
        final width = rect.width;
        final height = width / ar;

        correctedRect = Rect.fromLTRB(
          pivot.dx,
          pivot.dy - height,
          pivot.dx + width,
          pivot.dy,
        );

        break;
      case ResizeDirection.toBottomLeft:
        final pivot = rect.topRight;
        final width = rect.width;
        final height = width / ar;

        correctedRect = Rect.fromLTRB(
          pivot.dx - width,
          pivot.dy,
          pivot.dx,
          pivot.dy + height,
        );

        break;
      case ResizeDirection.toBottomRight:
        final pivot = rect.topLeft;
        final width = rect.width;
        final height = width / ar;

        correctedRect = Rect.fromLTRB(
          pivot.dx,
          pivot.dy,
          pivot.dx + width,
          pivot.dy + height,
        );

        break;
    }

    return correctedRect;
  }

  /// Sets the current aspect ratio.
  @mustCallSuper
  set currentAspectRatio(CropAspectRatio? newAspectRatio) {
    if (aspectRatioNotifier.value == newAspectRatio) return;

    aspectRatioNotifier.value = newAspectRatio;
    final newCropRect = resizeCropRectWithAspectRatio(
      data.cropRect,
      newAspectRatio,
    );

    data = data.copyWith(cropRect: newCropRect);
    normalize();

    notifyListeners();
  }

  CropAspectRatio? get currentAspectRatio => aspectRatioNotifier.value;

  /// The aspect ratio notifier.
  final aspectRatioNotifier = ValueNotifier<CropAspectRatio?>(null);

  /// Sets the aspect ratio to the first allowed aspect ratio if the current
  /// aspect ratio is not allowed.
  void maybeSetAspectRatioOnInit() {
    // If the current aspect ratio is not allowed, set it to the first allowed
    // aspect ratio.
    if (!allowedAspectRatios.contains(currentAspectRatio)) {
      aspectRatioNotifier.value = allowedAspectRatios.first;

      final newCropRect = resizeCropRectWithAspectRatio(
        data.cropRect,
        allowedAspectRatios.first,
      );

      data = data.copyWith(cropRect: newCropRect);
      normalize();
    }
  }

  @override
  void onBaseTransformation(CroppableImageData newData) {
    final newCropRect = resizeCropRectWithAspectRatio(
      newData.cropRect,
      currentAspectRatio,
    );

    final modifiedData = newData.copyWith(cropRect: newCropRect);
    super.onBaseTransformation(
      modifiedData.copyWith(cropRect: getNormalizedRect(modifiedData)),
    );
  }

  @override
  void dispose() {
    aspectRatioNotifier.dispose();
    super.dispose();
  }
}
