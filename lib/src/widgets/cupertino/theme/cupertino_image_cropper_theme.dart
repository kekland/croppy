import 'package:croppy/croppy.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

CupertinoThemeData generateCupertinoImageCropperTheme(BuildContext context) {
  final materialTheme = generateMaterialImageCropperTheme(context);

  return MaterialBasedCupertinoThemeData(materialTheme: materialTheme).copyWith(
    scaffoldBackgroundColor: kCupertinoImageCropperBackgroundColor,
  );
}
