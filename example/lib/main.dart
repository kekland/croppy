import 'package:croppy/croppy.dart';
import 'package:flutter/material.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Croppy Demo'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            showCupertinoImageCropper(
              context,
              imageProvider: const NetworkImage(
                'https://test-photos-qklwjen.s3.eu-west-3.amazonaws.com/image28.jpg',
              ),
              imageSize: const Size(1620, 1080),
            );
          },
          child: const Text('Crop'),
        ),
      ),
    );
  }
}
