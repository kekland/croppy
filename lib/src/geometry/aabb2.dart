import 'package:flutter/widgets.dart';
import 'package:croppy/src/geometry/_geometry.dart';

/// Some utility methods for working with [Aabb2].
extension Aabb2Utils on Aabb2 {
  /// Returns a list of the vertices of this [Aabb2].
  List<Vector2> get vertices => [
        Vector2(min.x, min.y),
        Vector2(max.x, min.y),
        Vector2(max.x, max.y),
        Vector2(min.x, max.y),
      ];

  /// Converts this [Aabb2] to a [Rect].
  Rect get rect => Rect.fromLTRB(
        min.x,
        min.y,
        max.x,
        max.y,
      );

  Polygon2 get polygon => Polygon2(vertices);
}

/// Some utility methods for working with [Rect] and [Aabb2].
extension RectToAabb2 on Rect {
  /// Converts this [Rect] to an [Aabb2].
  Aabb2 get aabb2 => Aabb2.minMax(
        Vector2(left, top),
        Vector2(right, bottom),
      );
}

extension RectTransform on Rect {
  Rect transform(Matrix4 t) {
    return MatrixUtils.transformRect(t, this);
  }
}

extension SizeArea on Size {
  double get area => width * height;
}
