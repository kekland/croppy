import 'dart:math';

import 'package:croppy/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoImageTransformationToolbar extends StatelessWidget {
  const CupertinoImageTransformationToolbar({
    super.key,
    required this.controller,
  });

  final CroppableImageController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CupertinoKnobButton(
          onPressed: () => controller.onMirrorHorizontal(),
          isActive: false,
          isPositive: false,
          child: const Icon(
            Icons.flip_rounded,
            size: 16.0,
            color: CupertinoColors.white,
          ),
        ),
        const SizedBox(width: 12.0),
        CupertinoKnobButton(
          onPressed: () => controller.onRotateCCW(),
          isActive: false,
          isPositive: false,
          child: const Icon(
            Icons.rotate_90_degrees_ccw_rounded,
            size: 16.0,
            color: CupertinoColors.white,
          ),
        ),
        const SizedBox(width: 12.0),
        CupertinoKnob(
          value: controller.rotationZ * 180 / pi,
          extent: 45,
          onChanged: (v) {
            controller.onStraighten(angleRad: v);
          },
          inactiveChild: const Icon(
            Icons.straighten_rounded,
            color: CupertinoColors.white,
            size: 16.0,
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: CupertinoRotationSlider(
            value: controller.rotationZ,
            extent: pi / 4,
            onStart: controller.onStraightenStart,
            onEnd: controller.onStraightenEnd,
            onChanged: (v) {
              controller.onStraighten(angleRad: v);
            },
          ),
        ),
      ],
    );
  }
}
