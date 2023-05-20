import 'package:croppy/croppy.dart';
import 'package:croppy/src/widgets/material/toolbar/material_rotation_slider.dart';
import 'package:flutter/material.dart';

class MaterialImageCropperToolbar extends StatelessWidget {
  const MaterialImageCropperToolbar({super.key, required this.controller});

  final CroppableImageController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            MaterialRotationSlider(
              controller: controller,
            ),
            Stack(
              children: [
                Center(
                  child: SizedBox(
                    height: 48.0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox.square(
                          dimension: 48.0,
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.aspect_ratio_rounded),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        SizedBox.square(
                          dimension: 48.0,
                          child: ValueListenableBuilder(
                            valueListenable: controller.baseRotationZNotifier,
                            builder: (context, rotationZ, _) => IconButton(
                              onPressed: () {
                                controller.onRotateCCW();
                              },
                              color: clampAngle(rotationZ) > epsilon
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                              icon: const Icon(
                                Icons.rotate_90_degrees_ccw_rounded,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        SizedBox.square(
                          dimension: 48.0,
                          child: IconButton(
                            onPressed: () {},
                            // TODO: Perspective icon
                            icon: const Icon(Icons.transform_rounded),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ValueListenableBuilder(
                    valueListenable: controller.canResetNotifier,
                    builder: (context, canReset, child) => AnimatedOpacity(
                      opacity: canReset ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: IgnorePointer(
                        ignoring: !canReset,
                        child: child,
                      ),
                    ),
                    child: SizedBox(
                      width: 72.0,
                      height: 48.0,
                      child: TextButton(
                        onPressed: () => controller.reset(),
                        child: const Text('Reset'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
