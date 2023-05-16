import 'dart:ui';
import 'package:croppy/src/geometry/_geometry.dart';

/// Some utility methods for working with [Vector2]
extension Vector2Utils on Vector2 {
  /// Converts this [Vector2] to an [Offset].
  Offset get offset => Offset(x, y);

  /// Converts this [Vector2] to a [Vector3]. The z component is set to `0`.
  Vector3 get vector3 => Vector3(x, y, 0);
}

/// Some utility methods for working with [Offset]
extension VectorFromOffset on Offset {
  /// Converts this [Offset] to a [Vector2].
  Vector2 get vector2 => Vector2(dx, dy);

  /// Converts this [Offset] to a [Vector3]. The z component is set to `0`.
  Vector3 get vector3 => Vector3(dx, dy, 0);
}

/// Some utility methods for working with [Vector3]
extension Vector2FromVector3 on Vector3 {
  /// Converts this [Vector3] to a [Vector2]. The z component is discarded.
  Vector2 get vector2 => Vector2(x, y);
}
