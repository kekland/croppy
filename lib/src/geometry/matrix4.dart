import 'package:flutter/widgets.dart';

/// Linearly interpolates between two [Matrix4]s using [Matrix4Tween].
Matrix4 lerpMatrix4(Matrix4? a, Matrix4? b, double t) {
  return Matrix4Tween(begin: a, end: b).lerp(t);
}
