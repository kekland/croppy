import 'package:croppy/src/src.dart';
import 'package:croppy/src/ffi/croppy_ffi.dart' as ffi;
import 'fit_polygon_in_quad_dart.dart' as web_impl;

Aabb2 fitPolygonInQuadImpl(Polygon2 polygon, Quad2 normalizedQuad) {
  if (croppyForceUseCassowaryDartImpl) {
    return web_impl.fitPolygonInQuadImpl(polygon, normalizedQuad);
  }

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
