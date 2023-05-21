import 'package:croppy/src/src.dart';
import 'package:flutter/material.dart';

class MaterialCroppableImageViewport extends StatefulWidget {
  const MaterialCroppableImageViewport({
    super.key,
    required this.controller,
    required this.overlayOpacityAnimation,
    this.gesturePadding = 16.0,
    this.heroTag,
  });

  final CroppableImageController controller;
  final Animation<double> overlayOpacityAnimation;
  final double gesturePadding;
  final Object? heroTag;

  @override
  State<MaterialCroppableImageViewport> createState() =>
      _MaterialCroppableImageViewportState();
}

class _MaterialCroppableImageViewportState
    extends State<MaterialCroppableImageViewport>
    with SingleTickerProviderStateMixin {
  late final AnimationController _backgroundOpacityAnimationController;
  late final Animation<double> _backgroundOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _backgroundOpacityAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: 1.0,
    );
    _backgroundOpacityAnimation = CurvedAnimation(
      parent: _backgroundOpacityAnimationController,
      curve: Curves.easeInOut,
    );

    widget.controller.isTransformingNotifier.addListener(
      _onIsTransformingChanged,
    );
  }

  void _onIsTransformingChanged() {
    if (widget.controller.isTransformingNotifier.value) {
      _backgroundOpacityAnimationController.reverse();
    } else {
      _backgroundOpacityAnimationController.forward();
    }
  }

  final _minBackgroundOpacity = 0.25;
  final _maxBackgroundOpacity = 0.85;
  double get _backgroundOpacity {
    final value = _backgroundOpacityAnimation.value;
    return _minBackgroundOpacity +
        (_maxBackgroundOpacity - _minBackgroundOpacity) * value;
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
              cropHandles: MaterialImageCropperHandles(
                controller: widget.controller,
                gesturePadding: widget.gesturePadding,
              ),
              gesturePadding: widget.gesturePadding,
            ),
          ),
        ),
      ),
    );
  }
}
