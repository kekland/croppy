import 'dart:typed_data';

import 'package:croppy/src/src.dart';
import 'package:image/image.dart' as img;
import 'dart:ui' as ui;

/// The result of a crop operation.
class CropImageResult {
  const CropImageResult({
    required this.image,
    required this.transformationsData,
  });

  /// The cropped image (as an image from the `image` package).
  final img.Image image;

  /// The list of transformations applied to the image.
  final CroppableImageData transformationsData;

  /// Converts the cropped image to an image that can be used with Flutter.
  Future<ui.Image> get asUiImage async {
    ui.ImmutableBuffer buffer = await ui.ImmutableBuffer.fromUint8List(
      image.getBytes(order: img.ChannelOrder.rgba),
    );

    ui.ImageDescriptor id = ui.ImageDescriptor.raw(
      buffer,
      height: image.height,
      width: image.width,
      pixelFormat: ui.PixelFormat.rgba8888,
    );

    ui.Codec codec = await id.instantiateCodec(
      targetHeight: image.height,
      targetWidth: image.width,
    );

    ui.FrameInfo fi = await codec.getNextFrame();
    ui.Image uiImage = fi.image;
    return uiImage;
  }
}
