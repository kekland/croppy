import 'dart:math';

/// Clamps an angle to the range of -pi to pi.
double clampAngle(double angleRad) {
  if (angleRad < -pi) {
    return angleRad + 2 * pi;
  } else if (angleRad > pi) {
    return angleRad - 2 * pi;
  } else {
    return angleRad;
  }
}
