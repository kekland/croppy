#include "croppy_ffi.h"
#include "fit_polygon_in_quad_c_connector.h"

FFI_PLUGIN_EXPORT Aabb2 fit_polygon_in_quad(double *points, int length) {
	return c_fit_polygon_in_quad_impl(points, length);
}

// Aabb2 fit_polygon_in_quad(float* points, int length)
// {
// 	Vector2 quad_point_0 = { points[0], points[1] };
// 	Vector2 quad_point_1 = { points[2], points[3] };
// 	Vector2 quad_point_2 = { points[4], points[5] };
// 	Vector2 quad_point_3 = { points[6], points[7] };
// 	Vector2 quad_points[4] = { quad_point_0, quad_point_1, quad_point_2, quad_point_3 };

// 	printf("Quad points:\n");
// 	for (int i = 0; i < 4; i++)
// 	{
// 		printf("  %f, %f\n", quad_points[i].x, quad_points[i].y);
// 	}
// 	printf("\n");

// 	int polygon_length = (length - 8) / 2;
// 	Vector2* polygon_points = (Vector2*)malloc(polygon_length * sizeof(Vector2));

// 	for (int i = 0; i < polygon_length; i++)
// 	{
// 		polygon_points[i].x = points[8 + i * 2];
// 		polygon_points[i].y = points[8 + i * 2 + 1];
// 	}

// 	printf("Polygon points:\n");
// 	for (int i = 0; i < polygon_length; i++)
// 	{
// 		printf("  %f, %f\n", polygon_points[i].x, polygon_points[i].y);
// 	}
// 	printf("\n");

// 	Vector2 polygon_min = { FLT_MAX, FLT_MAX };
// 	Vector2 polygon_max = { -FLT_MAX, -FLT_MAX };

// 	// Iterate through polygon points
// 	for (int i = 0; i < polygon_length; i++)
// 	{
// 		Vector2 point = polygon_points[i];

// 		// Check if point is smaller than current min
// 		if (point.x < polygon_min.x)
// 		{
// 			polygon_min.x = point.x;
// 		}

// 		if (point.y < polygon_min.y)
// 		{
// 			polygon_min.y = point.y;
// 		}

// 		// Check if point is larger than current max
// 		if (point.x > polygon_max.x)
// 		{
// 			polygon_max.x = point.x;
// 		}

// 		if (point.y > polygon_max.y)
// 		{
// 			polygon_max.y = point.y;
// 		}
// 	}

// 	printf("Polygon min: %f, %f\n", polygon_min.x, polygon_min.y);
// 	printf("Polygon max: %f, %f\n", polygon_max.x, polygon_max.y);
// 	printf("\n");

// 	Aabb2 aabb = { polygon_min, polygon_max };
// 	Vector2 aabb_size = { aabb.max.x - aabb.min.x, aabb.max.y - aabb.min.y };

// 	Vector2 quad_min = { FLT_MAX, FLT_MAX };
// 	Vector2 quad_max = { -FLT_MAX, -FLT_MAX };

// 	for (int i = 0; i < 4; i++)
// 	{
// 		Vector2 point = quad_points[i];

// 		// Check if point is smaller than current min
// 		if (point.x < quad_min.x)
// 		{
// 			quad_min.x = point.x;
// 		}

// 		if (point.y < quad_min.y)
// 		{
// 			quad_min.y = point.y;
// 		}

// 		// Check if point is larger than current max
// 		if (point.x > quad_max.x)
// 		{
// 			quad_max.x = point.x;
// 		}

// 		if (point.y > quad_max.y)
// 		{
// 			quad_max.y = point.y;
// 		}
// 	}

// 	printf("Quad min: %f, %f\n", quad_min.x, quad_min.y);
// 	printf("Quad max: %f, %f\n", quad_max.x, quad_max.y);
// 	printf("\n");

// 	am_Solver* solver = am_newsolver(NULL, NULL);

// 	am_Var* out_x = am_newvariable(solver);
// 	am_Var* out_y = am_newvariable(solver);
// 	am_Var* out_a = am_newvariable(solver);

// 	am_Constraint* c1 = am_newconstraint(solver, AM_REQUIRED);
// 	am_Constraint* c2 = am_newconstraint(solver, AM_REQUIRED);
// 	am_Constraint* c3 = am_newconstraint(solver, AM_REQUIRED);
// 	am_Constraint* c4 = am_newconstraint(solver, AM_REQUIRED);

// 	am_addterm(c1, out_x, 1.0f);
// 	am_setrelation(c1, AM_GREATEQUAL);
// 	am_addconstant(c1, quad_min.x);
// 	am_add(c1);
// 	printf("c1: out_x >= %f\n", quad_min.x);

// 	am_addterm(c2, out_y, 1.0f);
// 	am_setrelation(c2, AM_GREATEQUAL);
// 	am_addconstant(c2, quad_min.y);
// 	am_add(c2);
// 	printf("c2: out_y >= %f\n", quad_min.y);

// 	am_addterm(c3, out_x, 1.0f);
// 	am_setrelation(c3, AM_LESSEQUAL);
// 	am_addconstant(c3, quad_max.x);
// 	am_add(c3);
// 	printf("c3: out_x <= %f\n", quad_max.x);

// 	am_addterm(c4, out_y, 1.0f);
// 	am_setrelation(c4, AM_LESSEQUAL);
// 	am_addconstant(c4, quad_max.y);
// 	am_add(c4);
// 	printf("c4: out_y <= %f\n", quad_max.y);

// 	am_Constraint* alpha_lower_bound = am_newconstraint(solver, AM_REQUIRED);
// 	am_Constraint* alpha_upper_bound = am_newconstraint(solver, AM_REQUIRED);

// 	am_addterm(alpha_lower_bound, out_a, 1.0f);
// 	am_setrelation(alpha_lower_bound, AM_GREATEQUAL);
// 	am_addconstant(alpha_lower_bound, 0.001f);
// 	am_add(alpha_lower_bound);
// 	printf("alpha_lower_bound: out_a >= 0.001\n");

// 	am_addterm(alpha_upper_bound, out_a, 1.0f);
// 	am_setrelation(alpha_upper_bound, AM_LESSEQUAL);
// 	am_addconstant(alpha_upper_bound, 1.0f);
// 	am_add(alpha_upper_bound);
// 	printf("alpha_upper_bound: out_a <= 1.0\n");

// 	printf("\n");

// 	printf("Quadrilateral fitting constraints:\n");

// 	// Quadrilateral fitting constraints
// 	for (int polygon_i = 0; polygon_i < polygon_length; polygon_i++)
// 	{
// 		Vector2 point = polygon_points[polygon_i];

// 		float dx = point.x - aabb.min.x;
// 		float dy = point.y - aabb.min.y;

// 		for (int i = 0; i < 4; i++)
// 		{
// 			int j = (i + 1) % 4;

// 			Vector2 quad_i = quad_points[i];
// 			Vector2 quad_j = quad_points[j];

// 			am_Constraint* fit_constraint = am_newconstraint(solver, AM_REQUIRED - 1);

// 			float quad_dx = quad_j.x - quad_i.x;
// 			float quad_dy = quad_j.y - quad_i.y;

// 			am_addterm(fit_constraint, out_x, -quad_dy);
// 			am_addterm(fit_constraint, out_y, quad_dx);
// 			am_addterm(fit_constraint, out_a, quad_dx * dy - quad_dy * dx);

// 			am_setrelation(fit_constraint, AM_LESSEQUAL);

// 			am_addconstant(fit_constraint, quad_dx * quad_i.y - quad_dy * quad_i.x);

// 			printf("fit_constraint: (%f)out_x + (%f)out_y + (%f)out_a + (%f) <= 0.0\n", -quad_dy, quad_dx, quad_dx * dy - quad_dy * dx, quad_dx * quad_i.y - quad_dy * quad_i.x);
// 			am_add(fit_constraint);
// 		}
// 	}

// 	printf("\n");

// 	am_Constraint* objective_constraint_1 = am_newconstraint(solver, AM_REQUIRED - 1);

// 	am_addterm(objective_constraint_1, out_a, 1.0f);
// 	am_setrelation(objective_constraint_1, AM_EQUAL);
// 	am_addconstant(objective_constraint_1, 1.0f);
// 	am_add(objective_constraint_1);

// 	out_x->value = aabb.min.x;
// 	out_y->value = aabb.min.y;
// 	out_a->value = 1.0f;

// 	am_updatevars(solver);

// 	float const_alpha = am_value(out_a);
// 	printf("out_x: %f,\n out_y: %f,\n out_a: %f\n", am_value(out_x), am_value(out_y), am_value(out_a));

// 	if (0)
// 	{

// 		am_remove(objective_constraint_1);
// 		am_delconstraint(objective_constraint_1);

// 		am_Constraint* const_alpha_constraint = am_newconstraint(solver, AM_REQUIRED);

// 		am_addterm(const_alpha_constraint, out_a, 1.0f);
// 		am_setrelation(const_alpha_constraint, AM_EQUAL);
// 		am_addconstant(const_alpha_constraint, const_alpha);

// 		am_add(const_alpha_constraint);

// 		am_Var* x_dist = am_newvariable(solver);
// 		am_Var* y_dist = am_newvariable(solver);

// 		am_Constraint* y_dist_zero_constraint = am_newconstraint(solver, AM_REQUIRED);

// 		am_addterm(y_dist_zero_constraint, y_dist, 1.0f);
// 		am_setrelation(y_dist_zero_constraint, AM_GREATEQUAL);
// 		am_addconstant(y_dist_zero_constraint, 0.0f);
// 		am_add(y_dist_zero_constraint);

// 		am_Constraint* x_dist_zero_constraint = am_newconstraint(solver, AM_REQUIRED);

// 		am_addterm(x_dist_zero_constraint, x_dist, 1.0f);
// 		am_setrelation(x_dist_zero_constraint, AM_GREATEQUAL);
// 		am_addconstant(x_dist_zero_constraint, 0.0f);
// 		am_add(x_dist_zero_constraint);

// 		am_Constraint* y_dist_c_1 = am_newconstraint(solver, AM_REQUIRED);

// 		am_addterm(y_dist_c_1, y_dist, 1.0f);
// 		am_setrelation(y_dist_c_1, AM_GREATEQUAL);
// 		am_addconstant(y_dist_c_1, aabb.min.y);
// 		am_addterm(y_dist_c_1, out_y, -1.0f);
// 		am_add(y_dist_c_1);

// 		am_Constraint* y_dist_c_2 = am_newconstraint(solver, AM_REQUIRED);

// 		am_addterm(y_dist_c_2, y_dist, 1.0f);
// 		am_setrelation(y_dist_c_2, AM_GREATEQUAL);
// 		am_addterm(y_dist_c_2, out_y, 1.0f);
// 		am_addconstant(y_dist_c_2, -aabb.min.y);
// 		am_add(y_dist_c_2);

// 		am_Constraint* x_dist_c_1 = am_newconstraint(solver, AM_REQUIRED);

// 		am_addterm(x_dist_c_1, x_dist, 1.0f);
// 		am_setrelation(x_dist_c_1, AM_GREATEQUAL);
// 		am_addconstant(x_dist_c_1, aabb.min.x);
// 		am_addterm(x_dist_c_1, out_x, -1.0f);
// 		am_add(x_dist_c_1);

// 		am_Constraint* x_dist_c_2 = am_newconstraint(solver, AM_REQUIRED);

// 		am_addterm(x_dist_c_2, x_dist, 1.0);
// 		am_setrelation(x_dist_c_2, AM_GREATEQUAL);
// 		am_addterm(x_dist_c_2, out_x, 1.0);
// 		am_addconstant(x_dist_c_2, -aabb.min.x);
// 		am_add(x_dist_c_2);

// 		am_Constraint* objective_constraint_2 = am_newconstraint(solver, AM_REQUIRED - 1);

// 		am_addterm(objective_constraint_2, x_dist, 1.0);
// 		am_addterm(objective_constraint_2, y_dist, 1.0);
// 		am_setrelation(objective_constraint_2, AM_EQUAL);
// 		am_addconstant(objective_constraint_2, 0.0);
// 		am_add(objective_constraint_2);

// 		am_updatevars(solver);
// 	}

// 	float const_x = am_value(out_x);
// 	float const_y = am_value(out_y);

// 	Vector2 result_min = { const_x, const_y };
// 	Vector2 result_max = { const_x + aabb_size.x * const_alpha, const_y + aabb_size.y * const_alpha };
// 	Aabb2 result = { result_min, result_max };

// 	am_delsolver(solver);
// 	free(polygon_points);

// 	return result;
// }
