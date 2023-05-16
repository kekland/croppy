import 'dart:typed_data';

import 'package:croppy/src/src.dart';
import 'package:flutter/cupertino.dart';

Future<Uint8List?> showCupertinoImageCropper(
  BuildContext context, {
  required ImageProvider imageProvider,
  required Size imageSize,
}) async {
  final controller = CupertinoCroppableImageController(
    imageProvider: imageProvider,
    data: CroppableImageData.initial(
      imageSize: imageSize,
    ),
  );

  final result = await Navigator.of(context).push<Uint8List?>(
    CupertinoPageRoute(
      builder: (context) {
        return CupertinoImageCropperPage(
          controller: controller,
        );
      },
    ),
  );

  controller.dispose();

  return result;
}
