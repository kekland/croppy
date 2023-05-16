import 'package:croppy/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoImageCropperPage extends StatelessWidget {
  const CupertinoImageCropperPage({
    super.key,
    required this.controller,
    this.gesturePadding = 16.0,
  });

  final CroppableImageController controller;
  final double gesturePadding;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      navigationBar: CupertinoImageCropperAppBar(
        controller: controller,
      ),
      child: ClipRect(
        child: Stack(
          children: [
            Positioned(
              left: 16.0,
              top: 16.0,
              right: 16.0,
              bottom: 64.0,
              child: CroppableImageViewport(
                controller: controller,
                gesturePadding: gesturePadding,
                child: ListenableBuilder(
                  listenable: controller,
                  builder: (context, _) => CroppableImageWidget(
                    controller: controller,
                    image: Image(image: controller.imageProvider),
                    cropHandles: CupertinoImageCropHandles(
                      controller: controller,
                      gesturePadding: gesturePadding,
                    ),
                    gesturePadding: gesturePadding,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0.0,
              height: 128.0,
              left: 0.0,
              right: 0.0,
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        CupertinoColors.black.withOpacity(0.0),
                        CupertinoColors.black.withOpacity(0.5),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
              height: 40.0,
              child: ListenableBuilder(
                listenable: controller,
                builder: (context, _) => CupertinoImageTransformationToolbar(
                  controller: controller,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
