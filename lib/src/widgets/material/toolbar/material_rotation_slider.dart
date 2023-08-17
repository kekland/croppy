import 'dart:math';

import 'package:croppy/croppy.dart';
import 'package:flutter/material.dart';

class MaterialRotationSlider extends StatefulWidget {
  const MaterialRotationSlider({
    super.key,
    required this.controller,
    this.color,
    this.activeColor,
  });

  final CroppableImageController controller;
  final Color? color;
  final Color? activeColor;

  @override
  State<MaterialRotationSlider> createState() => _MaterialRotationSliderState();
}

class _MaterialRotationSliderState extends State<MaterialRotationSlider> {
  double _width = 0.0;
  DragStartDetails? _dragStartDetails;
  double? _dragStartValue;

  void _onPanStart(DragStartDetails details) {
    _dragStartDetails = details;
    _dragStartValue = widget.controller.rotationZNotifier.value;
    widget.controller.onStraightenStart();

    setState(() {});
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final delta = details.globalPosition - _dragStartDetails!.globalPosition;
    final dx = delta.dx;

    // TODO: Change this so that "zero" has more width
    var value = _dragStartValue! + (-dx / _width) * ((pi / 4) * 2);
    value = value.clamp(-pi / 4, pi / 4);

    widget.controller.onStraighten(angleRad: value);
  }

  void _onPanEnd(DragEndDetails details) {
    _dragStartDetails = null;
    _dragStartValue = null;
    widget.controller.onStraightenEnd();

    setState(() {});
  }

  double _computeDegreeSignWidth(BuildContext context, TextStyle? style) {
    final l10n = CroppyLocalizations.of(context)!;

    final painter = TextPainter(
      text: TextSpan(text: l10n.degreeSignCharacter, style: style),
      textDirection: TextDirection.ltr,
    );

    painter.layout();
    return painter.width;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = CroppyLocalizations.of(context)!;
    final theme = Theme.of(context);

    final color = widget.color ?? theme.colorScheme.onBackground;
    final activeColor = widget.activeColor ?? theme.colorScheme.primary;

    final labelStyle = theme.textTheme.labelMedium?.copyWith(color: color);
    final degreeSignWidth = _computeDegreeSignWidth(context, labelStyle);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: ClipRect(
        child: ValueListenableBuilder(
          valueListenable: widget.controller.rotationZNotifier,
          builder: (context, rotationZ, child) {
            final value = rotationZ / (pi / 4);

            return LayoutBuilder(
              builder: (context, constraints) {
                _width = constraints.maxWidth;

                return Column(
                  children: [
                    Transform.translate(
                      offset: Offset(degreeSignWidth / 2, 0.0),
                      child: Text(
                        l10n.getRoundedDegrees(rotationZ * 180 / pi),
                        style: labelStyle?.copyWith(
                          color: value.abs() > epsilon
                              ? theme.colorScheme.primary
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    SizedBox(
                      width: _width,
                      height: 16.0,
                      child: CustomPaint(
                        painter: _MaterialRotationSliderPainter(
                          value: value,
                          baseColor: color,
                          primaryColor: activeColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4.0),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _MaterialRotationSliderPainter extends CustomPainter {
  _MaterialRotationSliderPainter({
    required this.primaryColor,
    required this.baseColor,
    required this.value,
  });

  final Color primaryColor;
  final Color baseColor;
  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    final dividerPaint = Paint()
      ..color = baseColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final center = size.center(Offset(-size.width / 2, 0.0) * value);

    for (var i = -45; i <= 45; i++) {
      if (i % 2 != 0) continue;
      if (((i / 45) - value).abs() < 1 / 135) continue;

      final isHighlighted = i % 20 == 0;
      final x = i * (size.width / 45) / 2;
      final _paint = dividerPaint;

      final absoluteX = center.dx + x;
      final centerDiff = ((size.width / 2) - absoluteX).abs();

      var opacity = 1.0 - (centerDiff.abs() / (size.width / 2)).clamp(0, 1);
      opacity = pow(opacity, 0.35).toDouble();

      if (!isHighlighted) {
        opacity *= 0.5;
      }

      final markValue = i / 45;
      late final bool isInValueRange;

      if (markValue == 0 && value.abs() > epsilon) {
        isInValueRange = true;
      } else if (value < 0 && markValue < 0 && value < markValue) {
        isInValueRange = true;
      } else if (value > 0 && markValue > 0 && value > markValue) {
        isInValueRange = true;
      } else {
        isInValueRange = false;
      }

      final color = isInValueRange ? primaryColor : baseColor;

      final paint = Paint()
        ..color = color.withOpacity(color.opacity * opacity)
        ..style = _paint.style
        ..strokeWidth = _paint.strokeWidth;

      canvas.drawLine(
        Offset(center.dx + x, size.height / 3),
        Offset(center.dx + x, size.height),
        paint,
      );
    }

    canvas.drawLine(
      Offset(size.center(Offset.zero).dx, 0),
      Offset(size.center(Offset.zero).dx, size.height),
      Paint()
        ..color = value.abs() > epsilon ? primaryColor : baseColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
  }

  @override
  bool shouldRepaint(_MaterialRotationSliderPainter oldDelegate) =>
      primaryColor != oldDelegate.primaryColor || value != oldDelegate.value;
}
