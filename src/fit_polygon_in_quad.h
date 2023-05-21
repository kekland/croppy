#ifndef FIT_POLYGON_IN_QUAD_H
#define FIT_POLYGON_IN_QUAD_H

#include "croppy.h"

#ifdef __cplusplus
extern "C"
{
#endif

  Aabb2 fit_polygon_in_quad_impl(double *, int);

  Aabb2 fit_polygon_in_quad_on_resize_impl(double *points,
                                     int length,
                                     double aspectRatio,
                                     bool isTopLeftStatic,
                                     bool isTopRightStatic,
                                     bool isBottomLeftStatic,
                                     bool isBottomRightStatic);
#ifdef __cplusplus
}
#endif

#endif