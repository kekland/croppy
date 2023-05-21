import 'package:croppy/src/src.dart';
import 'package:flutter/widgets.dart';

/// Linearly interpolates between two [Matrix4]s using [Matrix4Tween].
Matrix4 lerpMatrix4(Matrix4? a, Matrix4? b, double t) {
  return Matrix4Tween(begin: a, end: b).lerp(t);
}

/// Computes an adjugate matrix.
Matrix3 matrix3Adj(Matrix3 m) {
  return Matrix3(
    m[4] * m[8] - m[5] * m[7],
    m[2] * m[7] - m[1] * m[8],
    m[1] * m[5] - m[2] * m[4],
    m[5] * m[6] - m[3] * m[8],
    m[0] * m[8] - m[2] * m[6],
    m[2] * m[3] - m[0] * m[5],
    m[3] * m[7] - m[4] * m[6],
    m[1] * m[6] - m[0] * m[7],
    m[0] * m[4] - m[1] * m[3],
  );
}
