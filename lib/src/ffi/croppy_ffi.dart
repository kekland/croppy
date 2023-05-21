import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

import 'croppy_ffi_bindings_generated.dart';
export 'croppy_ffi_bindings_generated.dart';

Aabb2 fitPolygonInQuad(List<double> points) {
  final pointer = doubleListToPointer(points);
  final result = _bindings.fit_polygon_in_quad(pointer, points.length);

  malloc.free(pointer);
  return result;
}

Aabb2 fitPolygonInQuadOnResize(
  List<double> points, {
  required double aspectRatio,
  required bool isTopLeftStatic,
  required bool isTopRightStatic,
  required bool isBottomLeftStatic,
  required bool isBottomRightStatic,
}) {
  final pointer = doubleListToPointer(points);
  final result = _bindings.fit_polygon_in_quad_on_resize(
    pointer,
    points.length,
    aspectRatio,
    isTopLeftStatic,
    isTopRightStatic,
    isBottomLeftStatic,
    isBottomRightStatic,
  );

  malloc.free(pointer);
  return result;
}

const String _libName = 'croppy';

/// The dynamic library in which the symbols for [CroppyFfiBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final CroppyFfiBindings _bindings = CroppyFfiBindings(_dylib);

/// Allocates a pointer for a list of doubles and copies the values from [list]
/// into it.
Pointer<Double> doubleListToPointer(List<double> list) {
  final ptr = malloc.allocate<Double>(sizeOf<Double>() * list.length);

  for (var i = 0; i < list.length; i++) {
    ptr.elementAt(i).value = list[i];
  }

  return ptr;
}
