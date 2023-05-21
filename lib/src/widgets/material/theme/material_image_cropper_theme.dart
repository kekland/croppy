import 'package:flutter/material.dart';

ThemeData generateMaterialImageCropperTheme(BuildContext context) {
  final outerTheme = Theme.of(context);

  return ThemeData.localize(
    ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: outerTheme.primaryColor,
        primary: outerTheme.primaryColor,
        brightness: Brightness.dark,
      ),
      useMaterial3: outerTheme.useMaterial3,
    ),
    outerTheme.textTheme,
  );
}
