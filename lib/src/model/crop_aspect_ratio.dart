import 'package:equatable/equatable.dart';

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
