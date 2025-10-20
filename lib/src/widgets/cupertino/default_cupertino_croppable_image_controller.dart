import 'package:croppy/src/src.dart';
import 'package:flutter/material.dart';

class DefaultCupertinoCroppableImageController extends StatefulWidget {
  const DefaultCupertinoCroppableImageController({
    super.key,
    required this.builder,
    required this.imageProvider,
    this.initialData,
    this.postProcessFn,
    this.cropShapeFn,
    this.allowedAspectRatios,
    this.enabledTransformations,
    this.showLoadingIndicatorOnSubmit = false,
    this.showGestureHandlesOn = const [CropShapeType.aabb],
    this.overlayColor,
  });

  final ImageProvider imageProvider;
  final CroppableImageData? initialData;
  final CroppableImagePostProcessFn? postProcessFn;
  final CropShapeFn? cropShapeFn;
  final List<CropAspectRatio?>? allowedAspectRatios;
  final List<Transformation>? enabledTransformations;
  final bool showLoadingIndicatorOnSubmit;
  final List<CropShapeType> showGestureHandlesOn;
  final Color? overlayColor;

  final Widget Function(
    BuildContext context,
    CupertinoCroppableImageController controller,
  ) builder;

  @override
  State<DefaultCupertinoCroppableImageController> createState() =>
      _DefaultCupertinoCroppableImageControllerState();
}

class _DefaultCupertinoCroppableImageControllerState
    extends State<DefaultCupertinoCroppableImageController>
    with TickerProviderStateMixin {
  CupertinoCroppableImageController? _controller;

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

    _controller = CupertinoCroppableImageController(
      vsync: this,
      imageProvider: widget.imageProvider,
      data: initialData,
      postProcessFn: widget.postProcessFn,
      cropShapeFn: widget.cropShapeFn ?? aabbCropShapeFn,
      allowedAspectRatios: widget.allowedAspectRatios,
      enabledTransformations:
          widget.enabledTransformations ?? Transformation.values,
    );

    if (mounted) {
      setState(() {});
    }
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
