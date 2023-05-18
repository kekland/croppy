// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:ui' as ui;

import 'package:croppy/src/model/_model.dart';
import 'package:flutter/material.dart';

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
/// Internally, this uses [ui.PictureRecorder] and [Canvas] to draw the image
/// onto a canvas, and then crops the canvas to the crop rect.
Future<CropImageResult> cropImage(
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
