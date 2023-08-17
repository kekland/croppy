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
///
/// Use the [cropPathFn] to define a custom crop shape. If not provided, the
/// default crop shape is a rectangle.
///
/// Use the [allowedAspectRatios] to define a list of aspect ratios that the
/// user can choose from. If not provided, the user can choose any aspect ratio.
/// See [CropAspectRatio] for more information.
///
/// Use the [enabledTransformations] to define a list of transformations that
/// the user can perform. If not provided, the user can apply any
/// transformations. See [Transformation] for a list of every transformation.
///
/// [shouldPopAfterCrop] defines whether the page should be popped after the
/// image has been cropped. If you want to control how the page is popped, set
/// this to false and pop the page yourself using the [Navigator].
///
/// The [locale] is used to localize the UI. If not provided, the locale from
/// the [WidgetsApp] is used.
Future<CropImageResult?> showCupertinoImageCropper(
  BuildContext context, {
  required ImageProvider imageProvider,
  CroppableImageData? initialData,
  CroppableImagePostProcessFn? postProcessFn,
  CropShapeFn? cropPathFn,
  List<CropAspectRatio?>? allowedAspectRatios,
  List<Transformation>? enabledTransformations,
  Object? heroTag,
  bool shouldPopAfterCrop = true,
  Locale? locale,
}) async {
  late final CroppableImageData _initialData;

  if (initialData != null) {
    _initialData = initialData;
  } else {
    _initialData = await CroppableImageData.fromImageProvider(
      imageProvider,
      cropPathFn: cropPathFn ?? aabbCropShapeFn,
    );
  }

  Widget builder(context) {
    return CroppyLocalizationProvider(
      locale: locale,
      child: DefaultCupertinoCroppableImageController(
        imageProvider: imageProvider,
        initialData: _initialData,
        postProcessFn: postProcessFn,
        cropShapeFn: cropPathFn,
        allowedAspectRatios: allowedAspectRatios,
        enabledTransformations: enabledTransformations,
        builder: (context, controller) => CupertinoImageCropperPage(
          heroTag: heroTag,
          controller: controller,
          shouldPopAfterCrop: shouldPopAfterCrop,
        ),
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
