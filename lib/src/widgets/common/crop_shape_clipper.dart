import 'package:croppy/src/src.dart';
import 'package:flutter/widgets.dart';

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
