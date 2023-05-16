import 'package:croppy/src/geometry/_geometry.dart';

/// Some utility methods for working with [Triangle].
extension TriangleContainsPoint on Triangle {
  /// Whether this [Triangle] contains the given [point].
  bool containsPoint(Vector3 point) {
    final a = point0 - point;
    final b = point1 - point;
    final c = point2 - point;

    final u = b.cross(c);
    final v = c.cross(a);
    final w = a.cross(b);

    if (u.dot(v) < -epsilon) {
      return false;
    }

    if (u.dot(w) < -epsilon) {
      return false;
    }

    return true;
  }
}
