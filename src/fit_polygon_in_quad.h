#ifndef FIT_POLYGON_IN_QUAD_H
#define FIT_POLYGON_IN_QUAD_H

#include "croppy_ffi.h"

Aabb2 fit_polygon_in_quad_impl(double *points, int length);

#endif