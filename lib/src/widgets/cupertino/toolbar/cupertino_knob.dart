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
    final theme = CupertinoTheme.of(context);
    final activeColor = theme.primaryColor;
    final inactiveColor = theme.primaryContrastingColor;
    final Color color;
    if (isPositive) {
      // Positiver Wert: Primärfarbe
      color = activeColor;
    } else if (!isActive) {
      // Neutraler Wert (nicht aktiv): Kontrastfarbe
      color = inactiveColor;
    } else {
      // Negativer Wert: Weiß (Cupertino-spezifisch)
      color = CupertinoColors.white;
    }

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
              color: theme.scaffoldBackgroundColor.withOpacity(0.5),
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
        : CupertinoTheme.of(context).primaryContrastingColor;

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
        inactiveColor: CupertinoTheme.of(context).primaryContrastingColor,
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
    this.inactiveColor,
  });

  final Color primaryColor;
  final Color? inactiveColor;
  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = value > epsilon ? primaryColor : (inactiveColor ?? Colors.white)
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
