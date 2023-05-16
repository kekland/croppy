import 'package:croppy/src/src.dart';
import 'package:flutter/material.dart';

class CroppableImageViewport extends StatelessWidget {
  const CroppableImageViewport({
    super.key,
    required this.controller,
    required this.child,
    required this.gesturePadding,
  });

  final CroppableImageController controller;
  final double gesturePadding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest +
            Offset(-gesturePadding * 2, -gesturePadding * 2);

        controller.viewportSize = size;

        return Center(
          child: FittedBox(child: child),
        );
      },
    );
  }
}
