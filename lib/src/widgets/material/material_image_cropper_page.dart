import 'package:croppy/src/src.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MaterialImageCropperPage extends StatelessWidget {
  const MaterialImageCropperPage({
    super.key,
    required this.controller,
    required this.shouldPopAfterCrop,
    required this.showGestureHandlesOn,
    this.gesturePadding = 16.0,
    this.heroTag,
    this.themeData,
    this.showLoadingIndicatorOnSubmit = false,
  });

  final CroppableImageController controller;
  final double gesturePadding;
  final Object? heroTag;
  final bool shouldPopAfterCrop;
  final bool showLoadingIndicatorOnSubmit;
  final ThemeData? themeData;
  final List<CropShapeType> showGestureHandlesOn;

  @override
  Widget build(BuildContext context) {
    final theme = themeData ?? generateMaterialImageCropperTheme(context);

    return Theme(
      data: theme,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.black,
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: CroppableImagePageAnimator(
          controller: controller,
          heroTag: heroTag,
          builder: (context, overlayOpacityAnimation) {
            return Scaffold(
              backgroundColor: theme.scaffoldBackgroundColor,
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: RepaintBoundary(
                        child: Padding(
                          padding: const EdgeInsets.all(48.0),
                          child: AnimatedCroppableImageViewport(
                            controller: controller,
                            gesturePadding: gesturePadding,
                            overlayOpacityAnimation: overlayOpacityAnimation,
                            heroTag: heroTag,
                            cropHandlesBuilder: (context) =>
                                MaterialImageCropperHandles(
                              controller: controller,
                              gesturePadding: gesturePadding,
                              showGestureHandlesOn: showGestureHandlesOn,
                            ),
                          ),
                        ),
                      ),
                    ),
                    RepaintBoundary(
                      child: AnimatedBuilder(
                        animation: overlayOpacityAnimation,
                        builder: (context, _) => Opacity(
                          opacity: overlayOpacityAnimation.value,
                          child: MaterialImageCropperToolbar(
                            controller: controller,
                          ),
                        ),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: overlayOpacityAnimation,
                      builder: (context, _) => Opacity(
                        opacity: overlayOpacityAnimation.value,
                        child: MaterialImageCropperBottomAppBar(
                          controller: controller,
                          shouldPopAfterCrop: shouldPopAfterCrop,
                          showLoadingIndicatorOnSubmit:
                              showLoadingIndicatorOnSubmit,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
