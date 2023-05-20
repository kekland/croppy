import 'package:croppy/src/src.dart';
import 'package:flutter/material.dart';

class DefaultMaterialCroppableImageController extends StatefulWidget {
  const DefaultMaterialCroppableImageController({
    super.key,
    required this.builder,
    required this.imageProvider,
    required this.initialData,
    this.allowedAspectRatios,
    this.postProcessFn,
    this.cropShapeFn,
    this.enabledTransformations,
  });

  final ImageProvider imageProvider;
  final CroppableImageData initialData;
  final CroppableImagePostProcessFn? postProcessFn;
  final CropShapeFn? cropShapeFn;
  final List<CropAspectRatio?>? allowedAspectRatios;
  final List<Transformation>? enabledTransformations;

  final Widget Function(
    BuildContext context,
    MaterialCroppableImageController controller,
  ) builder;

  @override
  State<DefaultMaterialCroppableImageController> createState() =>
      _DefaultMaterialCroppableImageControllerState();
}

class _DefaultMaterialCroppableImageControllerState
    extends State<DefaultMaterialCroppableImageController>
    with TickerProviderStateMixin {
  late final MaterialCroppableImageController _controller;

  @override
  void initState() {
    super.initState();

    _controller = MaterialCroppableImageController(
      vsync: this,
      imageProvider: widget.imageProvider,
      data: widget.initialData,
      postProcessFn: widget.postProcessFn,
      cropShapeFn: widget.cropShapeFn ?? aabbCropShapeFn,
      allowedAspectRatios: widget.allowedAspectRatios,
      enabledTransformations:
          widget.enabledTransformations ?? Transformation.values,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _controller);
  }
}
