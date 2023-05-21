import 'package:croppy/src/src.dart';
import 'package:croppy/src/ffi/croppy_ffi.dart' as ffi;
import 'fit_polygon_in_quad_dart.dart' as web_impl;

List<double> _collectPointList(Polygon2 polygon, Quad2 normalizedQuad) {
  final points = <double>[];

  for (final v in [...normalizedQuad.vertices, ...polygon.vertices]) {
    points.add(v.x);
    points.add(v.y);
  }

  return points;
}

Aabb2 _decodeFfiResult(ffi.Aabb2 resultFfi) {
  return Aabb2.minMax(
    Vector2(resultFfi.min.x, resultFfi.min.y),
    Vector2(resultFfi.max.x, resultFfi.max.y),
  );
}

Aabb2 fitPolygonInQuadImpl(Polygon2 polygon, Quad2 normalizedQuad) {
  if (croppyForceUseCassowaryDartImpl) {
    return web_impl.fitPolygonInQuadImpl(polygon, normalizedQuad);
  }

  final resultFfi = ffi.fitPolygonInQuad(
    _collectPointList(polygon, normalizedQuad),
  );

  return _decodeFfiResult(resultFfi);
}

Aabb2 fitPolygonInQuadOnResizeImpl(
  Polygon2 polygon,
  Quad2 normalizedQuad, {
  required List<Corner> staticCorners,
  double? aspectRatio,
}) {
  if (croppyForceUseCassowaryDartImpl) {
    return web_impl.fitPolygonInQuadOnResizeImpl(
      polygon,
      normalizedQuad,
      staticCorners: staticCorners,
      aspectRatio: aspectRatio,
    );
  }

  final resultFfi = ffi.fitPolygonInQuadOnResize(
    _collectPointList(polygon, normalizedQuad),
    aspectRatio: aspectRatio ?? 0.0,
    isTopLeftStatic: staticCorners.contains(Corner.topLeft),
    isTopRightStatic: staticCorners.contains(Corner.topRight),
    isBottomLeftStatic: staticCorners.contains(Corner.bottomLeft),
    isBottomRightStatic: staticCorners.contains(Corner.bottomRight),
  );

  return _decodeFfiResult(resultFfi);
}
