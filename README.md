## croppy

[![Pub Version](https://img.shields.io/pub/v/croppy?color=turquoise)](https://pub.dev/packages/croppy)

An image cropper that Flutter deserves.

Big difference of this package from other popular ones (such as `image_cropper`) is that `croppy` runs completely in Flutter, so there's no need to launch a separate activity/view when you want to crop an image. Another benefit is that `croppy` can be completely customized to fit any of your image cropping needs.

Check out the example at https://kekland.github.io/croppy (you can scroll horizontally there).

<p float="left">
  <img src="https://github.com/kekland/croppy/raw/master/doc/assets/video.gif" width="160" />
  <img src="https://github.com/kekland/croppy/raw/master/doc/assets/image1.png" width="160" />
  <img src="https://github.com/kekland/croppy/raw/master/doc/assets/image2.png" width="160" />
  <img src="https://github.com/kekland/croppy/raw/master/doc/assets/image3.png" width="160" />
</p>

## Features

- iOS Photos app-like image cropper
- Supports any linear transformations on the image: scaling, rotating, skewing, flipping, etc
- Completely customizable (will create documentation with later releases)
- Fixed aspect ratios
- Kickass animations
- Custom cropping shapes

In progress:

- Material image cropper (something similar to Google Photos)
- Image editing module (?) (brightness, contrast, etc)
- Localization

## Getting started

Install `croppy` from `pub`:

```yaml
dependencies:
  croppy: <latest_version>
```

Enjoy using it :)

## Usage

Currently `croppy` supports an iOS-like image cropper:

```dart
final result = await showCupertinoImageCropper(
  context,
  imageProvider: const NetworkImage('MY_IMAGE_URL'), // Or any other image provider
);
```

`showCupertinoImageCropper` accepts the following arguments:

- `imageProvider` - an image provider that will be used to load the image. You can use any image provider, such as `NetworkImage`, `FileImage`, `MemoryImage`, etc.

- `CroppableImageData? initialData` - an optional argument that can be used to provide initial data for the crop editor. If not provided, the image will be loaded from the `imageProvider` and the crop editor will be initialized with the image's size.

- `CroppableImagePostProcessFn? postProcessFn` - an optional argument that can be used to provide a function that will be called after the user finishes cropping the image, but before the cropper is closed. This function can be used to perform any additional processing on the image, such as compressing it, etc. The function accepts `CropImageResult` as an argument (see below for more information).

- `CropShapeFn? cropPathFn` - an optional argument that can be used to provide a function that will be used as a custom crop path. The function accepts `Size` as an argument and should return a `CropShape` that will be used as a crop shape. By default, `aabbCropShapeFn` is used, which will crop the image with a rectangle. For ellipses or circles - there's `ellipseCropShapeFn`. See the `CropShape` method for more information.

- `List<CropAspectRatio?>? allowedAspectRatios` - an optional argument that can be used to provide a list of allowed aspect ratios. If not provided, the user will be able to crop the image with any aspect ratio. A `null` value in the list means that any aspect ratio is allowed. See the `CropAspectRatio` class for more information.

- `List<Transformation>? enabledTransformations` - an optional argument that can be used to provide a list of transformations that will be enabled in the cropper. If not provided, all transformations will be enabled. See the `Transformation` class for more information.

- `Object? heroTag` - an optional argument that can be used to provide a hero tag for the cropper. If provided, the cropper will be opened with a hero animation. See the documentation for information about the constraints of using hero animations with `croppy`.

The return value of `showCupertinoImageCropper` is `CropImageResult`, which contains the image data encoded with the `image` package. To convert it to `dart:ui`'s `Image`, you can use `await result.asUiImage`. Check out the `image` package to convert the image to any of the supported formats (png, jpg, etc).

For a complete runnable example, see `./example`.

## Additional information

This package is still WIP, so expect some major updates along the way. Feel free to report bugs/issues on GitHub.

If you have questions, you can contact me directly at `kk.erzhan@gmail.com`.

Credits:
- https://github.com/daniyarzt for the `FitAabbInQuadSolver` class
