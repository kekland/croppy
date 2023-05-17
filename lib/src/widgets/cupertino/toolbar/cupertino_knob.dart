import 'dart:math';

import 'package:croppy/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoKnobButton extends StatelessWidget {
  const CupertinoKnobButton({
    super.key,
    required this.isActive,
    required this.isPositive,
    required this.onPressed,
    required this.child,
    this.progressPainter,
  });

  final bool isActive;
  final bool isPositive;
  final VoidCallback onPressed;
  final Widget child;
  final CustomPainter? progressPainter;

  @override
  Widget build(BuildContext context) {
    final color = isPositive
        ? CupertinoTheme.of(context).primaryColor
        : CupertinoColors.white;

    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      minSize: 48.0,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        opacity: isActive ? 1.0 : 0.5,
        child: CustomPaint(
          foregroundPainter: progressPainter,
          child: Container(
            width: 48.0,
            height: 48.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black54,
              border: Border.all(
                width: 2.0,
                color: color.withOpacity(0.35),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class CupertinoKnob extends StatelessWidget {
  const CupertinoKnob({
    super.key,
    required this.value,
    required this.extent,
    required this.onChanged,
    required this.inactiveChild,
  });

  final double value;
  final double extent;
  final ValueChanged<double> onChanged;
  final Widget inactiveChild;

  @override
  Widget build(BuildContext context) {
    final isActive = value.abs() > epsilon;
    final isPositive = value > epsilon;

    final color = isPositive
        ? CupertinoTheme.of(context).primaryColor
        : CupertinoColors.white;

    late final Widget child;

    if (!isActive) {
      child = KeyedSubtree(
        key: const Key('inactive'),
        child: inactiveChild,
      );
    } else {
      child = Text(
        key: const Key('value'),
        value.round().toString(),
        style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
              fontSize: 14.0,
              color: color,
            ),
      );
    }

    return CupertinoKnobButton(
      isActive: isActive,
      isPositive: isPositive,
      onPressed: () => onChanged(0.0),
      progressPainter: _CupertinoKnobProgressPainter(
        primaryColor: color,
        value: value / extent,
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 100),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: child,
      ),
    );
  }
}

class _CupertinoKnobProgressPainter extends CustomPainter {
  _CupertinoKnobProgressPainter({
    required this.value,
    required this.primaryColor,
  });

  final Color primaryColor;
  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = value > epsilon ? primaryColor : Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      (Offset.zero & size).deflate(1.0),
      -pi / 2,
      value * (2 * pi),
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_CupertinoKnobProgressPainter oldDelegate) =>
      oldDelegate.value != value || oldDelegate.primaryColor != primaryColor;
}
