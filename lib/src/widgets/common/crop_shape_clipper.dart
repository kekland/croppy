import 'package:croppy/src/src.dart';
import 'package:flutter/widgets.dart';

/// A [CustomClipper] that clips a region to the shape of a [CropShape].
///
/// The [CropShape] is resized to fit the provided [Size].
class CropShapeClipper extends CustomClipper<Path> {
  CropShapeClipper(this.cropShape);

  final CropShape cropShape;

  @override
  Path getClip(Size size) =>
      cropShape.getTransformedPathForSize(size).toUiPath();

  @override
  bool shouldReclip(CropShapeClipper oldClipper) =>
      oldClipper.cropShape != cropShape;
}
