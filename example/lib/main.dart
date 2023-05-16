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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
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
  CroppableImageData? _data;
  ui.Image? _croppedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Croppy Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_croppedImage != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: RawImage(image: _croppedImage),
              )
            else
              const SizedBox(
                height: 200,
                child: Center(
                  child: Text('No image'),
                ),
              ),
            TextButton(
              onPressed: () async {
                final result = await showCupertinoImageCropper(
                  context,
                  imageProvider: const NetworkImage(
                    'https://test-photos-qklwjen.s3.eu-west-3.amazonaws.com/image11.jpg',
                  ),
                  initialData: _data ??
                      CroppableImageData.initial(
                        imageSize: const Size(1080, 1080),
                      ),
                );

                if (result != null) {
                  final uiImage = await result.asUiImage;

                  setState(() {
                    _croppedImage = uiImage;
                    _data = result.transformationsData;
                  });
                }
              },
              child: const Text('Crop'),
            ),
          ],
        ),
      ),
    );
  }
}
