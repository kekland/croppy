import 'package:flutter/material.dart';

ThemeData generateMaterialImageCropperTheme(BuildContext context) {
  final outerTheme = Theme.of(context);

  return ThemeData.localize(
    ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: outerTheme.colorScheme.primary,
        primary: outerTheme.colorScheme.primary,
        brightness: Brightness.dark,
      ),
      useMaterial3: outerTheme.useMaterial3,
    ),
    outerTheme.textTheme,
  );
}
