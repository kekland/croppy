import 'package:croppy/croppy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

CupertinoThemeData generateCupertinoImageCropperTheme(BuildContext context) {
  final materialTheme = generateMaterialImageCropperTheme(context);
  final primaryColor = materialTheme.colorScheme.primary;

  return MaterialBasedCupertinoThemeData(materialTheme: materialTheme).copyWith(
    scaffoldBackgroundColor: kCupertinoImageCropperBackgroundColor,
    primaryColor: primaryColor,
    primaryContrastingColor: CupertinoColors.white,
    barBackgroundColor: kCupertinoImageCropperBackgroundColor,
    textTheme: CupertinoTextThemeData(
      primaryColor: primaryColor,
      textStyle: const TextStyle(
        color: CupertinoColors.white,
        fontSize: 16.0,
      ),
      actionTextStyle: TextStyle(
        color: primaryColor,
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
      ),
      navTitleTextStyle: const TextStyle(
        color: CupertinoColors.white,
        fontSize: 17.0,
        fontWeight: FontWeight.w600,
      ),
      navActionTextStyle: TextStyle(
        color: primaryColor, // Back button
        fontSize: 17.0,
      ),
      navLargeTitleTextStyle: const TextStyle(
        color: CupertinoColors.white,
        fontSize: 34.0,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
