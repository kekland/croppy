import 'package:croppy/src/src.dart';
import 'package:flutter/cupertino.dart';

/// Shows a [CupertinoImageCropperPage] and returns the cropped image.
///
/// The [imageProvider] is the image that will be cropped.
///
/// The [initialData] is the initial crop data. Use
/// [CroppableImageData.initial(imageSize: imageSize)] to create it.
/// 
/// The [heroTag] is used to create a hero animation between the image
/// preview and the crop page. If you don't want a hero animation, pass null.
/// 
/// The [postProcessFn] is a function that is called after the image has been
/// cropped. Use it to, for example, compress the image, or update the state in
/// the preview page.
Future<CropImageResult?> showCupertinoImageCropper(
  BuildContext context, {
  required ImageProvider imageProvider,
  required CroppableImageData initialData,
  CroppableImagePostProcessFn? postProcessFn,
  Object? heroTag,
}) async {
  Widget builder(context) {
    return DefaultCupertinoCroppableImageController(
      imageProvider: imageProvider,
      initialData: initialData,
      postProcessFn: postProcessFn,
      builder: (context, controller) => CupertinoImageCropperPage(
        heroTag: heroTag,
        controller: controller,
      ),
    );
  }

  return Navigator.of(context).push<CropImageResult?>(
    heroTag != null
        ? CupertinoImageCropperWithHeroRoute(builder: builder)
        : CupertinoPageRoute(builder: builder),
  );
}
