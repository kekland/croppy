import 'package:croppy/src/geometry/_geometry.dart';

class LineSegment2 {
  LineSegment2(this.point0, this.point1);

  final Vector2 point0;
  final Vector2 point1;

  /// Returns an intersection point between this and [other], if exists
  Vector2? intersectsWithLineSegment(LineSegment2 other) {
    final p = point0;
    final r = point1 - point0;

    final q = other.point0;
    final s = other.point1 - other.point0;

    final cross = r.cross(s);

    final _t = (q - p).cross(s);
    final t = _t / cross;

    final _u = (q - p).cross(r);
    final u = _u / cross;

    final crossAbs = cross.abs();

    if (crossAbs < epsilon && _u.abs() < epsilon) {
      // Collinear.
      return null;
    }

    if (crossAbs < epsilon && _u.abs() >= epsilon) {
      // Parallel, no intersection
      return null;
    }

    if (crossAbs >= epsilon && t > 0 && t < 1 && u > 0 && u < 1) {
      // Intersection
      return p + r * t;
    }

    // No intersection
    return null;
  }

  bool containsPoint(Vector2 point) {
    final d0 = point1 - point0;
    final d1 = point - point0;

    final dot = d0.dot(d1);
    return dot < epsilon;
  }
}
