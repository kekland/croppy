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

  /// Whether this [Quad2] contains the given [point].
  bool containsPoint(Vector2 point) {
    final tri0 = Triangle.points(
      point0.vector3,
      point1.vector3,
      point2.vector3,
    );

    final tri1 = Triangle.points(
      point0.vector3,
      point2.vector3,
      point3.vector3,
    );

    return [tri0, tri1].any(
      (triangle) => triangle.containsPoint(point.vector3),
    );
  }

  /// Transforms this [Quad2] by the given transformation matrix.
  Quad2 transform(Matrix4 t) {
    final quad = Quad.points(
      point0.vector3,
      point1.vector3,
      point2.vector3,
      point3.vector3,
    );

    quad.transform(t);

    return Quad2(
      quad.point0.vector2,
      quad.point1.vector2,
      quad.point2.vector2,
      quad.point3.vector2,
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
}
