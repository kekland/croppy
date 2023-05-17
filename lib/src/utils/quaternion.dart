import 'dart:math';

import 'package:croppy/src/src.dart';

/// Converts a [Quaternion] to Euler angles.
///
/// https://en.wikipedia.org/wiki/Conversion_between_quaternions_and_Euler_angles
extension ToEulerAngles on Quaternion {
  ({double roll, double yaw, double pitch}) get eulerAngles {
    // roll (x-axis rotation)
    final sinrCosp = 2 * (w * x + y * z);
    final cosrCosp = 1 - 2 * (x * x + y * y);
    final roll = atan2(sinrCosp, cosrCosp);

    // pitch (y-axis rotation)
    final sinp = sqrt(1 + 2 * (w * y - x * z));
    final cosp = sqrt(1 - 2 * (w * y - x * z));
    final pitch = 2 * atan2(sinp, cosp) - pi / 2;

    // yaw (z-axis rotation)
    final sinyCosp = 2 * (w * z + x * y);
    final cosyCosp = 1 - 2 * (y * y + z * z);
    final yaw = atan2(sinyCosp, cosyCosp);

    return (
      pitch: pitch,
      roll: roll,
      yaw: yaw,
    );
  }
}
