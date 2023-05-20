#ifndef FIT_POLYGON_IN_QUAD_H
#define FIT_POLYGON_IN_QUAD_H

#include "croppy.h"

#ifdef __cplusplus
extern "C"
{
#endif

  Aabb2 fit_polygon_in_quad_impl(double *, int);

#ifdef __cplusplus
}
#endif

#endif