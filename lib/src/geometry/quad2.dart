import 'dart:math';
import 'dart:ui';

import 'package:croppy/src/geometry/_geometry.dart';

/// A 2D quadrilateral.
class Quad2 {
  /// Creates a [Quad2] from the given points.
  Quad2(this.point0, this.point1, this.point2, this.point3);

  /// Creates a [Quad2] from a given [size]. The top-left corner is at `(0, 0)`.
  Quad2.fromSize(Size size)
      : this(
          Vector2(0, size.height),
          Vector2(size.width, size.height),
          Vector2(size.width, 0),
          Vector2(0, 0),
        );

  final Vector2 point0;
  final Vector2 point1;
  final Vector2 point2;
  final Vector2 point3;

  /// Returns the bounding box of this [Quad2].
  Aabb2 get boundingBox {
    final xMin = vertices.map((v) => v.x).reduce(min);
    final xMax = vertices.map((v) => v.x).reduce(max);
    final yMin = vertices.map((v) => v.y).reduce(min);
    final yMax = vertices.map((v) => v.y).reduce(max);

    return Aabb2.minMax(
      Vector2(xMin, yMin),
      Vector2(xMax, yMax),
    );
  }

  /// Returns a list of the vertices of this [Quad2].
  List<Vector2> get vertices => [point0, point1, point2, point3];

  Triangle? _cachedTri1;
  Triangle get tri1 {
    if (_cachedTri1 != null) return _cachedTri1!;

    return _cachedTri1 = Triangle.points(
      point0.vector3,
      point1.vector3,
      point2.vector3,
    );
  }

  Triangle? _cachedTri2;
  Triangle get tri2 {
    if (_cachedTri2 != null) return _cachedTri2!;

    return _cachedTri2 = Triangle.points(
      point0.vector3,
      point2.vector3,
      point3.vector3,
    );
  }

  /// Whether this [Quad2] contains the given [point].
  bool containsPoint(Vector2 point) {
    if (tri1.containsPoint(point.vector3)) return true;
    if (tri2.containsPoint(point.vector3)) return true;

    return false;
  }

  /// Transforms this [Quad2] by the given transformation matrix.
  Quad2 transform(Matrix4 t) {
    return Quad2(
      t.perspectiveTransform(point0.vector3).vector2,
      t.perspectiveTransform(point1.vector3).vector2,
      t.perspectiveTransform(point2.vector3).vector2,
      t.perspectiveTransform(point3.vector3).vector2,
    );
  }

  /// Computes the signed area of this [Quad2] using the shoelace formula.
  double get area {
    var area = 0.0;

    for (var i = 0; i < 4; i++) {
      var j = (i + 1) % 4;

      area += vertices[i].x * vertices[j].y;
      area -= vertices[i].y * vertices[j].x;
    }

    return area / 2;
  }

  /// Returns a [Path] representing this [Quad2].
  Path get path {
    final path = Path();

    path.moveTo(point0.x, point0.y);
    path.lineTo(point1.x, point1.y);
    path.lineTo(point2.x, point2.y);
    path.lineTo(point3.x, point3.y);

    path.close();
    return path;
  }

  List<LineSegment2> get lineSegments => [
        LineSegment2(point0, point1),
        LineSegment2(point1, point2),
        LineSegment2(point2, point3),
        LineSegment2(point3, point0),
      ];

  Vector2? intersectsWithLineSegment(LineSegment2 lineSegment) {
    for (final segment in lineSegments) {
      final intersection = segment.intersectsWithLineSegment(lineSegment);
      if (intersection != null) return intersection;
    }

    return null;
  }
}
