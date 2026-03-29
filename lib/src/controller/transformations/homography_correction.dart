import 'package:croppy/src/src.dart';
import 'package:flutter/widgets.dart';

/// A mixin that adds a perspective-correction homography tool to a
/// [BaseCroppableImageController].
///
/// When activated, the user positions four corner handles on the viewport.
/// Calling [onApplyHomographyCorrection] computes a projective transformation
/// (homography) that maps those four points to the corners of the crop rect,
/// rectifying the perspective distortion in one step.
///
/// The resulting matrix is stored in
/// [CroppableImageData.perspectiveCorrectionMatrix] and is the innermost
/// factor in [CroppableImageData.totalImageTransform]. The standard "Reset"
/// button removes it by restoring the initial data.
mixin HomographyCorrectionTransformation on BaseCroppableImageController {
  /// The current handle positions (in [CroppableImageWidget] local
  /// coordinates, which equal the overlay widget coordinates).
  ///
  /// - `null`  → tool is inactive.
  /// - non-null → tool is active; contains exactly 4 [Offset]s in
  ///   TL, TR, BR, BL order.
  final correctionHandlesNotifier = ValueNotifier<List<Offset>?>(null);

  bool get isHomographyActive => correctionHandlesNotifier.value != null;

  /// Activates the homography correction tool and places the four handles
  /// near the corners of the currently visible image area.
  ///
  /// [gesturePadding] must match the value passed to the viewport widget so
  /// that handle coordinates are consistent with the render transform.
  void onActivateHomographyCorrection({required double gesturePadding}) {
    final vSize = viewportSize;
    if (vSize == null) return;

    final vs = viewportScale;
    final cw = data.cropRect.width;
    final ch = data.cropRect.height;
    // Centering offset: the image may not fill the full viewport.
    final cx = (vSize.width - cw * vs) / 2;
    final cy = (vSize.height - ch * vs) / 2;
    final gp = gesturePadding;

    // Place handles exactly at the crop rect corners.
    correctionHandlesNotifier.value = [
      Offset(cx + gp, cy + gp),                    // TL
      Offset(cx + gp + cw * vs, cy + gp),           // TR
      Offset(cx + gp + cw * vs, cy + gp + ch * vs), // BR
      Offset(cx + gp, cy + gp + ch * vs),            // BL
    ];
  }

  /// Moves a single handle by replacing its position.
  ///
  /// [index] is 0=TL, 1=TR, 2=BR, 3=BL.
  void onMoveHomographyCorrectionHandle(int index, Offset newPosition) {
    final current = correctionHandlesNotifier.value;
    if (current == null) return;
    final updated = List<Offset>.from(current);
    updated[index] = newPosition;
    correctionHandlesNotifier.value = updated;
  }

  /// Computes the homography from the current handle positions to the crop
  /// rect corners, applies it to the model, then resets the handles to the
  /// viewport corners for a potential follow-up correction.
  ///
  /// [gesturePadding] must match the value used in [onActivateHomographyCorrection].
  void onApplyHomographyCorrection({required double gesturePadding}) {
    final handles = correctionHandlesNotifier.value;
    if (handles == null || handles.length != 4) return;

    final vs = viewportScale;
    final vSize = viewportSize!;

    // The image may not fill the full viewport if its aspect ratio differs.
    // The render object centres it, adding (cx, cy) of black padding on each
    // side before the gesture padding.  We must subtract this centering offset
    // when converting overlay coords → render-object-local coords.
    final cx = (vSize.width - data.cropRect.width * vs) / 2;
    final cy = (vSize.height - data.cropRect.height * vs) / 2;
    final renderOrigin = Offset(cx + gesturePadding, cy + gesturePadding);

    // Build the render transform that maps image coords → render-object-local
    // coords (i.e. coords relative to renderOrigin).
    // Mirrors CroppableImageRenderObject.paint().
    final scaleT = Matrix4.identity()..scale(vs);
    final translateT = Matrix4.identity()
      ..translate(-data.cropRect.left, -data.cropRect.top);
    final renderMatrix = scaleT * translateT * data.totalImageTransform;
    final renderMatrixInv = Matrix4.inverted(renderMatrix);

    // Convert each handle from overlay coords to raw image coords.
    final srcPoints = handles.map((h) {
      final shifted = h - renderOrigin;
      return MatrixUtils.transformPoint(renderMatrixInv, shifted);
    }).toList();

    // Destination: the four corners of the crop rect (TL, TR, BR, BL).
    final cr = data.cropRect;
    final dstPoints = [cr.topLeft, cr.topRight, cr.bottomRight, cr.bottomLeft];

    final hMatrix = computeHomography(srcPoints, dstPoints);
    data = data.copyWith(perspectiveCorrectionMatrix: hMatrix);

    // Reset handles to viewport corners for a potential re-correction.
    onActivateHomographyCorrection(gesturePadding: gesturePadding);
  }

  /// Deactivates the homography correction tool and hides the overlay.
  /// The last applied correction (if any) remains in the model.
  void onDeactivateHomographyCorrection() {
    correctionHandlesNotifier.value = null;
  }

  @override
  void dispose() {
    correctionHandlesNotifier.dispose();
    super.dispose();
  }
}
