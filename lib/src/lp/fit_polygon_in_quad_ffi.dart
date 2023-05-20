import 'package:croppy/src/src.dart';
import 'package:croppy/src/ffi/croppy_ffi.dart' as ffi;

class FitPolygonInQuadSolver {
  static Aabb2 solve(Polygon2 polygon, Quad2 quad) {
    // Check if we even need to solve anything first.
    final verticesNotInQuad = <Vector2>[];

    for (final v in polygon.vertices) {
      if (!quad.containsPoint(v)) {
        verticesNotInQuad.add(v);
      }
    }

    // If all vertices are in the quad, we don't need to do anything.
    if (verticesNotInQuad.isEmpty) {
      return polygon.boundingBox;
    }

    late final Quad2 normalizedQuad;

    // Check if the quad is clockwise or counter-clockwise, and force it to be
    // clockwise.
    if (quad.area > 0.0) {
      normalizedQuad = Quad2(
        quad.point0,
        quad.point3,
        quad.point2,
        quad.point1,
      );
    } else {
      normalizedQuad = quad;
    }

    final result = _ffiCassowarySolver(polygon, normalizedQuad);
    return result;
  }

  static Aabb2 _ffiCassowarySolver(Polygon2 polygon, Quad2 normalizedQuad) {
    final points = <double>[];

    for (final v in [...normalizedQuad.vertices, ...polygon.vertices]) {
      points.add(v.x);
      points.add(v.y);
    }

    final resultFfi = ffi.fitPolygonInQuad(points);
    return Aabb2.minMax(
      Vector2(resultFfi.min.x, resultFfi.min.y),
      Vector2(resultFfi.max.x, resultFfi.max.y),
    );
  }
}
