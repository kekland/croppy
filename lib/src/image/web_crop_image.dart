// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:croppy/src/src.dart';
import 'package:flutter/material.dart';

// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

/// Obtains an [ui.Image] from an [ImageProvider].
Future<ui.Image> obtainImage(ImageProvider provider) {
  final completer = Completer<ui.Image>();

  provider
      .resolve(ImageConfiguration.empty)
      .addListener(ImageStreamListener((ImageInfo info, bool _) {
    completer.complete(info.image);
  }));

  return completer.future;
}

/// Crops an [ui.Image] using the [CroppableImageData] and returns the cropped
/// image as a [CropImageResult].
///
/// Internally, this uses [ui.Image.toByteData] to obtain the original image's
/// pixel data, and then computes the cropped image's pixel data from that,
/// smoothing with bilinear interpolation.
Future<CropImageResult> cropImageBilinear(
  ui.Image image,
  CroppableImageData data,
) async {
  final byteData = (await image.toByteData())!;

  final cropRect = data.cropRect;
  final roundedCropRect = (
    l: cropRect.left.round(),
    t: cropRect.top.round(),
    w: cropRect.width.round(),
    h: cropRect.height.round(),
  );

  final inverseTransform = Matrix4.copy(data.totalImageTransform);
  inverseTransform.invert();

  (int, int, int, int) getOriginalImagePixel(int x, int y) {
    if (x < 0 || x >= image.width || y < 0 || y >= image.height) {
      return (0, 0, 0, 0);
    }

    final index = (y * image.width + x) * 4;
    final r = byteData.getUint8(index);
    final g = byteData.getUint8(index + 1);
    final b = byteData.getUint8(index + 2);
    final a = byteData.getUint8(index + 3);

    return (r, g, b, a);
  }

  /// Copilot wrote this. Seems to work.
  (int, int, int, int) getBilinearlyInterpolatedOriginalImagePixel(
    double x,
    double y,
  ) {
    final x1 = x.floor();
    final x2 = x1 + 1;
    final y1 = y.floor();
    final y2 = y1 + 1;

    final (r1, g1, b1, a1) = getOriginalImagePixel(x1, y1);
    final (r2, g2, b2, a2) = getOriginalImagePixel(x2, y1);
    final (r3, g3, b3, a3) = getOriginalImagePixel(x1, y2);
    final (r4, g4, b4, a4) = getOriginalImagePixel(x2, y2);

    final r = (r1 * (x2 - x) * (y2 - y)) +
        (r2 * (x - x1) * (y2 - y)) +
        (r3 * (x2 - x) * (y - y1)) +
        (r4 * (x - x1) * (y - y1));
    final g = (g1 * (x2 - x) * (y2 - y)) +
        (g2 * (x - x1) * (y2 - y)) +
        (g3 * (x2 - x) * (y - y1)) +
        (g4 * (x - x1) * (y - y1));
    final b = (b1 * (x2 - x) * (y2 - y)) +
        (b2 * (x - x1) * (y2 - y)) +
        (b3 * (x2 - x) * (y - y1)) +
        (b4 * (x - x1) * (y - y1));
    final a = (a1 * (x2 - x) * (y2 - y)) +
        (a2 * (x - x1) * (y2 - y)) +
        (a3 * (x2 - x) * (y - y1)) +
        (a4 * (x - x1) * (y - y1));

    return (r.round(), g.round(), b.round(), a.round());
  }

  final bytes = Uint8List(roundedCropRect.w * roundedCropRect.h * 4);

  final cropPath = data.cropShape.vgPath.toUiPath();

  // TODO: Somehow optimize this. Maybe `ffi`?
  //
  // TODO: Doesn't work properly with perspectives :(
  for (var x = 0; x < roundedCropRect.w; x++) {
    for (var y = 0; y < roundedCropRect.h; y++) {
      if (!cropPath.contains(Offset(x.toDouble(), y.toDouble()))) continue;

      final point = Offset(
        cropRect.left + x,
        cropRect.top + y,
      );

      final transformedPoint = inverseTransform.transform3(point.vector3);

      final (r, g, b, a) = getBilinearlyInterpolatedOriginalImagePixel(
        transformedPoint.x,
        transformedPoint.y,
      );

      final index = (y * roundedCropRect.w + x) * 4;
      bytes[index] = r;
      bytes[index + 1] = g;
      bytes[index + 2] = b;
      bytes[index + 3] = a;
    }
  }

  final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
  final id = ui.ImageDescriptor.raw(
    buffer,
    height: roundedCropRect.h,
    width: roundedCropRect.w,
    pixelFormat: ui.PixelFormat.rgba8888,
  );

  final codec = await id.instantiateCodec(
    targetHeight: roundedCropRect.h,
    targetWidth: roundedCropRect.w,
  );

  final fi = await codec.getNextFrame();
  final uiImage = fi.image;

  return CropImageResult(
    uiImage: uiImage,
    transformationsData: data.copyWith(),
  );
}

/// Crops an [ui.Image] using the [CroppableImageData] and returns the cropped
/// image as a [CropImageResult].
///
/// Internally, this uses [ui.PictureRecorder] and [Canvas] to draw the image
/// onto a canvas, and then crops the canvas to the crop rect.
Future<CropImageResult> cropImageCanvas(
  ui.Image image,
  CroppableImageData data,
) async {
  final pictureRecorder = ui.PictureRecorder();

  final canvas = Canvas(pictureRecorder);
  final cropRect = data.cropRect;

  canvas.clipPath(data.cropShape.vgPath.toUiPath());

  canvas.translate(-cropRect.left, -cropRect.top);
  canvas.transform(data.totalImageTransform.storage);

  canvas.drawImage(
    image,
    Offset.zero,
    Paint()..filterQuality = FilterQuality.none,
  );

  final croppedImage = await pictureRecorder.endRecording().toImage(
        cropRect.width.round(),
        cropRect.height.round(),
      );

  return CropImageResult(
    uiImage: croppedImage,
    transformationsData: data,
  );
}

Future<CropImageResult> cropImage(
  ui.Image image,
  CroppableImageData data,
) {
  if (js.context['flutterCanvasKit'] != null) {
    return cropImageCanvas(image, data);
  }

  // For some reason, the canvas method doesn't work properly on web HTML
  // renderer. So, we use the bilinear method for now.
  //
  // My suspicion is that the canvas method doesn't work because the canvas
  // doesn't support 3d transforms. So, the canvas is not able to apply the
  // perspective transform.
  //
  // TODO(Erzhan): Investigate this further.
  return cropImageBilinear(image, data);
}
