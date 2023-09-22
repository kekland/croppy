## 1.1.4

* Added Portuguese localization (thanks @JCKodel)
* Added documentation on how to save a cropped image to a file

## 1.1.3

* Added Vietnamese localization (thanks @ptanhVNU)

## 1.1.2

* Croppy shouldn't fail when being launched with unsupported locales. Now it will default to English.

## 1.1.1

* Added Arabic localization (thanks @Milad-Akarie)

## 1.1.0

* Added localization! Currently supports English, Kazakh, and Russian.
* Added documentation on how to add your own localization, or override an existing one.

## 1.0.1

* Loosened the constraint to `3.13.0-0.3.pre` to pass Pub analysis

## 1.0.0

* Major breaking version. Updated to support Flutter 3.13.

## 0.2.6

* Fix: Disallow tapping the "Done" button twice. This could trigger some weird behavior if you're using custom asynchronous operations when the cropper is cropping images.

## 0.2.5

* Fix: Rotating an image with a forced aspect ratio inverts the aspect ratio (#7). Thanks @maRci002 and @siranov for the bug reports!

## 0.2.4

* Hotfix: Cupertino cropper's `TransformationFrictionMixin` was not respecting fixed aspect ratios

## 0.2.3

* You can now create your own custom croppers easily! Check out the documentation and the example app for more info.
* Added documentation

## 0.2.2

* Added `shouldPopAfterCrop`

## 0.2.1

* Accidentally dropped support for Web because of FFI - fixed.

## 0.2.0

* Added a Material image cropper
* FFI-based implementation for normalization of the image crop rect
* Performance improvements and bugfixes

## 0.1.0

* Added custom shapes
* Added allowed aspect ratios
* Added supported transformations list
* Minor design tweaks
* Better image cropping algorithm (now uses Flutter's Canvas instead of a barebones bilinear interpolation)
* Bugfixes

## 0.0.4

* Updated the example app
* Performance improvements to the Cupertino cropper
* Minor design tweaks
* Added an example webapp

## 0.0.3

* Implemented a new UI for the Cupertino cropper
* Added `heroTag` parameters - if passed, the cropper will be animated with a Hero animation

## 0.0.2

* Fixed images not linking properly in README

## 0.0.1

* Initial release!
