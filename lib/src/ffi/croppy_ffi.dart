import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:ffi/ffi.dart';

import 'croppy_ffi_bindings_generated.dart';

Aabb2 fitPolygonInQuad(List<double> points) {
  final pointer = doubleListToArray(points);
  final result = _bindings.fit_polygon_in_quad(pointer, points.length);

  malloc.free(pointer);
  return result;
}

Future<Aabb2> fitPolygonInQuadAsync(List<double> points) async {
  final SendPort helperIsolateSendPort = await _helperIsolateSendPort;
  final int requestId = _nextSumRequestId++;
  final _FitPolygonInQuadRequest request = _FitPolygonInQuadRequest(
    requestId,
    points,
  );

  final Completer<Aabb2> completer = Completer<Aabb2>();
  _sumRequests[requestId] = completer;
  helperIsolateSendPort.send(request);

  return completer.future;
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

Pointer<Double> doubleListToArray(List<double> list) {
  final ptr = malloc.allocate<Double>(sizeOf<Double>() * list.length);

  for (var i = 0; i < list.length; i++) {
    ptr.elementAt(i).value = list[i];
  }

  return ptr;
}

/// A request to compute `fitPolygonInQuad`.
///
/// Typically sent from one isolate to another.
class _FitPolygonInQuadRequest {
  final int id;
  final List<double> points;

  const _FitPolygonInQuadRequest(this.id, this.points);
}

/// A response with the result of `sum`.
///
/// Typically sent from one isolate to another.
class _FitPolygonInQuadResponse {
  final int id;
  final Aabb2 result;

  const _FitPolygonInQuadResponse(this.id, this.result);
}

/// Counter to identify [_FitPolygonInQuadRequest]s and
/// [_FitPolygonInQuadResponse]s.
int _nextSumRequestId = 0;

/// Mapping from [_SumRequest] `id`s to the completers corresponding to the correct future of the pending request.
final Map<int, Completer<Aabb2>> _sumRequests = <int, Completer<Aabb2>>{};

/// The SendPort belonging to the helper isolate.
Future<SendPort> _helperIsolateSendPort = () async {
  // The helper isolate is going to send us back a SendPort, which we want to
  // wait for.
  final Completer<SendPort> completer = Completer<SendPort>();

  // Receive port on the main isolate to receive messages from the helper.
  // We receive two types of messages:
  // 1. A port to send messages on.
  // 2. Responses to requests we sent.
  final ReceivePort receivePort = ReceivePort()
    ..listen((dynamic data) {
      if (data is SendPort) {
        // The helper isolate sent us the port on which we can sent it requests.
        completer.complete(data);
        return;
      }
      if (data is _FitPolygonInQuadResponse) {
        // The helper isolate sent us a response to a request we sent.
        final Completer<Aabb2> completer = _sumRequests[data.id]!;
        _sumRequests.remove(data.id);
        completer.complete(data.result);
        return;
      }
      throw UnsupportedError('Unsupported message type: ${data.runtimeType}');
    });

  // Start the helper isolate.
  await Isolate.spawn((SendPort sendPort) async {
    final ReceivePort helperReceivePort = ReceivePort()
      ..listen((dynamic data) {
        // On the helper isolate listen to requests and respond to them.
        if (data is _FitPolygonInQuadRequest) {
          final listPointer = doubleListToArray(data.points);

          final Aabb2 result = _bindings.fit_polygon_in_quad(
            listPointer,
            data.points.length,
          );

          malloc.free(listPointer);

          final response = _FitPolygonInQuadResponse(data.id, result);
          sendPort.send(response);
          return;
        }
        throw UnsupportedError('Unsupported message type: ${data.runtimeType}');
      });

    // Send the port to the main isolate on which we can receive requests.
    sendPort.send(helperReceivePort.sendPort);
  }, receivePort.sendPort);

  // Wait until the helper isolate has sent us back the SendPort on which we
  // can start sending requests.
  return completer.future;
}();
