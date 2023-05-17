// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:ui' as ui;

import 'package:croppy/src/model/_model.dart';
import 'package:flutter/material.dart';

import 'package:image/image.dart' as img;

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
@Deprecated('Use [cropImageCanvas] instead')
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
    late int _x, _y;

    if (x < 0) {
      _x = 0;
    } else if (x >= image.width) {
      _x = image.width - 1;
    } else {
      _x = x;
    }

    if (y < 0) {
      _y = 0;
    } else if (y >= image.height) {
      _y = image.height - 1;
    } else {
      _y = y;
    }

    final index = (_y * image.width + _x) * 4;
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

  final resultImage = img.Image(
    width: roundedCropRect.w,
    height: roundedCropRect.h,
  );

  final imageData = img.ImageDataUint8(
    roundedCropRect.w,
    roundedCropRect.h,
    4,
  );

  for (var x = 0; x < roundedCropRect.w; x++) {
    for (var y = 0; y < roundedCropRect.h; y++) {
      final point = Offset(
        cropRect.left + x,
        cropRect.top + y,
      );

      final transformedPoint = MatrixUtils.transformPoint(
        inverseTransform,
        point,
      );

      final (r, g, b, a) = getBilinearlyInterpolatedOriginalImagePixel(
        transformedPoint.dx,
        transformedPoint.dy,
      );

      imageData.setPixelRgbaSafe(x, y, r, g, b, a);
    }
  }

  resultImage.data = imageData;

  return CropImageResult(
    image: resultImage,
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

  canvas.translate(-cropRect.left, -cropRect.top);
  canvas.clipRect(cropRect);

  canvas.transform(data.totalImageTransform.storage);

  canvas.drawImage(
    image,
    Offset.zero,
    Paint()..filterQuality = FilterQuality.high,
  );

  final croppedImage = await pictureRecorder.endRecording().toImage(
        cropRect.width.round(),
        cropRect.height.round(),
      );

  final imgImage = img.Image.fromBytes(
    width: croppedImage.width,
    height: croppedImage.height,
    bytes: (await croppedImage.toByteData())!.buffer,
    numChannels: 4,
  );

  croppedImage.dispose();

  return CropImageResult(
    image: imgImage,
    transformationsData: data,
  );

  // Canvas(pictureRecorder).drawImageRect(
  //   image,
  //   cropSize,
  //   Offset.zero & cropSize.size,
  //   Paint()..filterQuality = quality,
  // );
  // return await pictureRecorder
  //     .endRecording()
  //     .toImage(cropSize.width.round(), cropSize.height.round());
}
