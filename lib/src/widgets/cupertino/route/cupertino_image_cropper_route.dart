import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const kCupertinoImageCropperPageTransitionDuration =
    Duration(milliseconds: 300);

class CupertinoImageCropperWithHeroRoute<T> extends PageRoute<T> {
  CupertinoImageCropperWithHeroRoute({
    required this.builder,
    super.fullscreenDialog = true,
    RouteSettings? settings,
  }) : super(settings: settings);

  final WidgetBuilder builder;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => 'Image Cropper';

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final opacity = animation.status == AnimationStatus.forward
            ? animation.value
            : pow(animation.value, 3.0).toDouble();

        return Opacity(
          opacity: opacity,
          child: child,
        );
      },
      child: builder(context),
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration =>
      kCupertinoImageCropperPageTransitionDuration;

  @override
  bool get opaque => false;
}
