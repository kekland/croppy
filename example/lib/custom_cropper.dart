// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:croppy/croppy.dart';
import 'package:flutter/material.dart';

Future<CropImageResult?> showCustomCropper(
  BuildContext context,
  ImageProvider imageProvider, {
  CroppableImageData? initialData,
  Object? heroTag,
  Future<CropImageResult> Function(CropImageResult)? onCropped,
}) async {
  // Before pushing the route, prepare the initial data. If it's null, populate
  // it with empty content. This is required for Hero animations.
  final _initialData = initialData ??
      await CroppableImageData.fromImageProvider(
        imageProvider,
      );

  if (context.mounted) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return CustomCropper(
            imageProvider: imageProvider,
            initialData: _initialData,
            heroTag: heroTag,
            onCropped: onCropped,
          );
        },
      ),
    );
  }

  return null;
}

class CustomCropper extends StatelessWidget {
  const CustomCropper({
    super.key,
    required this.imageProvider,
    required this.initialData,
    this.heroTag,
    this.onCropped,
  });

  final ImageProvider imageProvider;
  final CroppableImageData? initialData;
  final Object? heroTag;
  final Future<CropImageResult> Function(CropImageResult)? onCropped;

  @override
  Widget build(BuildContext context) {
    return DefaultCupertinoCroppableImageController(
      imageProvider: imageProvider,
      initialData: initialData,
      postProcessFn: onCropped,
      builder: (context, controller) {
        return CroppableImagePageAnimator(
          controller: controller,
          heroTag: heroTag,
          builder: (context, overlayOpacityAnimation) {
            return Scaffold(
              appBar: AppBar(
                actions: [
                  Builder(
                    builder: (context) => TextButton(
                      child: const Text('Done'),
                      onPressed: () async {
                        // Enable the Hero animations
                        CroppableImagePageAnimator.of(context)
                            ?.setHeroesEnabled(true);

                        // Crop the image
                        final result = await controller.crop();

                        if (context.mounted) {
                          Navigator.of(context).pop(result);
                        }
                      },
                    ),
                  ),
                ],
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: AnimatedCroppableImageViewport(
                    controller: controller,
                    cropHandlesBuilder: (context) =>
                        MaterialImageCropperHandles(
                      controller: controller,
                      gesturePadding: 16.0,
                    ),
                    overlayOpacityAnimation: overlayOpacityAnimation,
                    gesturePadding: 16.0,
                    heroTag: heroTag,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
