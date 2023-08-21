import 'package:croppy/src/src.dart';
import 'package:flutter/material.dart';

/// A widget that displays the croppable image.
///
/// This widget is responsible for displaying the croppable image, the cropped
/// image that participates in a Hero animation, and computes the size of the
/// viewport.
///
/// By default, the crop area is centered in the viewport.
class CroppableImageViewport extends StatelessWidget {
  const CroppableImageViewport({
    super.key,
    required this.controller,
    required this.child,
    required this.gesturePadding,
    this.heroTag,
    this.heroChild,
  });

  /// The controller that manages the state of the croppable image.
  final CroppableImageController controller;

  /// The amount of padding that is applied to the [child] to detect gestures.
  /// The actual size of the image is the size of the [child] minus the padding.
  final double gesturePadding;

  /// The child widget that is wrapped by this widget.
  final Widget child;

  /// The tag that is used for the Hero animation.
  final Object? heroTag;

  /// The child that is used for the Hero animation.
  final Widget? heroChild;

  /// The amount of padding that is applied to [child].
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
                  child: Visibility.maintain(
                    visible: false,
                    child: _buildHeroChild(context),
                  ),
                ),
              ),
            Center(child: FittedBox(child: child)),
          ],
        );
      },
    );
  }
}
