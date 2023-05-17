import 'package:croppy/src/src.dart';
import 'package:flutter/material.dart';

class CupertinoToolbar extends StatelessWidget {
  const CupertinoToolbar({
    super.key,
    required this.controller,
  });

  final CroppableImageController controller;

  @override
  Widget build(BuildContext context) {
    if (controller is! CupertinoCroppableImageController) {
      return CupertinoImageTransformationToolbar(controller: controller);
    }

    return ValueListenableBuilder(
      valueListenable:
          (controller as CupertinoCroppableImageController).toolbarNotifier,
      builder: (context, toolbar, child) {
        late final Widget child;

        switch (toolbar) {
          case CupertinoCroppableImageToolbar.transform:
            child = CupertinoImageTransformationToolbar(controller: controller);
            break;
          case CupertinoCroppableImageToolbar.aspectRatio:
            child = CupertinoImageAspectRatioToolbar(
              controller: controller as AspectRatioMixin,
            );
            break;
          default:
            throw UnimplementedError();
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: child,
        );
      },
    );
  }
}
