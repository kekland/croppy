import 'package:croppy/src/src.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MaterialImageCropperPage extends StatelessWidget {
  const MaterialImageCropperPage({
    super.key,
    required this.controller,
    this.gesturePadding = 16.0,
    this.heroTag,
  });

  final CroppableImageController controller;
  final double gesturePadding;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    final outerTheme = Theme.of(context);
    return Theme(
      data: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: outerTheme.primaryColor,
          primary: outerTheme.primaryColor,
          brightness: Brightness.dark,
        ),
        textTheme: outerTheme.textTheme,
        useMaterial3: outerTheme.useMaterial3,
      ),
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
              backgroundColor: Colors.black,
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: RepaintBoundary(
                        child: Padding(
                          padding: const EdgeInsets.all(48.0),
                          child: CroppableImageViewport(
                            controller: controller,
                            gesturePadding: gesturePadding,
                            heroTag: heroTag,
                            heroChild: ListenableBuilder(
                              listenable: controller,
                              builder: (context, _) => CroppedHeroImageWidget(
                                controller: controller,
                                child: Image(image: controller.imageProvider),
                              ),
                            ),
                            child: AnimatedBuilder(
                              animation: overlayOpacityAnimation,
                              builder: (context, _) => ListenableBuilder(
                                listenable: controller,
                                builder: (context, _) => CroppableImageWidget(
                                  controller: controller,
                                  overlayOpacity: overlayOpacityAnimation.value,
                                  image: Image(image: controller.imageProvider),
                                  cropHandles: MaterialImageCropperHandles(
                                    controller: controller,
                                    gesturePadding: gesturePadding,
                                  ),
                                  gesturePadding: gesturePadding,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: overlayOpacityAnimation,
                      builder: (context, _) => Opacity(
                        opacity: overlayOpacityAnimation.value,
                        child: MaterialImageCropperToolbar(
                          controller: controller,
                        ),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: overlayOpacityAnimation,
                      builder: (context, _) => Opacity(
                        opacity: overlayOpacityAnimation.value,
                        child: MaterialImageCropperBottomAppBar(
                          controller: controller,
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
