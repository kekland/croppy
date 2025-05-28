import 'dart:math';

import 'package:flutter/cupertino.dart';

import 'package:croppy/src/src.dart';

class CupertinoRotationSlider extends StatefulWidget {
  const CupertinoRotationSlider({
    super.key,
    required this.value,
    required this.extent,
    required this.onChanged,
    required this.onStart,
    required this.onEnd,
    this.isReversed = false,
    this.activeColor,
    this.inactiveColor,
  });

  final double value;
  final double extent;
  final bool Function() onStart;
  final ValueChanged<double> onChanged;
  final VoidCallback onEnd;
  final bool isReversed;
  final Color? activeColor;
  final Color? inactiveColor;

  @override
  State<CupertinoRotationSlider> createState() =>
      _CupertinoRotationSliderState();
}

class _CupertinoRotationSliderState extends State<CupertinoRotationSlider> {
  double _width = 0.0;
  DragStartDetails? _dragStartDetails;
  double? _dragStartValue;

  void _onPanStart(DragStartDetails details) {
    if (!widget.onStart()) return;

    _dragStartDetails = details;
    _dragStartValue = widget.value;

    setState(() {});
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_dragStartDetails == null) return;

    final delta = details.globalPosition - _dragStartDetails!.globalPosition;
    var dx = delta.dx;

    if (!widget.isReversed) {
      dx = -dx;
    }

    var value = _dragStartValue! + (dx / _width) * (widget.extent * 2);
    value = value.clamp(-widget.extent, widget.extent);

    widget.onChanged(value);
  }

  void _onPanEnd(DragEndDetails details) {
    if (_dragStartDetails == null) return;

    _dragStartDetails = null;
    _dragStartValue = null;
    widget.onEnd();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var value = widget.value / widget.extent;

    if (widget.isReversed) {
      value = -value;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: ClipRect(
        child: SizedBox(
          height: 40.0,
          child: Align(
            alignment: Alignment.center,
            child: LayoutBuilder(
              builder: (context, constraints) {
                _width = constraints.maxWidth;
                return SizedBox(
                  width: _width,
                  height: 12.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeInOut,
                      opacity: value.abs() > epsilon ? 1.0 : 0.5,
                      child: CustomPaint(
                        painter: _CupertinoSliderPainter(
                          primaryColor: widget.activeColor ?? CupertinoTheme.of(context).primaryColor,
                          contrastingColor: widget.inactiveColor ?? CupertinoTheme.of(context).primaryContrastingColor,
                          value: value,
                          isDragging: _dragStartDetails != null,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _CupertinoSliderPainter extends CustomPainter {
  _CupertinoSliderPainter({
    required this.primaryColor,
    required this.value,
    this.isDragging = false,
    this.contrastingColor = CupertinoColors.white,
  });

  final Color primaryColor;
  final double value;
  final bool isDragging;
  final Color contrastingColor;

  @override
  void paint(Canvas canvas, Size size) {
    final dividerPaint = Paint()
      ..color = contrastingColor.withOpacity(0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.0;

    final highlightedDividerPaint = Paint()
      ..color = contrastingColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final outOfBoundsDividerPaint = Paint()
      ..color = contrastingColor.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.0;

    final center = size.center(Offset(-size.width / 2, 0.0) * value);

    for (var i = -20; i <= 20; i++) {
      final isHighlighted = i % 10 == 0;
      final x = i * (size.width / 20) / 2;
      var _paint = isHighlighted ? highlightedDividerPaint : dividerPaint;

      if (i > 20) {
        _paint = outOfBoundsDividerPaint;
      }

      final absoluteX = center.dx + x;
      final centerDiff = ((size.width / 2) - absoluteX).abs();

      var opacity = 1.0 - (centerDiff.abs() / (size.width / 2)).clamp(0, 1);
      opacity = sqrt(opacity);

      final paint = Paint()
        ..color = _paint.color.withOpacity(_paint.color.opacity * opacity)
        ..style = _paint.style
        ..strokeWidth = _paint.strokeWidth;

      canvas.drawLine(
        Offset(center.dx + x, 2),
        Offset(center.dx + x, size.height),
        paint,
      );
    }

    canvas.drawCircle(
      Offset(center.dx, -8.0),
      3.0,
      Paint()..color = contrastingColor,
    );

    final tickerPaint = Paint()
      ..color = isDragging ? primaryColor : contrastingColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawLine(
      Offset(size.center(Offset.zero).dx, -8),
      Offset(size.center(Offset.zero).dx, size.height),
      tickerPaint,
    );
  }

  @override
  bool shouldRepaint(_CupertinoSliderPainter oldDelegate) =>
      primaryColor != oldDelegate.primaryColor ||
      contrastingColor != oldDelegate.contrastingColor ||
      value != oldDelegate.value ||
      isDragging != oldDelegate.isDragging;
}
