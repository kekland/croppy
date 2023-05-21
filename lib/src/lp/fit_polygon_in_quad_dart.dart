import 'package:croppy/src/src.dart';
import 'package:cassowary/cassowary.dart';

void _addBasicConstraints(
  Solver solver,
  Polygon2 polygon,
  Quad2 normalizedQuad,
  Param xNew,
  Param yNew,
  Param alphaX,
  Param? alphaY,
) {
  final aabb = polygon.boundingBox;

  final quadMin = normalizedQuad.boundingBox.min;
  final quadMax = normalizedQuad.boundingBox.max;

  final xMin = quadMin.x;
  final xMax = quadMax.x;
  final yMin = quadMin.y;
  final yMax = quadMax.y;

  solver.addConstraints([
    xNew >= cm(xMin),
    xNew <= cm(xMax),
    yNew >= cm(yMin),
    yNew <= cm(yMax),
    alphaX >= cm(0.0),
    alphaX <= cm(1.0),
  ]);

  if (alphaY != null) {
    solver.addConstraints([
      alphaY >= cm(0.0),
      alphaY <= cm(1.0),
    ]);
  }

  final dv = polygon.vertices.map((v) => v - aabb.min).toList();

  // Quadrilateral fitting constraints
  for (final d in dv) {
    final dx = d.x;
    final dy = d.y;

    for (final i in [0, 1, 2, 3]) {
      final j = (i + 1) % 4;

      final quadI = normalizedQuad.vertices[i];
      final quadJ = normalizedQuad.vertices[j];

      final _alphaY = alphaY ?? alphaX;

      final constraint = cm(quadJ.x - quadI.x) *
                  (yNew + _alphaY * cm(dy) - cm(quadI.y)) -
              cm(quadJ.y - quadI.y) * (xNew + alphaX * cm(dx) - cm(quadI.x)) <=
          cm(0);

      solver.addConstraint(constraint);
    }
  }
}

Aabb2 fitPolygonInQuadImpl(Polygon2 polygon, Quad2 normalizedQuad) {
  final aabb = polygon.boundingBox;
  final aabbSize = aabb.max - aabb.min;

  final solver = Solver();

  // The parameters we want to solve for.
  final xNew = Param(aabb.min.x);
  final yNew = Param(aabb.min.y);
  final alpha = Param(1.0);

  _addBasicConstraints(
    solver,
    polygon,
    normalizedQuad,
    xNew,
    yNew,
    alpha,
    null,
  );

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

  solver.addConstraints([
    yDist >= cm(0.0),
    xDist >= cm(0.0),
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

Aabb2 fitPolygonInQuadOnResizeImpl(
  Polygon2 polygon,
  Quad2 normalizedQuad, {
  required List<Corner> staticCorners,
  double? aspectRatio,
}) {
  final aabb = polygon.boundingBox;
  final aabbSize = aabb.max - aabb.min;

  final solver = Solver();

  // The parameters we want to solve for.
  final xNew = Param(aabb.min.x);
  final yNew = Param(aabb.min.y);
  final alphaX = Param(1.0);
  final alphaY = Param(1.0);

  _addBasicConstraints(
    solver,
    polygon,
    normalizedQuad,
    xNew,
    yNew,
    alphaX,
    alphaY,
  );

  if (aspectRatio != null) {
    solver.addConstraint(
      (alphaX * cm(aabbSize.x) - alphaY * cm(aabbSize.y) * cm(aspectRatio))
          .equals(cm(0.0)),
    );
  }

  final staticPointXExpressions = <Expression>[];
  final staticPointYExpressions = <Expression>[];

  final staticPointXEqualValues = <double>[];
  final staticPointYEqualValues = <double>[];

  if (staticCorners.contains(Corner.topLeft)) {
    staticPointXExpressions.add(xNew.asExpression());
    staticPointYExpressions.add(yNew.asExpression());

    staticPointXEqualValues.add(aabb.min.x);
    staticPointYEqualValues.add(aabb.min.y);
  }

  if (staticCorners.contains(Corner.topRight)) {
    staticPointXExpressions.add((xNew + alphaX * cm(aabbSize.x)));
    staticPointYExpressions.add(yNew.asExpression());

    staticPointXEqualValues.add(aabb.max.x);
    staticPointYEqualValues.add(aabb.min.y);
  }

  if (staticCorners.contains(Corner.bottomLeft)) {
    staticPointXExpressions.add(xNew.asExpression());
    staticPointYExpressions.add((yNew + alphaY * cm(aabbSize.y)));

    staticPointXEqualValues.add(aabb.min.x);
    staticPointYEqualValues.add(aabb.max.y);
  }

  if (staticCorners.contains(Corner.bottomRight)) {
    staticPointXExpressions.add((xNew + alphaX * cm(aabbSize.x)));
    staticPointYExpressions.add((yNew + alphaY * cm(aabbSize.y)));

    staticPointXEqualValues.add(aabb.max.x);
    staticPointYEqualValues.add(aabb.max.y);
  }

  var totalXExpression = Expression([], 0.0);
  var totalYExpression = Expression([], 0.0);

  for (var i = 0; i < staticPointXExpressions.length; i++) {
    final xExpression = staticPointXExpressions[i];
    final yExpression = staticPointYExpressions[i];

    final xEqualValue = staticPointXEqualValues[i];
    final yEqualValue = staticPointYEqualValues[i];

    totalXExpression = Expression(
      [...totalXExpression.terms, ...xExpression.terms],
      totalXExpression.constant - xEqualValue + xExpression.constant,
    );

    totalYExpression = Expression(
      [...totalYExpression.terms, ...yExpression.terms],
      totalYExpression.constant - yEqualValue + yExpression.constant,
    );
  }

  solver.addConstraint(totalXExpression.equals(cm(0.0)));
  solver.addConstraint(totalYExpression.equals(cm(0.0)));

  final objectiveConstraint1 = alphaX.equals(cm(1.0));
  final objectiveConstraint2 = alphaY.equals(cm(1.0));

  objectiveConstraint1.priority = Priority.required - 1;
  objectiveConstraint2.priority = Priority.required - 1;

  solver.addConstraints([
    objectiveConstraint1,
    objectiveConstraint2,
  ]);

  solver.flushUpdates();

  final newAabb = Aabb2.minMax(
    Vector2(xNew.value, yNew.value),
    Vector2(
      xNew.value + aabbSize.x * alphaX.value,
      yNew.value + aabbSize.y * alphaY.value,
    ),
  );

  return newAabb;
}
