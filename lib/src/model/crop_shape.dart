import 'package:croppy/src/geometry/ellipse2.dart';
import 'package:croppy/src/src.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

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
  });

  const CropShape.aabb(Aabb2 aabb)
      : type = CropShapeType.aabb,
        path = aabb;

  const CropShape.ellipse(Ellipse2 ellipse)
      : type = CropShapeType.ellipse,
        path = ellipse;

  const CropShape.custom(Path customPath)
      : type = CropShapeType.ellipse,
        path = customPath;

  final CropShapeType type;
  final dynamic path;

  Aabb2 get aabb {
    assert(type == CropShapeType.aabb);
    return path as Aabb2;
  }

  Ellipse2 get ellipse {
    assert(type == CropShapeType.ellipse);
    return path as Ellipse2;
  }

  Path get customPath {
    assert(type == CropShapeType.custom);
    return path as Path;
  }

  @override
  List<Object?> get props => [type, path];

  static CropShape? lerp(CropShape? a, CropShape? b, double t) {
    if (a == null || b == null) return null;

    return CropShape(
      type: t > 0.5 ? b.type : a.type,
      path: t > 0.5 ? b.path : a.path,
    );
  }

  Path get asPath {
    if (type == CropShapeType.custom) {
      return customPath;
    } else if (type == CropShapeType.aabb) {
      return Path()..addRect(aabb.rect);
    } else {
      return Path()..addOval(ellipse.boundingBox.rect);
    }
  }

  Path getTransformedPath(Offset offset, double scale) {
    final scaleTransform = Matrix4.identity()..scale(scale);
    return asPath.transform(scaleTransform.storage).shift(offset);
  }

  Path getTransformedPathForSize(Size size) {
    late final Rect bounds;

    if (type == CropShapeType.custom) {
      bounds = customPath.getBounds();
    } else if (type == CropShapeType.aabb) {
      bounds = aabb.rect;
    } else {
      bounds = ellipse.boundingBox.rect;
    }

    final scale = size.shortestSide / bounds.shortestSide;
    return getTransformedPath(Offset.zero, scale);
  }
}

/// A function that provides a rectangular crop path for a given size.
CropShape aabbCropShapeFn(Size size) {
  return CropShape.aabb(
    Aabb2.minMax(Vector2.zero(), Vector2(size.width, size.height)),
  );
}

/// A function that provides an elliptical crop path for a given size.
///
/// Warning: this is currently not implemented fully. The normalization
/// algorithm for elliptical crop shapes is not yet implemented.
CropShape ellipseCropShapeFn(Size size) {
  return CropShape.ellipse(
    Ellipse2(
      center: size.center(Offset.zero).vector2,
      radii: Offset(size.width / 2, size.height / 2).vector2,
    ),
  );
}
