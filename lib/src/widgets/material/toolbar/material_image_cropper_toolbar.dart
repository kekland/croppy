import 'package:croppy/croppy.dart';
import 'package:croppy/src/widgets/material/toolbar/material_rotation_slider.dart';
import 'package:flutter/material.dart';

class MaterialImageCropperToolbar extends StatelessWidget {
  const MaterialImageCropperToolbar({super.key, required this.controller});

  final CroppableImageController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = CroppyLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          if (controller.isTransformationEnabled(Transformation.rotateZ))
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
                      if (controller is MaterialCroppableImageController &&
                          (controller as MaterialCroppableImageController)
                                  .allowedAspectRatios
                                  .length >
                              1) ...[
                        SizedBox.square(
                          dimension: 48.0,
                          child: ValueListenableBuilder(
                            valueListenable:
                                (controller as MaterialCroppableImageController)
                                    .aspectRatioNotifier,
                            builder: (context, ar, _) => IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  clipBehavior: Clip.antiAlias,
                                  builder: (_) =>
                                      CroppyLocalizationProvider.passthrough(
                                    context,
                                    child: MaterialAspectRatioBottomSheet(
                                      controller: controller
                                          as MaterialCroppableImageController,
                                    ),
                                  ),
                                );
                              },
                              isSelected: ar != null,
                              icon: const Icon(Icons.aspect_ratio_rounded),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                      ],
                      if (controller
                          .isTransformationEnabled(Transformation.rotate))
                        SizedBox.square(
                          dimension: 48.0,
                          child: ValueListenableBuilder(
                            valueListenable: controller.baseRotationZNotifier,
                            builder: (context, rotationZ, _) => IconButton(
                              onPressed: () {
                                controller.onRotateCCW();
                              },
                              isSelected: clampAngle(rotationZ) > epsilon,
                              icon: const Icon(
                                Icons.rotate_90_degrees_ccw_rounded,
                              ),
                            ),
                          ),
                        ),
                      // TODO: Perspective transformations
                      // const SizedBox(width: 16.0),
                      // SizedBox.square(
                      //   dimension: 48.0,
                      //   child: IconButton(
                      //     onPressed: () {},
                      //     // TODO: Perspective icon
                      //     icon: const Icon(Icons.transform_rounded),
                      //   ),
                      // ),
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
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 72.0,
                      minHeight: 48.0,
                      maxHeight: 48.0,
                    ),
                    child: TextButton(
                      onPressed: () => controller.reset(),
                      child: Text(l10n.materialResetLabel),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
