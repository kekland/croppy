import 'dart:math';

import 'package:croppy/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class CupertinoImageTransformationToolbar extends StatefulWidget {
  const CupertinoImageTransformationToolbar({
    super.key,
    required this.controller,
    this.gesturePadding = 16.0,
  });

  final CroppableImageController controller;

  /// Must match the [gesturePadding] used by the viewport so that homography
  /// handle coordinates are computed correctly.
  final double gesturePadding;

  @override
  State<CupertinoImageTransformationToolbar> createState() =>
      _CupertinoImageTransformationToolbarState();
}

enum _Knob {
  rotateZ,
  rotateY,
  rotateX,
  stretchX,
  stretchY,
  homography,
}

class _CupertinoImageTransformationToolbarState
    extends State<CupertinoImageTransformationToolbar> {
  late _Knob? _activeKnob;
  late final List<_Knob> _knobs;

  @override
  void initState() {
    super.initState();

    _knobs = [
      if (widget.controller.isTransformationEnabled(Transformation.rotateZ))
        _Knob.rotateZ,
      if (widget.controller.isTransformationEnabled(Transformation.rotateX))
        _Knob.rotateX,
      if (widget.controller.isTransformationEnabled(Transformation.rotateY))
        _Knob.rotateY,
      if (widget.controller.isTransformationEnabled(Transformation.stretchX))
        _Knob.stretchX,
      if (widget.controller.isTransformationEnabled(Transformation.stretchY))
        _Knob.stretchY,
      if (widget.controller.isTransformationEnabled(Transformation.homography))
        _Knob.homography,
    ];

    _activeKnob = _knobs.isNotEmpty ? _knobs.first : null;
  }

  void _selectKnob(_Knob knob) {
    if (_activeKnob == knob) return;

    // Deactivate the homography tool when switching away from it.
    if (_activeKnob == _Knob.homography) {
      widget.controller.onDeactivateHomographyCorrection();
    }

    setState(() => _activeKnob = knob);

    // Activate the homography tool when switching to it.
    if (knob == _Knob.homography) {
      widget.controller.onActivateHomographyCorrection(
        gesturePadding: widget.gesturePadding,
      );
    }
  }

  Widget _buildRotationSlider(BuildContext context) {
    if (_activeKnob == _Knob.rotateZ) {
      return ValueListenableBuilder(
        key: const Key('rotateZ'),
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

    if (_activeKnob == _Knob.rotateX) {
      return ValueListenableBuilder(
        key: const Key('rotateX'),
        valueListenable: widget.controller.rotationXNotifier,
        builder: (context, rotationX, _) => CupertinoRotationSlider(
          value: rotationX,
          extent: pi / 6,
          isReversed: true,
          onStart: widget.controller.onRotateXStart,
          onEnd: widget.controller.onRotateXEnd,
          onChanged: (v) {
            widget.controller.onRotateX(angleRad: v);
          },
        ),
      );
    }

    if (_activeKnob == _Knob.rotateY) {
      return ValueListenableBuilder(
        key: const Key('rotateY'),
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

    if (_activeKnob == _Knob.stretchX) {
      return ValueListenableBuilder(
        key: const Key('stretchX'),
        valueListenable: widget.controller.scaleXNotifier,
        builder: (context, scaleX, _) => CupertinoRotationSlider(
          value: scaleX - 1.0,
          extent: 0.5,
          onStart: widget.controller.onStretchXStart,
          onEnd: widget.controller.onStretchXEnd,
          onChanged: (v) => widget.controller.onStretchX(scaleX: 1.0 + v),
        ),
      );
    }

    if (_activeKnob == _Knob.stretchY) {
      return ValueListenableBuilder(
        key: const Key('stretchY'),
        valueListenable: widget.controller.scaleYNotifier,
        builder: (context, scaleY, _) => CupertinoRotationSlider(
          value: scaleY - 1.0,
          extent: 0.5,
          onStart: widget.controller.onStretchYStart,
          onEnd: widget.controller.onStretchYEnd,
          onChanged: (v) => widget.controller.onStretchY(scaleY: 1.0 + v),
        ),
      );
    }

    if (_activeKnob == _Knob.homography) {
      final l10n = CroppyLocalizations.of(context)!;
      final primaryColor = CupertinoTheme.of(context).primaryColor;
      return Row(
        key: const Key('homography'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoButton(
            onPressed: () {
              widget.controller.onApplyHomographyCorrection(
                gesturePadding: widget.gesturePadding,
              );
              widget.controller.onDeactivateHomographyCorrection();
              final fallback = _knobs.firstWhere(
                (k) => k != _Knob.homography,
                orElse: () => _Knob.rotateZ,
              );
              setState(() => _activeKnob = fallback);
            },
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              l10n.applyLabel,
              style: TextStyle(color: primaryColor),
            ),
          ),
          CupertinoButton(
            onPressed: () {
              widget.controller.onDeactivateHomographyCorrection();
              final fallback = _knobs.firstWhere(
                (k) => k != _Knob.homography,
                orElse: () => _Knob.rotateZ,
              );
              setState(() => _activeKnob = fallback);
            },
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(l10n.cancelLabel),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  List<Widget> _buildKnobs(BuildContext context) {
    return [
      if (widget.controller.isTransformationEnabled(Transformation.rotateZ))
        _CupertinoRotationKnobWidget(
          key: const Key('rotateZ'),
          notifier: widget.controller.rotationZNotifier,
          extent: 45.0,
          isActive: _activeKnob == _Knob.rotateZ,
          onSelected: () => _selectKnob(_Knob.rotateZ),
          onChanged: (v) => widget.controller.onStraighten(angleRad: v),
          inactiveChild: const CupertinoStraightenIcon(
            color: CupertinoColors.white,
          ),
        ),
      if (widget.controller.isTransformationEnabled(Transformation.rotateX))
        _CupertinoRotationKnobWidget(
          key: const Key('rotateX'),
          notifier: widget.controller.rotationXNotifier,
          extent: 30.0,
          isReversed: true,
          isActive: _activeKnob == _Knob.rotateX,
          onSelected: () => _selectKnob(_Knob.rotateX),
          onChanged: (v) => widget.controller.onRotateX(angleRad: v),
          inactiveChild: const CupertinoPerspectiveXIcon(
            color: CupertinoColors.white,
          ),
        ),
      if (widget.controller.isTransformationEnabled(Transformation.rotateY))
        _CupertinoRotationKnobWidget(
          key: const Key('rotateY'),
          notifier: widget.controller.rotationYNotifier,
          extent: 30.0,
          isActive: _activeKnob == _Knob.rotateY,
          onSelected: () => _selectKnob(_Knob.rotateY),
          onChanged: (v) => widget.controller.onRotateY(angleRad: v),
          inactiveChild: const CupertinoPerspectiveYIcon(
            color: CupertinoColors.white,
          ),
        ),
      if (widget.controller.isTransformationEnabled(Transformation.stretchX))
        _CupertinoStretchKnobWidget(
          key: const Key('stretchX'),
          notifier: widget.controller.scaleXNotifier,
          isActive: _activeKnob == _Knob.stretchX,
          onSelected: () => _selectKnob(_Knob.stretchX),
          onChanged: (v) => widget.controller.onStretchX(scaleX: v),
          inactiveChild: const CupertinoStretchXIcon(
            color: CupertinoColors.white,
          ),
        ),
      if (widget.controller.isTransformationEnabled(Transformation.stretchY))
        _CupertinoStretchKnobWidget(
          key: const Key('stretchY'),
          notifier: widget.controller.scaleYNotifier,
          isActive: _activeKnob == _Knob.stretchY,
          onSelected: () => _selectKnob(_Knob.stretchY),
          onChanged: (v) => widget.controller.onStretchY(scaleY: v),
          inactiveChild: const CupertinoStretchYIcon(
            color: CupertinoColors.white,
          ),
        ),
      if (widget.controller.isTransformationEnabled(Transformation.homography))
        _CupertinoHomographyKnobWidget(
          key: const Key('homography'),
          isActive: _activeKnob == _Knob.homography,
          onSelected: () => _selectKnob(_Knob.homography),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_activeKnob == null) {
      return const SizedBox.expand();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _CupertinoImageTransformationToolbarKnobs(
          activeKnob: _activeKnob!,
          knobs: _knobs,
          children: _buildKnobs(context),
        ),
        const SizedBox(height: 8.0),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            child: _buildRotationSlider(context),
          ),
        ),
      ],
    );
  }
}

class _CupertinoImageTransformationToolbarKnobs extends StatefulWidget {
  const _CupertinoImageTransformationToolbarKnobs({
    required this.activeKnob,
    required this.knobs,
    required this.children,
  });

  final _Knob activeKnob;
  final List<_Knob> knobs;
  final List<Widget> children;

  int get activeKnobIndex => knobs.indexOf(activeKnob);

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
    begin: widget.activeKnobIndex.toDouble(),
    end: widget.activeKnobIndex.toDouble(),
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
        begin: oldWidget.activeKnobIndex.toDouble(),
        end: widget.activeKnobIndex.toDouble(),
      );

      _animationController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    const itemExtent = 64.0;
    final width = widget.children.length * itemExtent;

    final offset = Offset(
      (width - itemExtent) / 2.0 - _tween.evaluate(_animation) * itemExtent,
      0.0,
    );

    return Transform.translate(
      offset: offset,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: widget.children
            .map((v) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0), child: v))
            .toList(),
      ),
    );
  }
}

/// A knob for the stretch X / stretch Y tools. Displays the scale as a
/// percentage offset from 1.0 (e.g. +25 for 1.25, -10 for 0.90).
class _CupertinoStretchKnobWidget extends StatelessWidget {
  const _CupertinoStretchKnobWidget({
    super.key,
    required this.notifier,
    required this.isActive,
    required this.onSelected,
    required this.onChanged,
    required this.inactiveChild,
  });

  final ValueListenable<double> notifier;
  final bool isActive;
  final VoidCallback onSelected;
  final ValueChanged<double> onChanged;
  final Widget inactiveChild;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (context, v, _) => CupertinoKnob(
        // Display as percentage offset: 1.25 → +25, 0.80 → -20
        value: (v - 1.0) * 100.0,
        extent: 50.0,
        onChanged: (pct) {
          if (!isActive) {
            onSelected();
            return;
          }
          onChanged(1.0 + pct / 100.0);
        },
        inactiveChild: inactiveChild,
      ),
    );
  }
}

/// A simple button knob for the homography tool. Unlike the rotation knobs,
/// it has no draggable value — tapping it activates the tool.
class _CupertinoHomographyKnobWidget extends StatelessWidget {
  const _CupertinoHomographyKnobWidget({
    super.key,
    required this.isActive,
    required this.onSelected,
  });

  final bool isActive;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return CupertinoKnobButton(
      isActive: isActive,
      isPositive: isActive,
      onPressed: onSelected,
      child: const CupertinoHomographyIcon(color: CupertinoColors.white),
    );
  }
}

class _CupertinoRotationKnobWidget extends StatelessWidget {
  const _CupertinoRotationKnobWidget({
    super.key,
    required this.extent,
    required this.notifier,
    required this.isActive,
    required this.onSelected,
    required this.onChanged,
    required this.inactiveChild,
    this.isReversed = false,
  });

  final double extent;
  final ValueListenable notifier;
  final bool isActive;
  final bool isReversed;
  final VoidCallback onSelected;
  final ValueChanged<double> onChanged;
  final Widget inactiveChild;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (context, v, _) => CupertinoKnob(
        value: (isReversed ? -1 : 1) * v * 180 / pi,
        extent: extent,
        onChanged: (v) {
          if (!isActive) {
            onSelected();
            return;
          }

          onChanged(v);
        },
        inactiveChild: inactiveChild,
      ),
    );
  }
}
