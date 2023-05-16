import 'package:croppy/src/src.dart';
import 'package:croppy/src/widgets/cupertino/cupertino_image_cropper_app_bar.dart';
import 'package:flutter/cupertino.dart';

class CupertinoImageCropperPage extends StatefulWidget {
  const CupertinoImageCropperPage({
    super.key,
    required this.controller,
    this.gesturePadding = 16.0,
    this.heroTag,
  });

  final CroppableImageController controller;
  final double gesturePadding;
  final Object? heroTag;

  @override
  State<CupertinoImageCropperPage> createState() =>
      _CupertinoImageCropperPageState();
}

class _CupertinoImageCropperPageState extends State<CupertinoImageCropperPage>
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

    _overlayOpacityAnimationController.addListener(() {
      if (!mounted) return;
      setState(() {});
    });

    if (widget.heroTag != null) {
      Future.delayed(kCupertinoImageCropperPageTransitionDuration, () {
        _overlayOpacityAnimationController.forward(from: 0.0);
      });
    } else {
      _overlayOpacityAnimationController.forward(from: 0.0);
    }

    widget.controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    setHeroesEnabled(false);
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
    final safeArea = MediaQuery.of(context).padding;
    const bottomAppBarHeight = 96.0 + 55.0;

    return HeroMode(
      enabled: _areHeroesEnabled,
      child: ClipRect(
        child: CupertinoPageScaffold(
          backgroundColor: CupertinoColors.black,
          navigationBar: CupertinoImageCropperAppBar(
            controller: widget.controller,
          ),
          child: Stack(
            children: [
              Positioned(
                left: 16.0,
                top: 16.0,
                right: 16.0,
                bottom: safeArea.bottom + bottomAppBarHeight + 16.0,
                child: CroppableImageViewport(
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
                  child: ListenableBuilder(
                    listenable: widget.controller,
                    builder: (context, _) => CroppableImageWidget(
                      controller: widget.controller,
                      overlayOpacity: _overlayOpacityAnimation.value,
                      image: Image(image: widget.controller.imageProvider),
                      cropHandles: CupertinoImageCropHandles(
                        controller: widget.controller,
                        gesturePadding: widget.gesturePadding,
                      ),
                      gesturePadding: widget.gesturePadding,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0.0,
                height: 128.0,
                left: 0.0,
                right: 0.0,
                child: Opacity(
                  opacity: _overlayOpacityAnimation.value,
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            CupertinoColors.black.withOpacity(0.0),
                            CupertinoColors.black.withOpacity(0.5),
                            CupertinoColors.black.withOpacity(0.85),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16.0,
                right: 16.0,
                bottom: safeArea.bottom + 16.0,
                height: bottomAppBarHeight,
                child: Opacity(
                  opacity: _overlayOpacityAnimation.value,
                  child: ListenableBuilder(
                    listenable: widget.controller,
                    builder: (context, _) => Column(
                      children: [
                        CupertinoImageTransformationToolbar(
                          controller: widget.controller,
                        ),
                        CupertinoImageCropperBottomAppBar(
                          controller: widget.controller,
                          onSubmit: () => setHeroesEnabled(true),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
