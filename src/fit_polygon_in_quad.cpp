#include "kiwi/kiwi.h"
#include "croppy.h"
#include "fit_polygon_in_quad.h"
#include <vector>
#include <algorithm>
#include <chrono>

using namespace kiwi;

Solver solver;

std::vector<Vector2> get_quad_points_vec(double *points, int length)
{
  std::vector<Vector2> quad_points_vec;

  for (int i = 0; i < 4; i++)
  {
    quad_points_vec.push_back(Vector2{points[2 * i], points[2 * i + 1]});
  }

  return quad_points_vec;
}

std::vector<Vector2> get_polygon_points_vec(double *points, int length)
{
  std::vector<Vector2> polygon_points_vec;

  for (int i = 0; i < (length - 8) / 2; i++)
  {
    polygon_points_vec.push_back(Vector2{points[8 + i * 2], points[9 + i * 2]});
  }

  return polygon_points_vec;
}

Aabb2 compute_aabb(std::vector<Vector2> const &points)
{
  Vector2 min;
  Vector2 max;

  for (int i = 0; i < points.size(); i++)
  {
    if (i == 0)
    {
      min = points[i];
      max = points[i];
    }
    else
    {
      min = Vector2{std::min(min.x, points[i].x), std::min(min.y, points[i].y)};
      max = Vector2{std::max(max.x, points[i].x), std::max(max.y, points[i].y)};
    }
  }

  return Aabb2{min, max};
}

Vector2 compute_aabb_size(Aabb2 aabb)
{
  return Vector2{aabb.max.x - aabb.min.x, aabb.max.y - aabb.min.y};
}

void set_basic_constraints(
    Solver &solver,
    std::vector<Vector2> const &quad_points_vec,
    std::vector<Vector2> const &polygon_points_vec,
    Variable const &out_x,
    Variable const &out_y,
    Variable const &out_ax,
    Variable const &out_ay)
{
  Aabb2 quad_aabb = compute_aabb(quad_points_vec);
  Aabb2 polygon_aabb = compute_aabb(polygon_points_vec);
  Vector2 polygon_size = compute_aabb_size(polygon_aabb);

  solver.addConstraint(Constraint{out_x >= quad_aabb.min.x});
  solver.addConstraint(Constraint{out_x <= quad_aabb.max.x});
  solver.addConstraint(Constraint{out_y >= quad_aabb.min.y});
  solver.addConstraint(Constraint{out_y <= quad_aabb.max.y});

  solver.addConstraint(Constraint{out_ax >= 0});
  solver.addConstraint(Constraint{out_ax <= 1});

  if (&out_ay != &out_ax)
  {
    solver.addConstraint(Constraint{out_ay >= 0});
    solver.addConstraint(Constraint{out_ay <= 1});
  }

  for (int poly_i = 0; poly_i < (polygon_points_vec).size(); poly_i++)
  {
    double dx = polygon_points_vec[poly_i].x - polygon_aabb.min.x;
    double dy = polygon_points_vec[poly_i].y - polygon_aabb.min.y;

    for (int i = 0; i < 4; i++)
    {
      int j = (i + 1) % 4;

      Vector2 quad_i = quad_points_vec[i];
      Vector2 quad_j = quad_points_vec[j];

      double quad_dx = quad_j.x - quad_i.x;
      double quad_dy = quad_j.y - quad_i.y;

      solver.addConstraint(Constraint{
          (quad_dx) * (out_y + out_ay * dy - quad_i.y) -
              (quad_dy) * (out_x + out_ax * dx - quad_i.x) <=
          0});
    }
  }
}

extern "C" Aabb2 fit_polygon_in_quad_impl(double *points, int length)
{
  solver.reset();
  std::vector<Vector2> quad_points_vec = get_quad_points_vec(points, length);
  std::vector<Vector2> polygon_points_vec = get_polygon_points_vec(points, length);

  Aabb2 quad_aabb = compute_aabb(quad_points_vec);
  Aabb2 polygon_aabb = compute_aabb(polygon_points_vec);
  Vector2 polygon_size = compute_aabb_size(polygon_aabb);

  Variable out_x("out_x");
  Variable out_y("out_y");
  Variable out_a("out_a");

  set_basic_constraints(solver, quad_points_vec, polygon_points_vec, out_x, out_y, out_a, out_a);

  Constraint objective_constraint_1 = Constraint{out_a == 1.0 | strength::required - 1};

  out_x.setValue(polygon_aabb.min.x);
  out_y.setValue(polygon_aabb.min.y);
  out_a.setValue(1);

  solver.addConstraint(objective_constraint_1);
  solver.updateVariables();

  double result_a = out_a.value();

  solver.removeConstraint(objective_constraint_1);
  solver.addConstraint(Constraint{out_a == result_a});

  Variable x_dist("x_dist");
  Variable y_dist("y_dist");

  solver.addConstraint(Constraint{x_dist >= 0});
  solver.addConstraint(Constraint{y_dist >= 0});

  solver.addConstraint(Constraint{x_dist >= polygon_aabb.min.x - out_x});
  solver.addConstraint(Constraint{x_dist >= out_x - polygon_aabb.min.x});
  solver.addConstraint(Constraint{y_dist >= polygon_aabb.min.y - out_y});
  solver.addConstraint(Constraint{y_dist >= out_y - polygon_aabb.min.y});

  Constraint objective_constraint_2 = Constraint{x_dist + y_dist == 0 | strength::required - 1};

  solver.addConstraint(objective_constraint_2);
  solver.updateVariables();

  double result_x = out_x.value();
  double result_y = out_y.value();

  return Aabb2{
      Vector2{result_x, result_y},
      Vector2{result_x + polygon_size.x * result_a, result_y + polygon_size.y * result_a},
  };
}

extern "C" Aabb2 fit_polygon_in_quad_on_resize_impl(double *points,
                                                    int length,
                                                    double aspectRatio,
                                                    bool isTopLeftStatic,
                                                    bool isTopRightStatic,
                                                    bool isBottomLeftStatic,
                                                    bool isBottomRightStatic)
{
  solver.reset();
  std::vector<Vector2> quad_points_vec = get_quad_points_vec(points, length);
  std::vector<Vector2> polygon_points_vec = get_polygon_points_vec(points, length);

  Aabb2 quad_aabb = compute_aabb(quad_points_vec);
  Aabb2 polygon_aabb = compute_aabb(polygon_points_vec);
  Vector2 polygon_size = compute_aabb_size(polygon_aabb);

  Variable out_x("out_x");
  Variable out_y("out_y");
  Variable out_ax("out_ax");
  Variable out_ay("out_ay");

  set_basic_constraints(solver, quad_points_vec, polygon_points_vec, out_x, out_y, out_ax, out_ay);

  if (aspectRatio != 0.0)
  {
    solver.addConstraint(Constraint{out_ax * polygon_size.x == out_ay * polygon_size.y * aspectRatio});
  }

  std::vector<Expression> static_point_x_expressions;
  std::vector<Expression> static_point_y_expressions;

  std::vector<double> static_point_x_equal_values;
  std::vector<double> static_point_y_equal_values;

  if (isTopLeftStatic)
  {
    static_point_x_expressions.push_back(Expression{out_x});
    static_point_y_expressions.push_back(Expression{out_y});

    static_point_x_equal_values.push_back(polygon_aabb.min.x);
    static_point_y_equal_values.push_back(polygon_aabb.min.y);
  }

  if (isTopRightStatic)
  {
    static_point_x_expressions.push_back(Expression{out_x + out_ax * polygon_size.x});
    static_point_y_expressions.push_back(Expression{out_y});

    static_point_x_equal_values.push_back(polygon_aabb.max.x);
    static_point_y_equal_values.push_back(polygon_aabb.min.y);
  }

  if (isBottomLeftStatic)
  {
    static_point_x_expressions.push_back(Expression{out_x});
    static_point_y_expressions.push_back(Expression{out_y + out_ay * polygon_size.y});

    static_point_x_equal_values.push_back(polygon_aabb.min.x);
    static_point_y_equal_values.push_back(polygon_aabb.max.y);
  }

  if (isBottomRightStatic)
  {
    static_point_x_expressions.push_back(Expression{out_x + out_ax * polygon_size.x});
    static_point_y_expressions.push_back(Expression{out_y + out_ay * polygon_size.y});

    static_point_x_equal_values.push_back(polygon_aabb.max.x);
    static_point_y_equal_values.push_back(polygon_aabb.max.y);
  }

  Expression x_points_expression = Expression{};
  Expression y_points_expression = Expression{};

  double x_points_equals = 0.0;
  double y_points_equals = 0.0;

  for (int i = 0; i < static_point_x_expressions.size(); i++)
  {
    auto x_expression = static_point_x_expressions[i];
    auto y_expression = static_point_y_expressions[i];

    double x_equal_value = static_point_x_equal_values[i];
    double y_equal_value = static_point_y_equal_values[i];

    x_points_expression = x_points_expression + x_expression;
    y_points_expression = y_points_expression + y_expression;

    x_points_equals += x_equal_value;
    y_points_equals += y_equal_value;
  }

  solver.addConstraint(Constraint{x_points_expression == x_points_equals});
  solver.addConstraint(Constraint{y_points_expression == y_points_equals});

  Constraint objective_constraint_1 = Constraint{out_ax == 1.0 | strength::required - 1};
  Constraint objective_constraint_2 = Constraint{out_ay == 1.0 | strength::required - 1};

  out_x.setValue(polygon_aabb.min.x);
  out_y.setValue(polygon_aabb.min.y);
  out_ax.setValue(1);
  out_ay.setValue(1);

  solver.addConstraint(objective_constraint_1);
  solver.addConstraint(objective_constraint_2);

  solver.updateVariables();

  double result_x = out_x.value();
  double result_y = out_y.value();
  double result_ax = out_ax.value();
  double result_ay = out_ay.value();

  return Aabb2{
      Vector2{result_x, result_y},
      Vector2{result_x + polygon_size.x * result_ax, result_y + polygon_size.y * result_ay},
  };
}