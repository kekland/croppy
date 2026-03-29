import 'package:croppy/src/src.dart';
import 'package:flutter/cupertino.dart';

/// Radius of each circular drag handle.
const _kHandleRadius = 18.0;

/// The overlay widget that renders the four draggable corner handles and the
/// connecting quadrilateral lines for the homography correction tool.
///
/// This widget is placed in the same [FittedBox] slot as [CroppableImageWidget],
/// so its local coordinate space matches the image widget exactly.
///
/// Handle initialisation is deferred to the first layout so that widget
/// dimensions are available. Once [correctionHandlesNotifier] has a non-null
/// value the handles are rendered and become interactive.
class CupertinoHomographyHandles extends StatefulWidget {
  const CupertinoHomographyHandles({
    super.key,
    required this.controller,
    required this.gesturePadding,
  });

  final CroppableImageController controller;
  final double gesturePadding;

  @override
  State<CupertinoHomographyHandles> createState() =>
      _CupertinoHomographyHandlesState();
}

class _CupertinoHomographyHandlesState
    extends State<CupertinoHomographyHandles> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;

        return ValueListenableBuilder<List<Offset>?>(
          valueListenable: widget.controller.correctionHandlesNotifier,
          builder: (context, handles, _) {
            // On first appearance the handles may not be initialised yet
            // (viewportSize might have been unavailable at activation time).
            // Initialise them from the actual widget size.
            if (handles == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                _initHandles(size);
              });
              return const SizedBox.expand();
            }

            return Stack(
              clipBehavior: Clip.none,
              children: [
                // Connecting lines.
                Positioned.fill(
                  child: CustomPaint(
                    painter: _HomographyLinesPainter(handles),
                  ),
                ),
                // Four draggable handles.
                for (int i = 0; i < 4; i++)
                  Positioned(
                    left: handles[i].dx - _kHandleRadius,
                    top: handles[i].dy - _kHandleRadius,
                    width: _kHandleRadius * 2,
                    height: _kHandleRadius * 2,
                    child: _HomographyHandle(
                      index: i,
                      position: handles[i],
                      widgetSize: size,
                      onDelta: (delta) {
                        final updated = List<Offset>.from(handles);
                        final next = updated[i] + delta;
                        // Clamp to widget bounds.
                        updated[i] = Offset(
                          next.dx.clamp(0.0, size.width),
                          next.dy.clamp(0.0, size.height),
                        );
                        widget.controller.correctionHandlesNotifier.value =
                            updated;
                      },
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  void _initHandles(Size size) {
    if (!widget.controller.isHomographyActive) return;
    widget.controller.onActivateHomographyCorrection(
      gesturePadding: widget.gesturePadding,
    );
  }
}

// ---------------------------------------------------------------------------
// Handle widget
// ---------------------------------------------------------------------------

class _HomographyHandle extends StatelessWidget {
  const _HomographyHandle({
    required this.index,
    required this.position,
    required this.widgetSize,
    required this.onDelta,
  });

  final int index;
  final Offset position;
  final Size widgetSize;
  final ValueChanged<Offset> onDelta;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanUpdate: (details) => onDelta(details.delta),
      child: Container(
        width: _kHandleRadius * 2,
        height: _kHandleRadius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: CupertinoColors.white.withOpacity(0.25),
          border: Border.all(
            color: CupertinoColors.white.withOpacity(0.85),
            width: 2.0,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x44000000),
              blurRadius: 4.0,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Lines painter
// ---------------------------------------------------------------------------

class _HomographyLinesPainter extends CustomPainter {
  const _HomographyLinesPainter(this.handles);

  final List<Offset> handles;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CupertinoColors.white.withOpacity(0.75)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    // Draw quadrilateral: TL → TR → BR → BL → TL.
    final path = Path()
      ..moveTo(handles[0].dx, handles[0].dy)
      ..lineTo(handles[1].dx, handles[1].dy)
      ..lineTo(handles[2].dx, handles[2].dy)
      ..lineTo(handles[3].dx, handles[3].dy)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_HomographyLinesPainter old) =>
      old.handles != handles;
}
