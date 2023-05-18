// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// This is a copy of https://github.com/dnfield/vector_graphics/blob/main/packages/vector_graphics_compiler/lib/src/geometry/vertices.dart,
// with tweaks made to make it work with `dart:ui`.

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:croppy/croppy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

// This is a magic number used by impeller for radius approximation:
// https://github.com/flutter/impeller/blob/a2478aa4939a9a08c6c3810f72e0db42e7383a07/geometry/path_builder.cc#L9
// See https://spencermortensen.com/articles/bezier-circle/ for more information.
const double _kArcApproximationMagic = 0.551915024494;

/// Specifies the winding rule that decies how the interior of a [Path] is
/// calculated.
///
/// This enum is used by the [Path.fillType] property.
///
/// It is compatible with the same enum in `dart:ui`.
enum PathFillType {
  /// The interior is defined by a non-zero sum of signed edge crossings.
  ///
  /// For a given point, the point is considered to be on the inside of the path
  /// if a line drawn from the point to infinity crosses lines going clockwise
  /// around the point a different number of times than it crosses lines going
  /// counter-clockwise around that point.
  nonZero,

  /// The interior is defined by an odd number of edge crossings.
  ///
  /// For a given point, the point is considered to be on the inside of the path
  /// if a line drawn from the point to infinity crosses an odd number of lines.
  evenOdd,
}

/// The available types of path verbs.
///
/// Used by [PathCommand.type].
enum PathCommandType {
  /// A path verb that picks up the pen to move it to another coordinate,
  /// starting a new contour.
  move,

  /// A path verb that draws a line from the current point to a specified
  /// coordinate.
  line,

  /// A path verb that draws a Bezier curve from the current point to a
  /// specified point using two control points.
  cubic,

  /// A path verb that draws a line from the current point to the starting
  /// point of the current contour.
  close,
}

/// An abstract, immutable representation of a path verb and its associated
/// points.
///
/// [Path] objects are collections of [PathCommand]s. To create a path object,
/// use a [PathBuilder]. To create a path object from an SVG path definition,
/// use [parseSvgPathData].
@immutable
abstract class PathCommand {
  const PathCommand._(this.type);

  /// The type of this path command.
  final PathCommandType type;

  /// Returns a new path command transformed by `matrix`.
  PathCommand transformed(Matrix4 matrix);

  /// A representation of this path command for dart:ui.
  void toUiPath(ui.Path path);
}

/// A straight line from the current point to x,y.
class LineToCommand extends PathCommand {
  /// Creates a straight line command from the current point to x,y.
  const LineToCommand(this.x, this.y) : super._(PathCommandType.line);

  /// The absolute offset of the destination point for this path from the x
  /// axis.
  final double x;

  /// The absolute offset of the destination point for this path from the y
  /// axis.
  final double y;

  @override
  LineToCommand transformed(Matrix4 matrix) {
    final Offset xy = MatrixUtils.transformPoint(matrix, Offset(x, y));
    return LineToCommand(xy.dx, xy.dy);
  }

  @override
  int get hashCode => Object.hash(type, x, y);

  @override
  bool operator ==(Object other) {
    return other is LineToCommand && other.x == x && other.y == y;
  }

  @override
  void toUiPath(ui.Path path) {
    path.lineTo(x, y);
  }

  @override
  String toString() => 'LineToCommand($x, $y)';
}

/// Moves the current point to x,y as if picking up the pen.
class MoveToCommand extends PathCommand {
  /// Creates a new command that moves the current point to x,y without drawing.
  const MoveToCommand(this.x, this.y) : super._(PathCommandType.move);

  /// The absolute offset of the destination point for this path from the x
  /// axis.
  final double x;

  /// The absolute offset of the destination point for this path from the y
  /// axis.
  final double y;

  @override
  MoveToCommand transformed(Matrix4 matrix) {
    final Offset xy = MatrixUtils.transformPoint(matrix, Offset(x, y));
    return MoveToCommand(xy.dx, xy.dy);
  }

  @override
  int get hashCode => Object.hash(type, x, y);

  @override
  bool operator ==(Object other) {
    return other is MoveToCommand && other.x == x && other.y == y;
  }

  @override
  void toUiPath(ui.Path path) {
    path.moveTo(x, y);
  }

  @override
  String toString() => 'MoveToCommand($x, $y)';
}

/// A command describing a cubic Bezier command from the current point to
/// x3,y3 using control points x1,y1 and x2,y2.
class CubicToCommand extends PathCommand {
  /// Creates a new cubic Bezier command from the current point to x3,y3 using
  /// control points x1,y1 and x2,y2.
  const CubicToCommand(this.x1, this.y1, this.x2, this.y2, this.x3, this.y3)
      : super._(PathCommandType.cubic);

  /// Creates a cubic command from the current point to [end] using [control1]
  /// and [control2] as control points.
  CubicToCommand.fromOffsets(Offset control1, Offset control2, Offset end)
      : this(
            control1.dx, control1.dy, control2.dx, control2.dy, end.dx, end.dy);

  factory CubicToCommand._fromIterableOffsets(Iterable<Offset> points) {
    final List<Offset> list = points.toList();
    assert(list.length == 3);
    return CubicToCommand.fromOffsets(list[0], list[1], list[2]);
  }

  /// The absolute offset of the first control point for this path from the x
  /// axis.
  final double x1;

  /// The absolute offset of the first control point for this path from the y
  /// axis.
  final double y1;

  /// A [Offset] representation of [x1],[y1], the first control point.
  Offset get controlOffset1 => Offset(x1, y1);

  /// The absolute offset of the second control point for this path from the x
  /// axis.
  final double x2;

  /// The absolute offset of the second control point for this path from the x
  /// axis.
  final double y2;

  /// A [Offset] representation of [x2],[y2], the second control point.
  Offset get controlOffset2 => Offset(x2, y2);

  /// The absolute offset of the destination point for this path from the x
  /// axis.
  final double x3;

  /// The absolute offset of the destination point for this path from the y
  /// axis.
  final double y3;

  /// A [Offset] representation of [x3],[y3], the end point of the curve.
  Offset get endOffset => Offset(x3, y3);

  /// Subdivides the cubic curve described by [start], [control1], [control2],
  /// [end].
  ///
  /// The returned list describes two cubics, where elements `0, 1, 2, 3` are
  /// the start, cp1, cp2, and end points of the first cubic and `3, 4, 5, 6`
  /// are the start, cp1, cp2, and end points of the second cubic.
  static List<Offset> subdivide(
    Offset start,
    Offset control1,
    Offset control2,
    Offset end,
    double t,
  ) {
    final Offset ab = Offset.lerp(start, control1, t)!;
    final Offset bc = Offset.lerp(control1, control2, t)!;
    final Offset cd = Offset.lerp(control2, end, t)!;
    final Offset abc = Offset.lerp(ab, bc, t)!;
    final Offset bcd = Offset.lerp(bc, cd, t)!;
    final Offset abcd = Offset.lerp(abc, bcd, t)!;
    return <Offset>[
      start,
      ab,
      abc,
      abcd,
      bcd,
      cd,
      end,
    ];
  }

  /// Computes an approximation of the arc length of this cubic starting
  /// from [start].
  double computeLength(Offset start) {
    // Mike Reed just made this up! The nerve of him.
    // One difference from Skia is just setting a default tolerance of 3. This
    // is good enough for a particular test SVG that has this curve:
    // M65 33c0 17.673-14.326 32-32 32S1 50.673 1 33C1 15.327 15.326 1 33 1s32 14.327 32 32z
    // Lower values end up getting the end points wrong when dashing a path.
    const double tolerance = 1 / 2 * 3;

    double _compute(
      Offset p1,
      Offset cp1,
      Offset cp2,
      Offset p2,
      double distance,
    ) {
      // If it's "too curvy," cut it in half
      if (_offsetDistance(cp1, Offset.lerp(p1, p2, 1 / 3)!) > tolerance ||
          _offsetDistance(cp2, Offset.lerp(p1, p2, 2 / 3)!) > tolerance) {
        final List<Offset> points = subdivide(p1, cp1, cp2, p2, .5);
        distance = _compute(
          points[0],
          points[1],
          points[2],
          points[3],
          distance,
        );
        distance = _compute(
          points[3],
          points[4],
          points[5],
          points[6],
          distance,
        );
      } else {
        // It's collinear enough to just treat as a line.
        distance += _offsetDistance(p1, p2);
      }
      return distance;
    }

    return _compute(start, Offset(x1, y1), Offset(x2, y2), Offset(x3, y3), 0);
  }

  @override
  CubicToCommand transformed(Matrix4 matrix) {
    final Offset xy1 = MatrixUtils.transformPoint(matrix, Offset(x1, y1));
    final Offset xy2 = MatrixUtils.transformPoint(matrix, Offset(x2, y2));
    final Offset xy3 = MatrixUtils.transformPoint(matrix, Offset(x3, y3));
    return CubicToCommand(xy1.dx, xy1.dy, xy2.dx, xy2.dy, xy3.dx, xy3.dy);
  }

  @override
  int get hashCode => Object.hash(type, x1, y1, x2, y2, x3, y3);

  @override
  bool operator ==(Object other) {
    return other is CubicToCommand &&
        other.x1 == x1 &&
        other.y1 == y1 &&
        other.x2 == x2 &&
        other.y2 == y2 &&
        other.x3 == x3 &&
        other.y3 == y3;
  }

  @override
  void toUiPath(ui.Path path) {
    path.cubicTo(x1, y1, x2, y2, x3, y3);
  }

  @override
  String toString() => 'CubicToCommand($x1, $y1, $x2, $y2, $x3, $y3)';
}

/// A straight line from the current point to the current contour start point.
class CloseCommand extends PathCommand {
  /// Creates a new straight line from the current point to the current contour
  /// start point.
  const CloseCommand() : super._(PathCommandType.close);

  @override
  CloseCommand transformed(Matrix4 matrix) {
    return this;
  }

  @override
  int get hashCode => type.hashCode;

  @override
  bool operator ==(Object other) {
    return other is CloseCommand;
  }

  @override
  void toUiPath(ui.Path path) {
    path.close();
  }

  @override
  String toString() => 'CloseCommand()';
}

final globalPathBuilder = PathBuilder();

/// Creates a new builder of [Path] objects.
class PathBuilder {
  /// Creates a new path builder for paths of the specified fill type.
  ///
  /// By default, will create non-zero filled paths.
  PathBuilder([PathFillType? fillType])
      : fillType = fillType ?? PathFillType.nonZero;

  /// Creates a new mutable path builder object from an existing [Path].
  PathBuilder.fromPath(Path path) {
    addPath(path);
    fillType = path.fillType;
  }

  final List<PathCommand> _commands = <PathCommand>[];

  PathBuilder close() {
    _commands.add(const CloseCommand());
    return this;
  }

  PathBuilder cubicTo(
    double x1,
    double y1,
    double x2,
    double y2,
    double x3,
    double y3,
  ) {
    _commands.add(CubicToCommand(x1, y1, x2, y2, x3, y3));
    return this;
  }

  PathBuilder lineTo(double x, double y) {
    _commands.add(LineToCommand(x, y));
    return this;
  }

  PathBuilder moveTo(double x, double y) {
    _commands.add(MoveToCommand(x, y));
    return this;
  }

  /// Adds the commands of an existing path to the new path being created.
  PathBuilder addPath(Path other) {
    _commands.addAll(other._commands);
    return this;
  }

  /// Adds an oval command to new path.
  PathBuilder addOval(Rect oval) {
    final Offset r = Offset(oval.width * 0.5, oval.height * 0.5);
    final Offset c = Offset(
      oval.left + (oval.width * 0.5),
      oval.top + (oval.height * 0.5),
    );
    final Offset m = Offset(
      _kArcApproximationMagic * r.dx,
      _kArcApproximationMagic * r.dy,
    );

    moveTo(c.dx, c.dy - r.dy);

    // Top right arc.
    cubicTo(
        c.dx + m.dx, c.dy - r.dy, c.dx + r.dx, c.dy - m.dy, c.dx + r.dx, c.dy);

    // Bottom right arc.
    cubicTo(
        c.dx + r.dx, c.dy + m.dy, c.dx + m.dx, c.dy + r.dy, c.dx, c.dy + r.dy);

    // Bottom left arc.
    cubicTo(
        c.dx - m.dx, c.dy + r.dy, c.dx - r.dx, c.dy + m.dy, c.dx - r.dx, c.dy);

    // Top left arc.
    cubicTo(
        c.dx - r.dx, c.dy - m.dy, c.dx - m.dx, c.dy - r.dy, c.dx, c.dy - r.dy);

    close();
    return this;
  }

  /// Adds a rectangle to the new path.
  PathBuilder addRect(Rect rect) {
    moveTo(rect.left, rect.top);
    lineTo(rect.right, rect.top);
    lineTo(rect.right, rect.bottom);
    lineTo(rect.left, rect.bottom);
    close();
    return this;
  }

  /// Adds a rounded rectangle to the new path.
  PathBuilder addRRect(Rect rect, double rx, double ry) {
    if (rx == 0 && ry == 0) {
      return addRect(rect);
    }

    final Offset magicRadius = Offset(rx, ry) * _kArcApproximationMagic;

    moveTo(rect.left + rx, rect.top);

    // Top line.
    lineTo(rect.left + rect.width - rx, rect.top);

    // Top right arc.
    //
    cubicTo(
      rect.left + rect.width - rx + magicRadius.dx,
      rect.top,
      rect.left + rect.width,
      rect.top + ry - magicRadius.dy,
      rect.left + rect.width,
      rect.top + ry,
    );

    // Right line.
    lineTo(rect.left + rect.width, rect.top + rect.height - ry);

    // Bottom right arc.
    cubicTo(
      rect.left + rect.width,
      rect.top + rect.height - ry + magicRadius.dy,
      rect.left + rect.width - rx + magicRadius.dx,
      rect.top + rect.height,
      rect.left + rect.width - rx,
      rect.top + rect.height,
    );

    // Bottom line.
    lineTo(rect.left + rx, rect.top + rect.height);

    // Bottom left arc.
    cubicTo(
        rect.left + rx - magicRadius.dx,
        rect.top + rect.height,
        rect.left,
        rect.top + rect.height - ry + magicRadius.dy,
        rect.left,
        rect.top + rect.height - ry);

    // Left line.
    lineTo(rect.left, rect.top + ry);

    // Top left arc.
    cubicTo(
      rect.left,
      rect.top + ry - magicRadius.dy,
      rect.left + rx - magicRadius.dx,
      rect.top,
      rect.left + rx,
      rect.top,
    );

    close();
    return this;
  }

  /// The fill type to use for the new path.
  late PathFillType fillType;

  /// Creates a new [Path] object from the commands in this path.
  ///
  /// If `reset` is set to false, this builder can be used to create multiple
  /// path objects with the same commands. By default, the builder will reset
  /// to an initial state.
  Path toPath({bool reset = true}) {
    final Path path = Path(
      commands: _commands,
      fillType: fillType,
    );

    if (reset) {
      _commands.clear();
    }
    return path;
  }
}

/// An immutable collection of [PathCommand]s.
class Path {
  /// Creates a new immutable collection of [PathCommand]s.
  Path({
    List<PathCommand> commands = const <PathCommand>[],
    this.fillType = PathFillType.nonZero,
  }) {
    _commands.addAll(commands);
  }

  /// Creates a copy of this path, replacing the current [fillType] with [type].
  Path withFillType(PathFillType type) {
    if (type == fillType) {
      return this;
    }
    return Path(fillType: type, commands: _commands);
  }

  /// Whether this path has any commands.
  bool get isEmpty => _commands.isEmpty;

  /// The commands this path contains.
  Iterable<PathCommand> get commands => _commands;

  final List<PathCommand> _commands = <PathCommand>[];

  /// The fill type of this path, defaulting to [PathFillType.nonZero].
  final PathFillType fillType;

  /// Creates a new path whose commands and points are transformed by `matrix`.
  Path transformed(Matrix4 matrix) {
    final List<PathCommand> commands = <PathCommand>[];
    for (final PathCommand command in _commands) {
      commands.add(command.transformed(matrix));
    }
    return Path(
      commands: commands,
      fillType: fillType,
    );
  }

  @override
  int get hashCode => Object.hash(Object.hashAll(_commands), fillType);

  @override
  bool operator ==(Object other) {
    return other is Path &&
        listEquals(_commands, other._commands) &&
        other.fillType == fillType;
  }

  /// Creates a dashed version of this path.
  ///
  /// The interval list is read in a circular fashion, such that the first
  /// interval is used to dash and the second to move. If the list is an odd
  /// number of elements, it is effectively the same as if it were repeated
  /// twice.
  ///
  /// Callers are responsible for not passing interval lists consisting entirely
  /// of `0`.
  Path dashed(List<double> intervals) {
    if (intervals.isEmpty) {
      return this;
    }
    final _PathDasher dasher = _PathDasher(intervals);
    return dasher.dash(this);
  }

  /// Compute the bounding box for the given path segment.
  Rect bounds() {
    if (_commands.isEmpty) {
      return Rect.zero;
    }
    double smallestX = double.maxFinite;
    double smallestY = double.maxFinite;
    double largestX = -double.maxFinite;
    double largestY = -double.maxFinite;
    for (final PathCommand command in _commands) {
      switch (command.type) {
        case PathCommandType.move:
          final MoveToCommand move = command as MoveToCommand;
          smallestX = math.min(move.x, smallestX);
          smallestY = math.min(move.y, smallestY);
          largestX = math.max(move.x, largestX);
          largestY = math.max(move.y, largestY);
          break;
        case PathCommandType.line:
          final LineToCommand move = command as LineToCommand;
          smallestX = math.min(move.x, smallestX);
          smallestY = math.min(move.y, smallestY);
          largestX = math.max(move.x, largestX);
          largestY = math.max(move.y, largestY);
          break;
        case PathCommandType.cubic:
          final CubicToCommand cubic = command as CubicToCommand;
          for (List<double> pair in <List<double>>[
            <double>[cubic.x1, cubic.y1],
            <double>[cubic.x2, cubic.y2],
            <double>[cubic.x3, cubic.y3],
          ]) {
            smallestX = math.min(pair[0], smallestX);
            smallestY = math.min(pair[1], smallestY);
            largestX = math.max(pair[0], largestX);
            largestY = math.max(pair[1], largestY);
          }
          break;
        case PathCommandType.close:
          break;
      }
    }
    return Rect.fromLTRB(smallestX, smallestY, largestX, largestY);
  }

  ui.Path? _cachedUiPath;
  ui.Path toUiPath() {
    if (_cachedUiPath != null) {
      return _cachedUiPath!;
    }

    final path = ui.Path();

    for (final PathCommand command in commands) {
      command.toUiPath(path);
    }

    return _cachedUiPath = path;
  }

  Polygon2? _cachedPolygon;
  Polygon2 toApproximatePolygon() {
    if (_cachedPolygon != null) {
      return _cachedPolygon!;
    }

    return _cachedPolygon = polygonFromPath(this);
  }

  @override
  String toString() {
    final StringBuffer buffer = StringBuffer('Path(');
    if (commands.isNotEmpty) {
      buffer.write('\n  commands: <PathCommand>$commands,');
    }
    if (fillType != PathFillType.nonZero) {
      buffer.write('\n  fillType: $fillType,');
    }
    buffer.write('\n)');
    return buffer.toString();
  }
}

class _CircularIntervalList {
  _CircularIntervalList(this._vals)
      : assert(_vals.isNotEmpty),
        assert(!_vals.every((double val) => val == 0));

  final List<double> _vals;
  int _idx = 0;

  double get next {
    if (_idx >= _vals.length) {
      _idx = 0;
    }
    return _vals[_idx++];
  }
}

class _PathDasher {
  _PathDasher(List<double> intervals)
      : assert(!intervals.every((double interval) => interval == 0)),
        _intervals = _CircularIntervalList(intervals);

  final _CircularIntervalList _intervals;

  late double length;
  Offset currentOffset = Offset.zero;
  Offset currentSubpathOffset = Offset.zero;
  late bool draw;

  final List<PathCommand> _dashedCommands = <PathCommand>[];

  void _dashLineTo(Offset target) {
    double distance = _offsetDistance(currentOffset, target);

    if (distance <= 0 || length <= 0) {
      return;
    }

    while (distance >= length) {
      final double t = length / distance;
      currentOffset = Offset.lerp(currentOffset, target, t)!;
      length = _intervals.next;

      if (draw) {
        _dashedCommands.add(LineToCommand(currentOffset.dx, currentOffset.dy));
      } else {
        _dashedCommands.add(MoveToCommand(currentOffset.dx, currentOffset.dy));
      }

      distance = _offsetDistance(currentOffset, target);
      draw = !draw;
    }
    if (distance > 0) {
      length -= distance;
      if (draw) {
        _dashedCommands.add(LineToCommand(target.dx, target.dy));
      }
    }
    currentOffset = target;
  }

  void _dashCubicTo(CubicToCommand cubic) {
    double distance = cubic.computeLength(currentOffset);
    while (distance >= length) {
      final double t = length / distance;
      final List<Offset> dividedOffsets = CubicToCommand.subdivide(
        currentOffset,
        cubic.controlOffset1,
        cubic.controlOffset2,
        cubic.endOffset,
        t,
      );
      currentOffset = dividedOffsets[3];
      if (draw) {
        _dashedCommands.add(CubicToCommand._fromIterableOffsets(
          dividedOffsets.skip(1).take(3),
        ));
      } else {
        _dashedCommands.add(MoveToCommand(
          currentOffset.dx,
          currentOffset.dy,
        ));
      }
      cubic = CubicToCommand._fromIterableOffsets(
        dividedOffsets.skip(4).take(3),
      );
      length = _intervals.next;
      distance = cubic.computeLength(currentOffset);
      draw = !draw;
    }
    length -= distance;
    currentOffset = cubic.endOffset;
    if (draw) {
      _dashedCommands.add(cubic);
    }
  }

  Path dash(Path path) {
    length = _intervals.next;
    draw = true;
    for (final PathCommand command in path._commands) {
      switch (command.type) {
        case PathCommandType.move:
          final MoveToCommand move = command as MoveToCommand;
          currentOffset = Offset(move.x, move.y);
          currentSubpathOffset = currentOffset;
          _dashedCommands.add(command);
          break;
        case PathCommandType.line:
          final LineToCommand line = command as LineToCommand;
          _dashLineTo(Offset(line.x, line.y));
          break;
        case PathCommandType.cubic:
          _dashCubicTo(command as CubicToCommand);
          break;
        case PathCommandType.close:
          _dashLineTo(currentSubpathOffset);
          currentOffset = currentSubpathOffset;
          break;
      }
    }
    return Path(commands: _dashedCommands, fillType: path.fillType);
  }
}

double _offsetDistance(Offset p1, Offset p2) {
  final double dx = p1.dx - p2.dx;
  final double dy = p1.dy - p2.dy;
  return math.sqrt(dx * dx + dy * dy);
}
