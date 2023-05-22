import 'package:croppy/src/src.dart';
import 'fit_polygon_in_quad_ffi.dart'
    if (dart.library.html) 'fit_polygon_in_quad_dart.dart';

/// If true, the Dart implementation of [fitPolygonInQuadImpl] will be used
/// instead of the C++ implementation.
bool croppyForceUseCassowaryDartImpl = false;

bool _shouldSolve(Polygon2 polygon, Quad2 quad) {
  // Check if we even need to solve anything first.
  final verticesNotInQuad = <Vector2>[];

  for (final v in polygon.vertices) {
    if (!quad.containsPoint(v)) {
      verticesNotInQuad.add(v);
    }
  }

  return verticesNotInQuad.isNotEmpty;
}

Quad2 _normalizeQuad(Quad2 quad) {
  // Check if the quad is clockwise or counter-clockwise, and force it to be
  // clockwise.
  if (quad.area > 0.0) {
    return Quad2(
      quad.point0,
      quad.point3,
      quad.point2,
      quad.point1,
    );
  } else {
    return quad;
  }
}

class FitPolygonInQuadSolver {
  // TODO: Solve for polygon's convex hull instead of the polygon itself.
  static Aabb2 solve(Polygon2 polygon, Quad2 quad) {
    // If all vertices are in the quad, we don't need to do anything.
    if (!_shouldSolve(polygon, quad)) {
      return polygon.boundingBox;
    }

    final normalizedQuad = _normalizeQuad(quad);

    // Use the appropriate implementation:
    // - The FFI (C/C++) implementation is faster, but requires the croppy_ffi
    //   package to be installed. It's not available on the web.
    // - The Dart implementation is slower, but works everywhere.
    return fitPolygonInQuadImpl(polygon, normalizedQuad);
  }

  static Aabb2 solveWithStaticPointsAndAspectRatio(
    Polygon2 polygon,
    Quad2 quad, {
    required List<Corner> staticCorners,
    double? aspectRatio,
  }) {
    final normalizedQuad = _normalizeQuad(quad);

    return fitPolygonInQuadOnResizeImpl(
      polygon,
      normalizedQuad,
      staticCorners: staticCorners,
      aspectRatio: aspectRatio,
    );
  }
}
