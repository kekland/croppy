import 'dart:math';

import 'package:croppy/src/src.dart';
import 'package:flutter/cupertino.dart';

class CupertinoRotationSlider extends StatefulWidget {
  const CupertinoRotationSlider({
    super.key,
    required this.value,
    required this.extent,
    required this.onChanged,
    required this.onStart,
    required this.onEnd,
  });

  final double value;
  final double extent;
  final VoidCallback onStart;
  final ValueChanged<double> onChanged;
  final VoidCallback onEnd;

  @override
  State<CupertinoRotationSlider> createState() =>
      _CupertinoRotationSliderState();
}

class _CupertinoRotationSliderState extends State<CupertinoRotationSlider> {
  double _width = 0.0;
  DragStartDetails? _dragStartDetails;
  double? _dragStartValue;

  void _onPanStart(DragStartDetails details) {
    _dragStartDetails = details;
    _dragStartValue = widget.value;
    widget.onStart();

    setState(() {});
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final delta = details.globalPosition - _dragStartDetails!.globalPosition;

    var value = _dragStartValue! + (-delta.dx / _width) * (widget.extent * 2);
    value = value.clamp(-widget.extent, widget.extent);

    widget.onChanged(value);
  }

  void _onPanEnd(DragEndDetails details) {
    _dragStartDetails = null;
    _dragStartValue = null;
    widget.onEnd();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              opacity: widget.value == 0 ? 0.5 : 1.0,
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
                        opacity: widget.value.abs() > epsilon ? 1.0 : 0.5,
                        child: CustomPaint(
                          painter: _CupertinoSliderPainter(
                            primaryColor:
                                CupertinoTheme.of(context).primaryColor,
                            value: widget.value / widget.extent,
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
      ),
    );
  }
}

class _CupertinoSliderPainter extends CustomPainter {
  _CupertinoSliderPainter({
    required this.primaryColor,
    required this.value,
    this.isDragging = false,
  });

  final Color primaryColor;
  final double value;
  final bool isDragging;

  @override
  void paint(Canvas canvas, Size size) {
    final dividerPaint = Paint()
      ..color = CupertinoColors.white.withOpacity(0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.0;

    final highlightedDividerPaint = Paint()
      ..color = CupertinoColors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final outOfBoundsDividerPaint = Paint()
      ..color = CupertinoColors.white.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.0;

    final center = size.center(Offset(-size.width / 2, 0.0) * value);

    for (var i = -20; i <= 20; i++) {
      final isHighlighted = i % 10 == 0;
      final x = i * (size.width / 20) / 2;
      var paint = isHighlighted ? highlightedDividerPaint : dividerPaint;

      if (i > 20) {
        paint = outOfBoundsDividerPaint;
      }

      final absoluteX = center.dx + x;
      final centerDiff = ((size.width / 2) - absoluteX).abs();

      var opacity = 1.0 - (centerDiff.abs() / (size.width / 2)).clamp(0, 1);
      opacity = sqrt(opacity);

      paint = Paint()
        ..color = paint.color.withOpacity(opacity)
        ..style = paint.style
        ..strokeWidth = paint.strokeWidth;

      canvas.drawLine(
        Offset(center.dx + x, 2),
        Offset(center.dx + x, size.height),
        paint,
      );
    }

    canvas.drawCircle(
      Offset(center.dx, -8.0),
      3.0,
      Paint()..color = CupertinoColors.white,
    );

    final tickerPaint = Paint()
      ..color = isDragging ? primaryColor : CupertinoColors.white
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
      value != oldDelegate.value ||
      isDragging != oldDelegate.isDragging;
}
