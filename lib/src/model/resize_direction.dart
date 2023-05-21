import 'package:croppy/croppy.dart';

/// Enum for the direction of a resize.
///
/// Example: [toBottomLeft] means that the top-right corner of the rectangle is
/// fixed and the bottom-left corner is moved.
enum ResizeDirection {
  toLeft([Corner.topRight, Corner.bottomRight]),
  toRight([Corner.topLeft, Corner.bottomLeft]),
  toTop([Corner.bottomLeft, Corner.bottomRight]),
  toBottom([Corner.topLeft, Corner.topRight]),
  toTopLeft([Corner.bottomRight]),
  toTopRight([Corner.bottomLeft]),
  toBottomLeft([Corner.topRight]),
  toBottomRight([Corner.topLeft]);

  const ResizeDirection(this.staticCorners);

  /// The points that are not moved.
  final List<Corner> staticCorners;
}
