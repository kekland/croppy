## 1.4.0

* Updated `compileSdkVersion` to `36` (thanks @jimmyff and @kaiquecruz)!
* Updated `Gradle` to `8.13` (thanks @jimmyff and @kaiquecruz)!
* Updated `ndkVersion` to `27.0.12077973` (thanks @jimmyff and @kaiquecruz)!
* Updated `minSdkVersion` to `23` (thanks @jimmyff and @kaiquecruz)!
* Ensured 16kb memory page size compatibility on Android
* Added Turkish localization (thanks @BayramYARIM)!
* Fix a null-check operator issue on resize (thanks @tusharbhambere)!

## 1.3.6

* Added a parameter called `showGestureHandlesOn` to control for which crop shapes the gesture handles should be shown. This allows you to, for example, show the rectangular gesture handles on a circular crop shape. Thanks @denysbohatyrov!
* Added Persian localization (thanks @mdpe-ir)!
* Added an `showAdaptiveImageCropper` method that will automatically launch the correct cropper depending on the platform.
* Fixed a couple of issues with multiple transformations being applied at the same time.

## 1.3.5

* Added minimum crop dimension, which can be specified with the `minimumCropDimension` parameter. Defaults to 8.0. Any attempt to transform the crop rect to a size smaller than this will be ignored.

## 1.3.4

* Added mouse wheel and trackpad zooming (thanks @denysbohatyrov!).

## 1.3.3

* Reverted changes to `.withValues` and `.a` usage on colors, since the package currently targets Flutter 3.24

## 1.3.2

* Added `showLoadingIndicatorOnSubmit` parameter to show a loading indicator when the user presses the "Done" button. This is useful if you're doing some heavy processing on the cropped image and want to show the user that something is happening.

## 1.3.1

* Added German localization (thanks @jkoenig134)! 

## 1.3.0

* Updated to `package:web` version `1.0.0`.

## 1.2.1

* Fixed a bug where animated images would trigger a lot of exceptions in `obtainImage`. Now, the cropper will just display a static image if the image is animated.
* Updated localization guide in README.md (thanks @Cellaryllis)

## 1.2.0

* Added Chinese localization (thanks @yohom and @zhushenwudi)
* Added Spanish localization (thanks @Thesergiolg99)
* Added Hebrew localization (thanks @kfiross)
* Fixed a bug where the reset button would ignore any aspect ratio constraints (thanks @talamaska)
* Added WASM support and Flutter 3.22 (thanks @raldhafiri)
* Updated dependencies and added Gradle namespace (thanks @orkun1675)
* Add support for passing custom themes to the croppers instead of the default generated one, and fixed some more reset issues.

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
