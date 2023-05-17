import 'package:croppy/src/src.dart';
import 'package:flutter/material.dart';

class CroppableImageViewport extends StatelessWidget {
  const CroppableImageViewport({
    super.key,
    required this.controller,
    required this.child,
    required this.gesturePadding,
    this.heroTag,
    this.heroChild,
  });

  final CroppableImageController controller;
  final double gesturePadding;
  final Widget child;
  final Object? heroTag;
  final Widget? heroChild;

  Offset get _sizeDelta => Offset(
        -gesturePadding * 2,
        -gesturePadding * 2,
      );

  Widget _buildHeroChild(BuildContext context) => FittedBox(child: heroChild!);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest + _sizeDelta;
        controller.setViewportSizeInBuild(size);

        return Stack(
          children: [
            if (heroTag != null)
              Center(
                child: Hero(
                  tag: heroTag!,
                  flightShuttleBuilder: (flightContext, animation,
                      flightDirection, fromHeroContext, toHeroContext) {
                    return _buildHeroChild(context);
                  },
                  child: _buildHeroChild(context),
                ),
              ),
            Center(child: FittedBox(child: child)),
          ],
        );
      },
    );
  }
}
