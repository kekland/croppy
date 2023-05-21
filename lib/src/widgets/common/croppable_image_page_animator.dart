import 'package:croppy/src/src.dart';
import 'package:flutter/material.dart';

class CroppableImagePageAnimator extends StatefulWidget {
  const CroppableImagePageAnimator({
    super.key,
    required this.controller,
    required this.builder,
    this.heroTag,
  });

  final CroppableImageController controller;
  final Object? heroTag;
  final Widget Function(
    BuildContext context,
    Animation<double> overlayOpacityAnimation,
  ) builder;

  @override
  State<CroppableImagePageAnimator> createState() =>
      CroppableImagePageAnimatorState();
}

class CroppableImagePageAnimatorState extends State<CroppableImagePageAnimator>
    with SingleTickerProviderStateMixin {
  var _areHeroesEnabled = true;

  late final AnimationController _overlayOpacityAnimationController;
  late final Animation<double> _overlayOpacityAnimation;

  @override
  void initState() {
    super.initState();

    _overlayOpacityAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _overlayOpacityAnimation = CurvedAnimation(
      parent: _overlayOpacityAnimationController,
      curve: Curves.easeInOut,
    );

    if (widget.heroTag != null) {
      Future.delayed(
        kCupertinoImageCropperPageTransitionDuration -
            const Duration(milliseconds: 100),
        () {
          _overlayOpacityAnimationController.forward(from: 0.0);
        },
      );
    } else {
      _overlayOpacityAnimationController.forward(from: 0.0);
    }

    widget.controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    setHeroesEnabled(!widget.controller.isChangedNotifier.value);
  }

  void setHeroesEnabled(bool enabled) {
    if (_areHeroesEnabled == enabled) return;

    setState(() {
      _areHeroesEnabled = enabled;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _overlayOpacityAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HeroMode(
      enabled: _areHeroesEnabled,
      child: ClipRect(
        child: widget.builder(context, _overlayOpacityAnimation),
      ),
    );
  }
}
