![Cover image](./doc/assets/cover.jpg)

# croppy

[![Pub Version](https://img.shields.io/pub/v/croppy?color=turquoise)](https://pub.dev/packages/croppy)

An image cropper that Flutter deserves.

Big difference of this package from other popular ones (such as `image_cropper`) is that `croppy` runs completely in Flutter, so there's no need to launch a separate activity/view when you want to crop an image. Another benefit is that `croppy` can be completely customized to fit any of your image cropping needs.

Check out the example at https://kekland.github.io/croppy.

<p float="left">
  <img src="https://github.com/kekland/croppy/raw/master/doc/assets/video.gif" width="160" />
  <img src="https://github.com/kekland/croppy/raw/master/doc/assets/image1.png" width="160" />
  <img src="https://github.com/kekland/croppy/raw/master/doc/assets/image2.png" width="160" />
  <img src="https://github.com/kekland/croppy/raw/master/doc/assets/image3.png" width="160" />
</p>

Supported platforms:
- Android 
- iOS
- Windows
- Linux (untested, but should work)
- macOS
- Web (uses Dart's Cassowary instead of FFI because there's no FFI support in web)

## Features

- Material image cropper (similar to Google Photos)
- iOS Photos app-like image cropper
- Support for any linear transformations on the image: scaling, rotating, skewing, flipping, etc
- Completely customizable (will create documentation with later releases)
- Fixed aspect ratios
- Custom cropping shapes
- Kickass animations

In progress:

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

Currently `croppy` supports a Material (Google Photos-like) and a Cupertino (iOS Photos-like) image croppers:

```dart
final result = await showMaterialImageCropper(
  context,
  imageProvider: const NetworkImage('MY_IMAGE_URL'), // Or any other image provider
);

final result = await showCupertinoImageCropper(
  context,
  imageProvider: const NetworkImage('MY_IMAGE_URL'), // Or any other image provider
);
```

Voilà! You can now start cropping images.

For a complete runnable example, see `./example`. For the full in-depth documentation, including customization, see the [documentation](./doc/doc.md).

## Additional information

This package is still WIP, so expect some major updates along the way. Feel free to report bugs/issues on GitHub.

If you have questions, you can contact me directly at `kk.erzhan@gmail.com`.

Credits:
- https://github.com/daniyarzt for the `FitAabbInQuadSolver` class
