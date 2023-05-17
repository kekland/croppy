import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

/// A crop aspect ratio.
///
/// The aspect ratio is defined as [width] / [height].
/// 
/// If this is `null`, the crop rect can be resized freely.
class CropAspectRatio extends Equatable {
  const CropAspectRatio({
    required this.width,
    required this.height,
  });

  final int width;
  final int height;

  bool get isHorizontal => width > height;
  bool get isSquare => width == height;

  double get ratio => width / height;

  CropAspectRatio get complement => CropAspectRatio(
        width: height,
        height: width,
      );

  @override
  List<Object?> get props => [width, height];
}

/// A list of basic aspect ratios.
const basicAspectRatios = [
  CropAspectRatio(width: 1, height: 1),
  CropAspectRatio(width: 16, height: 9),
  CropAspectRatio(width: 9, height: 16),
  CropAspectRatio(width: 5, height: 4),
  CropAspectRatio(width: 4, height: 5),
  CropAspectRatio(width: 7, height: 5),
  CropAspectRatio(width: 5, height: 7),
  CropAspectRatio(width: 4, height: 3),
  CropAspectRatio(width: 3, height: 4),
  CropAspectRatio(width: 5, height: 3),
  CropAspectRatio(width: 3, height: 5),
  CropAspectRatio(width: 3, height: 2),
  CropAspectRatio(width: 2, height: 3),
];

List<CropAspectRatio?> createDefaultAspectRatios(Size imageSize) {
  return [
    CropAspectRatio(
      width: imageSize.width.round(),
      height: imageSize.height.round(),
    ),
    CropAspectRatio(
      width: imageSize.height.round(),
      height: imageSize.width.round(),
    ),
    null,
    ...basicAspectRatios,
  ];
}
