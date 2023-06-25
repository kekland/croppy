import 'package:croppy/croppy.dart';
import 'package:flutter/widgets.dart';

mixin TransformationFrictionMixin on CroppableImageControllerWithMixins {
  double _computeAreaMultiple(CroppableImageData data) {
    final quad = data.transformedImageQuad;
    final polygon = data.cropShape.polygon.shift(data.cropRect.topLeft.vector2);

    final unionPolygon = Polygon2([...polygon.vertices, ...quad.vertices]);
    final unionPolygonConvex = unionPolygon.computeConvexHull();

    final unionArea = unionPolygonConvex.computeArea();
    final imageArea = data.imageSize.area;

    return unionArea / imageArea;
  }

  static const _physics =
      BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.normal);

  void _applyFrictionToTransformation({
    required CroppableImageData possibleNewData,
    required void Function(double friction) onFriction,
    required VoidCallback onNoFriction,
  }) {
    final newArea = _computeAreaMultiple(possibleNewData);
    if (newArea <= 1.05) {
      // We aren't really out of bounds, so we don't need to apply friction
      data = possibleNewData;
      onNoFriction();
      return;
    }

    final friction = _physics.frictionFactor(newArea - 1.0);

    onFriction(friction);
  }

  @override
  void onResize({
    required Offset offsetDelta,
    required ResizeDirection direction,
  }) {
    final oldData = data.copyWith();

    super.onResize(
      offsetDelta: offsetDelta,
      direction: direction,
    );

    _applyFrictionToTransformation(
      possibleNewData: data,
      onFriction: (friction) {
        data = oldData;

        super.onResize(
          offsetDelta: offsetDelta * friction,
          direction: direction,
        );
      },
      onNoFriction: () => onTransformation((offsetDelta, direction)),
    );
  }

  @override
  void onPanAndScale({
    required double scaleDelta,
    required Offset offsetDelta,
  }) {
    _applyFrictionToTransformation(
      possibleNewData: onPanAndScaleImpl(
        data: data,
        scaleDelta: scaleDelta,
        offsetDelta: offsetDelta,
      ),
      onFriction: (friction) {
        late final double newScaleDelta;

        if (scaleDelta > 1.0) {
          // We're zooming in, so no need to apply friction
          newScaleDelta = scaleDelta;
        } else {
          // We're zooming out
          newScaleDelta = (scaleDelta - 1.0) * friction + 1.0;
        }

        super.onPanAndScale(
          offsetDelta: offsetDelta * friction,
          scaleDelta: newScaleDelta,
        );
      },
      onNoFriction: () => onTransformation((scaleDelta, offsetDelta)),
    );
  }
}
