import 'package:croppy/croppy.dart';

Polygon2 getConvexHullUnion(CroppableImageData data) {
  final quad = data.transformedImageQuad;
  final polygon = data.cropShape.polygon.shift(data.cropRect.topLeft.vector2);

  final unionPolygon = Polygon2([...polygon.vertices, ...quad.vertices]);
  return unionPolygon.computeConvexHull();
}
