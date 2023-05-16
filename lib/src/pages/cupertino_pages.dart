// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:croppy/src/src.dart';
import 'package:flutter/cupertino.dart';

/// Shows a [CupertinoImageCropperPage] and returns the cropped image.
///
/// The [imageProvider] is the image that will be cropped.
///
/// The [initialData] is the initial crop data. If not provided, the image will
/// be shown in full size. There might be a small delay before the cropper is
/// shown, because the image needs to be loaded first (if it's in the cache, 
/// then the delay is practically zero).
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
  CroppableImageData? initialData,
  CroppableImagePostProcessFn? postProcessFn,
  Object? heroTag,
}) async {
  late final CroppableImageData _initialData;

  if (initialData != null) {
    _initialData = initialData;
  } else {
    final image = await obtainImage(imageProvider);
    _initialData = CroppableImageData.initial(
      imageSize: Size(
        image.width.toDouble(),
        image.height.toDouble(),
      ),
    );
  }

  Widget builder(context) {
    return DefaultCupertinoCroppableImageController(
      imageProvider: imageProvider,
      initialData: _initialData,
      postProcessFn: postProcessFn,
      builder: (context, controller) => CupertinoImageCropperPage(
        heroTag: heroTag,
        controller: controller,
      ),
    );
  }

  if (context.mounted) {
    return Navigator.of(context).push<CropImageResult?>(
      heroTag != null
          ? CupertinoImageCropperWithHeroRoute(builder: builder)
          : CupertinoPageRoute(builder: builder),
    );
  }

  return null;
}
