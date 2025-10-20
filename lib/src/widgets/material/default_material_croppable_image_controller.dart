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
    this.overlayColor,
  });

  final ImageProvider imageProvider;
  final CroppableImageData? initialData;
  final CroppableImagePostProcessFn? postProcessFn;
  final CropShapeFn? cropShapeFn;
  final List<CropAspectRatio?>? allowedAspectRatios;
  final List<Transformation>? enabledTransformations;
  final Color? overlayColor;

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
  MaterialCroppableImageController? _controller;

  @override
  void initState() {
    super.initState();
    _prepareController();
  }

  Future<void> _prepareController() async {
    late final CroppableImageData initialData;

    if (widget.initialData != null) {
      initialData = CroppableImageData(
        imageSize: widget.initialData!.imageSize,
        cropRect: widget.initialData!.cropRect,
        cropShape: widget.initialData!.cropShape,
        baseTransformations: widget.initialData!.baseTransformations,
        imageTransform: widget.initialData!.imageTransform,
        currentImageTransform: widget.initialData!.currentImageTransform,
        overlayColor: widget.overlayColor,
      );
    } else {
      initialData = await CroppableImageData.fromImageProvider(
        widget.imageProvider,
        cropPathFn: widget.cropShapeFn ?? aabbCropShapeFn,
        overlayColor: widget.overlayColor,
      );
    }

    _controller = MaterialCroppableImageController(
      vsync: this,
      imageProvider: widget.imageProvider,
      data: initialData,
      postProcessFn: widget.postProcessFn,
      cropShapeFn: widget.cropShapeFn ?? aabbCropShapeFn,
      allowedAspectRatios: widget.allowedAspectRatios,
      enabledTransformations:
          widget.enabledTransformations ?? Transformation.values,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const SizedBox.shrink();
    }

    return widget.builder(context, _controller!);
  }
}
