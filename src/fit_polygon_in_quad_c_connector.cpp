#include <cstdlib>

#include "fit_polygon_in_quad.h"
#include "croppy_ffi.h"

#ifdef __cplusplus
extern "C" {
#endif

Aabb2 c_fit_polygon_in_quad_impl(double* points, int length) {
  return fit_polygon_in_quad_impl(points, length);
}

#ifdef __cplusplus
}
#endif
