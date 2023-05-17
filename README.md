## croppy

[![Pub Version](https://img.shields.io/pub/v/croppy?color=turquoise)](https://pub.dev/packages/croppy)

An image cropper that Flutter deserves.

Big difference of this package from other popular ones (such as `image_cropper`) is that `croppy` runs completely in Flutter, so there's no need to launch a separate activity/view when you want to crop an image. Another benefit is that `croppy` can be completely customized to fit any of your image cropping needs.

Check out the example at https://kekland.github.io/croppy (you can scroll horizontally there).

<p float="left">
  <img src="https://github.com/kekland/croppy/raw/master/doc/assets/video.gif" width="200" />
  <img src="https://github.com/kekland/croppy/raw/master/doc/assets/image1.png" width="200" />
  <img src="https://github.com/kekland/croppy/raw/master/doc/assets/image3.png" width="200" />
</p>

## Features

- iOS Photos app-like image cropper
- Supports any linear transformations on the image: scaling, rotating, skewing, flipping, etc
- Completely customizable (will create documentation with later releases)

In progress:

- Material image cropper (something similar to Google Photos)
- Image editing module (?) (brightness, contrast, etc)
- Fixed aspect ratios
- Custom cropping shapes
- Localization
- Kickass animations

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

The return value of `showCupertinoImageCropper` is `CropImageResult`, which contains the image data encoded with the `image` package. To convert it to `dart:ui`'s `Image`, you can use `await result.asUiImage`. Check out the `image` package to convert the image to any of the supported formats (png, jpg, etc).

For a complete runnable example, see `./example`.

## Additional information

This package is still WIP, so expect some major updates along the way. Feel free to report bugs/issues on GitHub.

If you have questions, you can contact me directly at `kk.erzhan@gmail.com`.

Credits:
- https://github.com/daniyarzt for the `FitAabbInQuadSolver` class
