// ignore_for_file: avoid_print

import 'package:code_assets/code_assets.dart';
import 'package:native_toolchain_c/native_toolchain_c.dart';
import 'package:hooks/hooks.dart';

// ignore: unused_import
import 'package:android_libcpp_shared/android_libcpp_shared.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    if (!input.config.buildCodeAssets) return;

    final packageName = input.packageName;
    final cbuilder = CBuilder.library(
      name: packageName,
      assetName: 'croppy_ffi_bindings_generated.dart',
      sources: ['src/croppy.c', 'src/fit_polygon_in_quad.cpp'],
      includes: ['src', 'src/kiwi'],
      language: Language.cpp,
      std: 'c++11',
      flags: [
        '-std=c++11',
        '-O3',
      ],
    );

    await cbuilder.run(input: input, output: output);
  });
}
