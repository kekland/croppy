import 'dart:math';

import 'package:croppy/src/src.dart';

class Polygon2 {
  const Polygon2(this.vertices);

  final List<Vector2> vertices;

  Aabb2 get boundingBox {
    final minX = vertices.map((v) => v.x).reduce(min);
    final maxX = vertices.map((v) => v.x).reduce(max);
    final minY = vertices.map((v) => v.y).reduce(min);
    final maxY = vertices.map((v) => v.y).reduce(max);

    return Aabb2.minMax(
      Vector2(minX, minY),
      Vector2(maxX, maxY),
    );
  }

  Polygon2 shift(Vector2 d) {
    return Polygon2(vertices.map((v) => v + d).toList());
  }

  List<LineSegment2> get lineSegments {
    final segments = <LineSegment2>[];

    for (var i = 0; i < vertices.length; i++) {
      final j = (i + 1) % vertices.length;
      segments.add(LineSegment2(vertices[i], vertices[j]));
    }

    return segments;
  }

  /// Computes the convex hull of this polygon
  Polygon2 computeConvexHull() {
    final vertices = this.vertices.toList();

    // Sort vertices by x coordinate
    vertices.sort((a, b) => a.x.compareTo(b.x));

    // Compute the upper hull
    final upper = <Vector2>[];
    for (final p in vertices) {
      while (upper.length >= 2) {
        final q = upper[upper.length - 1];
        final r = upper[upper.length - 2];

        if ((q - r).cross(p - r) <= 0) {
          upper.removeLast();
        } else {
          break;
        }
      }

      upper.add(p);
    }

    // Compute the lower hull
    final lower = <Vector2>[];
    for (var i = vertices.length - 1; i >= 0; i--) {
      final p = vertices[i];
      while (lower.length >= 2) {
        final q = lower[lower.length - 1];
        final r = lower[lower.length - 2];

        if ((q - r).cross(p - r) <= 0) {
          lower.removeLast();
        } else {
          break;
        }
      }

      lower.add(p);
    }

    // Remove the last point of each list, since it's the same as the first
    upper.removeLast();
    lower.removeLast();

    // Concatenate the two lists
    final hull = <Vector2>[];
    hull.addAll(upper);
    hull.addAll(lower);

    return Polygon2(hull);
  }

  /// Computes the area of this polygon
  double computeArea() {
    var area = 0.0;

    for (var i = 0; i < vertices.length; i++) {
      final j = (i + 1) % vertices.length;

      final p = vertices[i];
      final q = vertices[j];

      area += p.cross(q);
    }

    return area / 2;
  }
}
