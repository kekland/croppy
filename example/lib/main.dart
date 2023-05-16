import 'package:croppy/croppy.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Croppy Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.dark,
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
  final _imageProvider = const NetworkImage(
    'https://test-photos-qklwjen.s3.eu-west-3.amazonaws.com/image11.jpg',
  );

  CroppableImageData? _data;
  ui.Image? _croppedImage;

  final _heroTag = 'hello';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: _heroTag,
              placeholderBuilder: (context, size, child) => Visibility.maintain(
                visible: false,
                child: child,
              ),
              child: _croppedImage != null
                  ? RawImage(image: _croppedImage)
                  : Image(image: _imageProvider),
            ),
            TextButton(
              onPressed: () async {
                await showCupertinoImageCropper(
                  context,
                  heroTag: _heroTag,
                  imageProvider: _imageProvider,
                  postProcessFn: (result) async {
                    final uiImage = await result.asUiImage;

                    setState(() {
                      _croppedImage = uiImage;
                      _data = result.transformationsData;
                    });

                    return result;
                  },
                  initialData: _data ??
                      CroppableImageData.initial(
                        imageSize: const Size(1080, 1080),
                      ),
                );
              },
              child: const Text('Crop (Hero)'),
            ),
            TextButton(
              onPressed: () async {
                await showCupertinoImageCropper(
                  context,
                  imageProvider: _imageProvider,
                  postProcessFn: (result) async {
                    final uiImage = await result.asUiImage;

                    setState(() {
                      _croppedImage = uiImage;
                      _data = result.transformationsData;
                    });

                    return result;
                  },
                  initialData: _data ??
                      CroppableImageData.initial(
                        imageSize: const Size(1080, 1080),
                      ),
                );
              },
              child: const Text('Crop (Without Hero)'),
            ),
          ],
        ),
      ),
    );
  }
}
