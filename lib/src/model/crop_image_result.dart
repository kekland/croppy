import 'package:croppy/src/src.dart';
import 'dart:ui' as ui;

/// The result of a crop operation.
class CropImageResult {
  const CropImageResult({
    required this.uiImage,
    required this.transformationsData,
  });

  /// The `dart:ui` image.
  final ui.Image uiImage;

  /// The list of transformations applied to the image.
  final CroppableImageData transformationsData;
}
