import 'package:croppy/src/src.dart';
import 'package:cassowary/cassowary.dart';

class FitPolygonInQuadSolver {
  // TODO (Erzhan): This currently takes quite a long time to solve. Maybe we
  // should try to find a faster way to solve this.

  // FitPolygonInQuadSolver() : _solver = Solver();

  // final xNew = Param();
  // final yNew = Param();
  // final alpha = Param();
  // final yDist = Param();
  // final xDist = Param();

  // final Solver _solver;

  // void init() {
  //   _solver.addConstraint(xNew <= )
  // }

  /// Solves the problem of fitting an [Polygon2] into a [Quad2].
  static Aabb2 solve(Polygon2 polygon, Quad2 quad) {
    // Check if we even need to solve anything first.
    final verticesNotInQuad = <Vector2>[];

    for (final v in polygon.vertices) {
      if (!quad.containsPoint(v)) {
        verticesNotInQuad.add(v);
      }
    }

    // If all vertices are in the quad, we don't need to do anything.
    if (verticesNotInQuad.isEmpty) {
      return polygon.boundingBox;
    }

    late final Quad2 normalizedQuad;

    // Check if the quad is clockwise or counter-clockwise, and force it to be
    // clockwise.
    if (quad.area > 0.0) {
      normalizedQuad = Quad2(
        quad.point0,
        quad.point3,
        quad.point2,
        quad.point1,
      );
    } else {
      normalizedQuad = quad;
    }

    final aabb = polygon.boundingBox;
    final aabbSize = aabb.max - aabb.min;

    final solver = Solver();

    final quadMin = normalizedQuad.boundingBox.min;
    final quadMax = normalizedQuad.boundingBox.max;

    final xMin = quadMin.x;
    final xMax = quadMax.x;
    final yMin = quadMin.y;
    final yMax = quadMax.y;

    // The parameters we want to solve for.
    final xNew = Param(aabb.min.x);
    final yNew = Param(aabb.min.y);
    final alpha = Param(1.0);

    final xLowerConstraint = xNew >= cm(xMin);
    final xUpperConstraint = xNew <= cm(xMax);
    final yLowerConstraint = yNew >= cm(yMin);
    final yUpperConstraint = yNew <= cm(yMax);

    final alphaLowerConstraint = alpha >= cm(0.0);
    final alphaUpperConstraint = alpha <= cm(1.0);

    solver.addConstraints([
      xLowerConstraint,
      xUpperConstraint,
      yLowerConstraint,
      yUpperConstraint,
      alphaLowerConstraint,
      alphaUpperConstraint,
    ]);

    final dv = polygon.vertices.map((v) => v - aabb.min).toList();

    // Quadrilateral fitting constraints
    for (final d in dv) {
      final dx = d.x;
      final dy = d.y;

      for (final i in [0, 1, 2, 3]) {
        final j = (i + 1) % 4;

        final quadI = normalizedQuad.vertices[i];
        final quadJ = normalizedQuad.vertices[j];

        final constraint = cm(quadJ.x - quadI.x) *
                    (yNew + alpha * cm(dy) - cm(quadI.y)) -
                cm(quadJ.y - quadI.y) * (xNew + alpha * cm(dx) - cm(quadI.x)) <=
            cm(0);

        solver.addConstraint(constraint).message;
      }
    }

    final objectiveConstraint1 = alpha.equals(cm(1.0));
    objectiveConstraint1.priority = Priority.required - 1;

    solver.addConstraint(objectiveConstraint1);
    solver.flushUpdates();

    // We have solved for alpha, now we can solve for xNew and yNew.
    final constAlpha = alpha.value;
    solver.removeConstraint(objectiveConstraint1);
    solver.addConstraint(alpha.equals(cm(constAlpha)));

    // Distance constraints
    final yDist = Param(0.0);
    final xDist = Param(0.0);

    final yDistConstraint = yDist >= cm(0.0);
    final xDistConstraint = xDist >= cm(0.0);

    solver.addConstraints([yDistConstraint, xDistConstraint]);

    solver.addConstraints([
      yDist >= cm(aabb.min.y) - yNew,
      yDist >= yNew - cm(aabb.min.y),
      xDist >= cm(aabb.min.x) - xNew,
      xDist >= xNew - cm(aabb.min.x),
    ]);

    final objectiveConstraint2 = ((xDist + yDist)).equals(cm(0.0));
    objectiveConstraint2.priority = Priority.required - 1;

    solver.addConstraints([objectiveConstraint2]);
    solver.flushUpdates();

    final newAabb = Aabb2.minMax(
      Vector2(xNew.value, yNew.value),
      Vector2(
        xNew.value + aabbSize.x * alpha.value,
        yNew.value + aabbSize.y * alpha.value,
      ),
    );

    return newAabb;
  }
}
