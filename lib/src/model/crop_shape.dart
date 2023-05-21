import 'package:croppy/src/src.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:croppy/src/utils/path.dart' as vg;

/// The shape type of a [CropShape].
enum CropShapeType {
  aabb,
  ellipse,
  custom,
}

/// A shape of the crop area. It can be either:
/// - an [Aabb2] (axis-aligned bounding box)
/// - an [Ellipse2]
/// - a [Path]
///
/// The [type] property indicates which of the three it is.
///
/// If the shape type is either [CropShapeType.aabb] or [CropShapeType.ellipse],
/// then an optimized algorithm can be used for calculating the normalized
/// crop rectangle. Otherwise, the [Path] has to be converted to a [Polygon2]
/// first, which is more expensive.
class CropShape extends Equatable {
  const CropShape({
    required this.type,
    required this.path,
    required this.vgPath,
  });

  CropShape.aabb(Aabb2 aabb)
      : type = CropShapeType.aabb,
        path = aabb,
        vgPath = vg.globalPathBuilder.addRect(aabb.rect).toPath();

  CropShape.ellipse(Ellipse2 ellipse)
      : type = CropShapeType.ellipse,
        path = ellipse,
        vgPath =
            vg.globalPathBuilder.addOval(ellipse.boundingBox.rect).toPath();

  const CropShape.custom(vg.Path customPath)
      : type = CropShapeType.custom,
        path = customPath,
        vgPath = customPath;

  final CropShapeType type;
  final dynamic path;

  final vg.Path vgPath;

  Aabb2 get aabb {
    assert(type == CropShapeType.aabb);
    return path as Aabb2;
  }

  Ellipse2 get ellipse {
    assert(type == CropShapeType.ellipse);
    return path as Ellipse2;
  }

  vg.Path get customPath {
    assert(type == CropShapeType.custom);
    return path as vg.Path;
  }

  @override
  List<Object?> get props {
    if (type == CropShapeType.aabb) {
      return [type, aabb.min, aabb.max];
    } else if (type == CropShapeType.ellipse) {
      return [type, ellipse.center, ellipse.radii];
    } else {
      return [type, customPath];
    }
  }

  static CropShape? lerp(CropShape? a, CropShape? b, double t) {
    if (a == null || b == null) return null;

    return CropShape(
      type: t > 0.5 ? b.type : a.type,
      path: t > 0.5 ? b.path : a.path,
      vgPath: t > 0.5 ? b.vgPath : a.vgPath,
    );
  }

  vg.Path getTransformedPath(Offset offset, double scale) {
    final translationTransform = Matrix4.identity()
      ..translate(offset.dx, offset.dy);
    final scaleTransform = Matrix4.identity()..scale(scale);

    final transform = translationTransform * scaleTransform;
    return vgPath.transformed(transform);
  }

  vg.Path getTransformedPathForSize(Size size) {
    late final Rect bounds;

    if (type == CropShapeType.custom) {
      bounds = customPath.toUiPath().getBounds();
    } else if (type == CropShapeType.aabb) {
      bounds = aabb.rect;
    } else {
      bounds = ellipse.boundingBox.rect;
    }

    final scale = size.shortestSide / bounds.shortestSide;
    return getTransformedPath(Offset.zero, scale);
  }

  Polygon2 get polygon {
    if (type == CropShapeType.aabb) {
      return aabb.polygon;
    }

    return vgPath.toApproximatePolygon();
  }
}

/// A function that provides the crop path for a given size.
typedef CropShapeFn = CropShape Function(vg.PathBuilder builder, Size size);

/// A function that provides a rectangular crop path for a given size.
CropShape aabbCropShapeFn(vg.PathBuilder builder, Size size) {
  return CropShape.aabb(
    Aabb2.minMax(Vector2.zero(), Vector2(size.width, size.height)),
  );
}

/// A function that provides an elliptical crop path for a given size.
CropShape ellipseCropShapeFn(vg.PathBuilder builder, Size size) {
  return CropShape.ellipse(
    Ellipse2(
      center: size.center(Offset.zero).vector2,
      radii: Offset(size.width / 2, size.height / 2).vector2,
    ),
  );
}

/// A function that provides a star crop path for a given size.
CropShape starCropShapeFn(vg.PathBuilder builder, Size size) {
  final path = builder
      .moveTo(size.width / 2, 0)
      .lineTo(size.width * 0.6, size.height * 0.4)
      .lineTo(size.width, size.height * 0.4)
      .lineTo(size.width * 0.7, size.height * 0.6)
      .lineTo(size.width * 0.8, size.height)
      .lineTo(size.width / 2, size.height * 0.7)
      .lineTo(size.width * 0.2, size.height)
      .lineTo(size.width * 0.3, size.height * 0.6)
      .lineTo(0, size.height * 0.4)
      .lineTo(size.width * 0.4, size.height * 0.4)
      .close()
      .toPath();

  return CropShape.custom(path);
}
