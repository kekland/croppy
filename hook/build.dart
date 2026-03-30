// ignore_for_file: avoid_print

import 'package:native_toolchain_c/native_toolchain_c.dart';
import 'package:logging/logging.dart';
import 'package:hooks/hooks.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    final packageName = input.packageName;
    final cbuilder = CBuilder.library(
      name: packageName,
      assetName: 'croppy_ffi_bindings_generated.dart',
      sources: ['src/croppy.c', 'src/fit_polygon_in_quad.cpp'],
      includes: ['src', 'src/kiwi'],
      language: Language.cpp,
      flags: [
        '-std=c++11',
        '-O3',
      ],
    );

    await cbuilder.run(
      input: input,
      output: output,
      logger: Logger('')
        ..level = Level.ALL
        ..onRecord.listen((record) => print(record.message)),
    );
  });
}
