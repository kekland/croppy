import 'dart:io';
import 'dart:math';

import 'package:croppy/croppy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

void main() {
  if (!kIsWeb) {
    // For some reason, the FFI implementation of the Cassowary solver is super
    // slow in debug mode. So we force the Dart implementation to be used in debug
    // mode. This only applies to Windows.
    croppyForceUseCassowaryDartImpl = kDebugMode && Platform.isWindows;
  }

  runApp(const MyApp());
}

class ExampleScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Croppy Demo',
      scrollBehavior: ExampleScrollBehavior(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          primary: Colors.blueAccent,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.9,
    );

    final random = Random();
    for (var i = 0; i < 80; i++) {
      final image = NetworkImage(
        'https://test-photos-qklwjen.s3.eu-west-3.amazonaws.com/image${random.nextInt(80) + 1}.jpg',
        headers: const {'accept': '*/*'},
      );

      _imageProviders.add(image);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final _imageProviders = <ImageProvider>[];
  final _data = <int, CroppableImageData>{};
  final _croppedImage = <int, ui.Image>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              final page = _pageController.page?.round() ?? 0;

              showCupertinoImageCropper(
                context,
                imageProvider: _imageProviders[page],
                heroTag: 'image-$page',
                initialData: _data[page],
                cropPathFn: aabbCropShapeFn,
                postProcessFn: (result) async {
                  _croppedImage[page]?.dispose();

                  setState(() {
                    _croppedImage[page] = result.uiImage;
                    _data[page] = result.transformationsData;
                  });

                  return result;
                },
              );
            },
            heroTag: 'fab-cupertino',
            child: const Icon(Icons.apple_rounded),
          ),
          const SizedBox(width: 16.0),
          FloatingActionButton(
            onPressed: () {
              final page = _pageController.page?.round() ?? 0;

              showMaterialImageCropper(
                context,
                imageProvider: _imageProviders[page],
                heroTag: 'image-$page',
                initialData: _data[page],
                cropPathFn: starCropShapeFn,
                postProcessFn: (result) async {
                  _croppedImage[page]?.dispose();

                  setState(() {
                    _croppedImage[page] = result.uiImage;
                    _data[page] = result.transformationsData;
                  });

                  return result;
                },
              );
            },
            heroTag: 'fab-material',
            child: const Icon(Icons.android_rounded),
          ),
        ],
      ),
      body: Stack(
        children: [
          const Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Croppy Demo'),
            ),
          ),
          Center(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _imageProviders.length,
              scrollDirection: Axis.horizontal,
              padEnds: true,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Center(
                    child: Hero(
                      tag: 'image-$i',
                      placeholderBuilder: (context, size, child) =>
                          Visibility.maintain(
                        visible: false,
                        child: child,
                      ),
                      child: _croppedImage[i] != null
                          ? RawImage(image: _croppedImage[i])
                          : Image(image: _imageProviders[i]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
