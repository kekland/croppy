import 'package:croppy/src/src.dart';
import 'package:flutter/cupertino.dart';

/// Shows a [CupertinoImageCropperPage] and returns the cropped image.
/// 
/// The [imageProvider] is the image that will be cropped.
/// 
/// The [initialData] is the initial crop data. Use 
/// [CroppableImageData.initial(imageSize: imageSize)] to create it.
Future<CropImageResult?> showCupertinoImageCropper(
  BuildContext context, {
  required ImageProvider imageProvider,
  required CroppableImageData initialData,
}) async {
  return Navigator.of(context).push<CropImageResult?>(
    CupertinoPageRoute(
      builder: (context) {
        return DefaultCupertinoCroppableImageController(
          imageProvider: imageProvider,
          initialData: initialData,
          builder: (context, controller) => CupertinoImageCropperPage(
            controller: controller,
          ),
        );
      },
    ),
  );
}
