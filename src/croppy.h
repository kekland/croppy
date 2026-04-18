#ifndef CROPPY_H
#define CROPPY_H

// Common includes
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

// Windows-specific includes
#if defined(_WIN32)
#define NOMINMAX
#include <windows.h>
#else
#include <pthread.h>
#include <unistd.h>
#endif

// Export attributes
#if defined(_WIN32)
#define EXPORT __declspec(dllexport)
#else
#define EXPORT __attribute__((__visibility__("default"))) __attribute__((__used__))
#endif

#ifdef __cplusplus
  #define EXTERNC extern "C"
#else
  #define EXTERNC
#endif

#define FFI EXTERNC EXPORT

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

FFI struct Aabb2 fit_polygon_in_quad(double *points, int length);

FFI struct Aabb2 fit_polygon_in_quad_on_resize(double *points,
                                                      int length,
                                                      double aspectRatio,
                                                      bool isTopLeftStatic,
                                                      bool isTopRightStatic,
                                                      bool isBottomLeftStatic,
                                                      bool isBottomRightStatic);
#endif