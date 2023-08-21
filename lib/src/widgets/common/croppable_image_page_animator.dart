import 'package:croppy/src/src.dart';
import 'package:flutter/material.dart';

/// Animates a page transition for a croppable image.
///
/// This animation is used to animate the page when a Hero animation is being
/// performed. During a Hero animation, it's necessary to hide any overlays
/// above the image, such as the crop handles and the toolbar; otherwise they
/// would suddenly pop-in when the Hero animation is finished.
///
/// This widget automatically handles the animation of the overlay opacity. If
/// [heroTag] is not null, then the animation will be triggered automatically
/// when the widget is built.
///
/// In some cases it's also necessary to enable/disable the Hero animation
/// manually. This can be done by calling [setHeroesEnabled]. This is useful
/// when the user is interacting with the image and the Hero animation should
/// be disabled. When the user clicks "Submit", the Hero animation should be
/// enabled again.
class CroppableImagePageAnimator extends StatefulWidget {
  const CroppableImagePageAnimator({
    super.key,
    required this.controller,
    required this.builder,
    this.heroTag,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOut,
  });

  /// The controller of the croppable image.
  final CroppableImageController controller;

  /// The hero tag of the image. If this is not null, then the animation will
  /// be started automatically when the widget is built.
  final Object? heroTag;

  /// The builder for the page. The [overlayOpacityAnimation] can be used to
  /// animate the opacity of the overlays.
  final Widget Function(
    BuildContext context,
    Animation<double> overlayOpacityAnimation,
  ) builder;

  /// The duration of the overlay fade-in animation.
  final Duration duration;

  /// The curve of the overlay fade-in animation.
  final Curve curve;

  /// Call this to obtain the state of the animator, and to enable/disable the
  /// Hero animation.
  static CroppableImagePageAnimatorState? of(BuildContext context) =>
      context.findAncestorStateOfType<CroppableImagePageAnimatorState>();

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
      duration: widget.duration,
    );

    _overlayOpacityAnimation = CurvedAnimation(
      parent: _overlayOpacityAnimationController,
      curve: widget.curve,
    );

    if (widget.heroTag != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final transitionDuration =
            ModalRoute.of(context)?.transitionDuration ?? widget.duration;

        Future.delayed(
          transitionDuration - const Duration(milliseconds: 100),
          () {
            _overlayOpacityAnimationController.forward(from: 0.0);
          },
        );
      });
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
