import 'dart:math';

/// Clamps an angle to the range of 0 to 2pi
double clampAngle(double angleRad) {
  return angleRad % (2 * pi);
}
