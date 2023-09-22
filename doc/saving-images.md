# Saving and uploading images

By default, `croppy` will return the raw bitmap of the image using `ui.Image` (class from `dart:ui`). After this, to save the image as a local file you can use the `image.toByteData()` method to convert the bitmap to PNG.

```dart
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'dart:io';

final cropResult = ...;

final image = cropResult.image;
final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

// For example, save the file to the app's temporary directory
final temp = await getTemporaryDirectory();
final file = File('${temp.path}/my_image.png');

// Write the png bytes to the file
await file.writeAsBytes(bytes!.buffer.asUint8List());

// Dispose the image if it's no longer needed (e.g. you don't use it in the UI)
image.dispose();

// Now, [file] contains the cropped image
await myApi.uploadImage(file);
```

In order for this method to run when the "Save" button is pressed, before popping the page, you can put a call to it in the `postProcessFn` argument of the cropper. This will cause this function to run after the crop is finished, but before the page is popped.

```dart
final cropResult = await showMaterialImageCropper(
  context,
  imageProvider: const NetworkImage('MY_IMAGE_URL'),
  postProcessFn: (cropResult) async {
    final image = cropResult.image;

    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    // etc.
  },
);
```

Alternatively, if you can upload the raw bytedata directly, you can send the results from the `bytes` variable directly instead of saving it to a file.

If you want any other formats, you can take a look at the `image` package: https://pub.dev/packages/image, which allows you to convert the `dart:ui.Image` to its own image format, and the convert that to practically any other format.

For any other information, feel free to open an issue or contact me via email: 
- kk.erzhan@gmail.com