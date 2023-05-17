import 'package:croppy/src/src.dart';

class Ellipse2 {
  Ellipse2({
    required this.center,
    required this.radii,
  });

  final Vector2 center;
  final Vector2 radii;

  Aabb2 get boundingBox => Aabb2.minMax(
        center - radii,
        center + radii,
      );
}
