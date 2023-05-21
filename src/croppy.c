#include <stdbool.h>
#include "croppy.h"
#include "fit_polygon_in_quad.h"

FFI_PLUGIN_EXPORT Aabb2 fit_polygon_in_quad(double *points, int length)
{
	return fit_polygon_in_quad_impl(points, length);
}

FFI_PLUGIN_EXPORT Aabb2 fit_polygon_in_quad_on_resize(double *points,
																											int length,
																											double aspectRatio,
																											bool isTopLeftStatic,
																											bool isTopRightStatic,
																											bool isBottomLeftStatic,
																											bool isBottomRightStatic)
{
	return fit_polygon_in_quad_on_resize_impl(points,
																						length,
																						aspectRatio,
																						isTopLeftStatic,
																						isTopRightStatic,
																						isBottomLeftStatic,
																						isBottomRightStatic);
}