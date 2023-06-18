import 'package:croppy/src/src.dart';
import 'package:flutter/material.dart';

class AnimatedCroppableImageViewport extends StatefulWidget {
  const AnimatedCroppableImageViewport({
    super.key,
    required this.controller,
    required this.cropHandlesBuilder,
    required this.overlayOpacityAnimation,
    this.gesturePadding = 16.0,
    this.heroTag,
    this.shouldLightenOnTransform = true,
    this.lightenAnimationDuration = const Duration(milliseconds: 200),
    this.lightenAnimationCurve = Curves.easeInOut,
    this.minBackgroundOpacity = 0.25,
    this.maxBackgroundOpacity = 0.85,
  });

  final CroppableImageController controller;
  final Animation<double> overlayOpacityAnimation;
  final double gesturePadding;
  final Object? heroTag;

  final bool shouldLightenOnTransform;
  final Duration lightenAnimationDuration;
  final Curve lightenAnimationCurve;

  final double minBackgroundOpacity;
  final double maxBackgroundOpacity;

  final WidgetBuilder cropHandlesBuilder;

  @override
  State<AnimatedCroppableImageViewport> createState() =>
      _AnimatedCroppableImageViewportState();
}

class _AnimatedCroppableImageViewportState
    extends State<AnimatedCroppableImageViewport>
    with SingleTickerProviderStateMixin {
  late final AnimationController _backgroundOpacityAnimationController;
  late final Animation<double> _backgroundOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _backgroundOpacityAnimationController = AnimationController(
      vsync: this,
      duration: widget.lightenAnimationDuration,
      value: 1.0,
    );
    _backgroundOpacityAnimation = CurvedAnimation(
      parent: _backgroundOpacityAnimationController,
      curve: widget.lightenAnimationCurve,
    );

    widget.controller.isTransformingNotifier.addListener(
      _onIsTransformingChanged,
    );
  }

  void _onIsTransformingChanged() {
    if (!widget.shouldLightenOnTransform) return;

    if (widget.controller.isTransformingNotifier.value) {
      _backgroundOpacityAnimationController.reverse();
    } else {
      _backgroundOpacityAnimationController.forward();
    }
  }

  double get _backgroundOpacity {
    final value = _backgroundOpacityAnimation.value;

    return widget.minBackgroundOpacity +
        (widget.maxBackgroundOpacity - widget.minBackgroundOpacity) * value;
  }

  @override
  void dispose() {
    _backgroundOpacityAnimationController.dispose();
    widget.controller.isTransformingNotifier.removeListener(
      _onIsTransformingChanged,
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CroppableImageViewport(
      controller: widget.controller,
      gesturePadding: widget.gesturePadding,
      heroTag: widget.heroTag,
      heroChild: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) => CroppedHeroImageWidget(
          controller: widget.controller,
          child: Image(image: widget.controller.imageProvider),
        ),
      ),
      child: AnimatedBuilder(
        animation: _backgroundOpacityAnimation,
        builder: (context, _) => AnimatedBuilder(
          animation: widget.overlayOpacityAnimation,
          builder: (context, _) => ListenableBuilder(
            listenable: widget.controller,
            builder: (context, _) => CroppableImageWidget(
              controller: widget.controller,
              overlayOpacity: widget.overlayOpacityAnimation.value,
              backgroundOpacity: _backgroundOpacity,
              image: Image(image: widget.controller.imageProvider),
              cropHandles: widget.cropHandlesBuilder(context),
              gesturePadding: widget.gesturePadding,
            ),
          ),
        ),
      ),
    );
  }
}
