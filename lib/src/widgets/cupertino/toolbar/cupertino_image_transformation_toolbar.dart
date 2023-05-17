import 'dart:math';

import 'package:croppy/src/src.dart';
import 'package:flutter/cupertino.dart';

class CupertinoImageTransformationToolbar extends StatefulWidget {
  const CupertinoImageTransformationToolbar({
    super.key,
    required this.controller,
  });

  final CroppableImageController controller;

  @override
  State<CupertinoImageTransformationToolbar> createState() =>
      _CupertinoImageTransformationToolbarState();
}

class _CupertinoImageTransformationToolbarState
    extends State<CupertinoImageTransformationToolbar> {
  var _activeKnob = 0;

  Widget _buildRotationSlider(BuildContext context) {
    if (_activeKnob == 0) {
      return ValueListenableBuilder(
        key: const Key('slider-0'),
        valueListenable: widget.controller.rotationZNotifier,
        builder: (context, rotationZ, _) => CupertinoRotationSlider(
          value: rotationZ,
          extent: pi / 4,
          onStart: widget.controller.onStraightenStart,
          onEnd: widget.controller.onStraightenEnd,
          onChanged: (v) {
            widget.controller.onStraighten(angleRad: v);
          },
        ),
      );
    }

    if (_activeKnob == 1) {
      return ValueListenableBuilder(
        key: const Key('slider-1'),
        valueListenable: widget.controller.rotationYNotifier,
        builder: (context, rotationY, _) => CupertinoRotationSlider(
          value: rotationY,
          extent: pi / 6,
          onStart: widget.controller.onRotateYStart,
          onEnd: widget.controller.onRotateYEnd,
          onChanged: (v) {
            widget.controller.onRotateY(angleRad: v);
          },
        ),
      );
    }

    if (_activeKnob == 2) {
      return ValueListenableBuilder(
        key: const Key('slider-2'),
        valueListenable: widget.controller.rotationXNotifier,
        builder: (context, rotationX, _) => CupertinoRotationSlider(
          value: rotationX,
          extent: pi / 6,
          onStart: widget.controller.onRotateXStart,
          onEnd: widget.controller.onRotateXEnd,
          onChanged: (v) {
            widget.controller.onRotateX(angleRad: v);
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _CupertinoImageTransformationToolbarKnobs(
          controller: widget.controller,
          activeKnob: _activeKnob,
          setActiveKnob: (v) => setState(() => _activeKnob = v),
        ),
        const SizedBox(height: 8.0),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: _buildRotationSlider(context),
        ),
      ],
    );
  }
}

class _CupertinoImageTransformationToolbarKnobs extends StatefulWidget {
  const _CupertinoImageTransformationToolbarKnobs({
    required this.activeKnob,
    required this.setActiveKnob,
    required this.controller,
  });

  final CroppableImageController controller;
  final int activeKnob;
  final ValueChanged<int> setActiveKnob;

  @override
  State<_CupertinoImageTransformationToolbarKnobs> createState() =>
      _CupertinoImageTransformationToolbarKnobsState();
}

class _CupertinoImageTransformationToolbarKnobsState
    extends State<_CupertinoImageTransformationToolbarKnobs>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;
  late var _tween = Tween(
    begin: widget.activeKnob - 1.0,
    end: widget.activeKnob - 1.0,
  );

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_CupertinoImageTransformationToolbarKnobs oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.activeKnob != widget.activeKnob) {
      _animationController.reset();

      _tween = Tween(
        begin: oldWidget.activeKnob - 1,
        end: widget.activeKnob - 1,
      );

      _animationController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(_tween.evaluate(_animation) * -64.0, 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder(
            valueListenable: widget.controller.rotationZNotifier,
            builder: (context, rotationZ, _) => CupertinoKnob(
              value: rotationZ * 180 / pi,
              extent: 45,
              onChanged: (v) {
                if (widget.activeKnob != 0) {
                  widget.setActiveKnob(0);
                  return;
                }

                widget.controller.onStraighten(angleRad: v);
              },
              inactiveChild: const CupertinoStraightenIcon(
                color: CupertinoColors.white,
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          ValueListenableBuilder(
            valueListenable: widget.controller.rotationYNotifier,
            builder: (context, rotationY, _) => CupertinoKnob(
              value: rotationY * 180 / pi,
              extent: 30,
              onChanged: (v) {
                if (widget.activeKnob != 1) {
                  widget.setActiveKnob(1);
                  return;
                }

                widget.controller.onRotateY(angleRad: v);
              },
              inactiveChild: const CupertinoPerspectiveXIcon(
                color: CupertinoColors.white,
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          ValueListenableBuilder(
            valueListenable: widget.controller.rotationXNotifier,
            builder: (context, rotationX, _) => CupertinoKnob(
              value: rotationX * 180 / pi,
              extent: 30,
              onChanged: (v) {
                if (widget.activeKnob != 2) {
                  widget.setActiveKnob(2);
                  return;
                }

                widget.controller.onRotateX(angleRad: v);
              },
              inactiveChild: const CupertinoPerspectiveYIcon(
                color: CupertinoColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
