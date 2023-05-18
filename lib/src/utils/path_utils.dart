import 'package:croppy/src/src.dart';
import 'package:flutter/widgets.dart';
import 'package:croppy/src/utils/path.dart' as vg;

List<Offset> _sampleCubic(
  Offset start,
  vg.CubicToCommand command,
  int numSamples,
) {
  final points = <Offset>[];

  for (var i = 0; i < numSamples; i++) {
    final cubicPoints = vg.CubicToCommand.subdivide(
      start,
      command.controlOffset1,
      command.controlOffset2,
      command.endOffset,
      i / numSamples,
    );

    points.add(cubicPoints[3]);
  }

  return points;
}

Polygon2 polygonFromPath(vg.Path path) {
  final points = <Vector2>[];

  Offset lastPoint = Offset.zero;
  for (final command in path.commands) {
    if (command is vg.MoveToCommand) {
      lastPoint = Offset(command.x, command.y);
    } else if (command is vg.LineToCommand) {
      final point = Vector2(command.x, command.y);

      points.add(lastPoint.vector2);
      points.add(point);

      lastPoint = point.offset;
    } else if (command is vg.CubicToCommand) {
      final sampledPoints = _sampleCubic(
        lastPoint,
        command,
        6,
      );

      points.addAll(sampledPoints.map((v) => v.vector2));
      lastPoint = command.endOffset;
    }
  }

  return Polygon2(points);
}
