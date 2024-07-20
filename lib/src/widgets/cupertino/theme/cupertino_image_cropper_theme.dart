import 'package:croppy/croppy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

CupertinoThemeData generateCupertinoImageCropperTheme(BuildContext context) {
  final materialTheme = generateMaterialImageCropperTheme(context);

  return MaterialBasedCupertinoThemeData(materialTheme: materialTheme).copyWith(
    scaffoldBackgroundColor: kCupertinoImageCropperBackgroundColor,
  );
}
