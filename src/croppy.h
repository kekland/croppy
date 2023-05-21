#ifndef CROPPY_H
#define CROPPY_H

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#if _WIN32
#define NOMINMAX
#include <windows.h>
#else
#include <pthread.h>
#include <unistd.h>
#endif

#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT
#endif

struct Vector2
{
  double x;
  double y;
};

typedef struct Vector2 Vector2;

struct Aabb2
{
  struct Vector2 min;
  struct Vector2 max;
};

typedef struct Aabb2 Aabb2;

FFI_PLUGIN_EXPORT Aabb2 fit_polygon_in_quad(double *points, int length);

FFI_PLUGIN_EXPORT Aabb2 fit_polygon_in_quad_on_resize(double *points,
                                                      int length,
                                                      double aspectRatio,
                                                      bool isTopLeftStatic,
                                                      bool isTopRightStatic,
                                                      bool isBottomLeftStatic,
                                                      bool isBottomRightStatic);
#endif