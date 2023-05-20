#ifndef CROPPY_FFI_H
#define CROPPY_FFI_H

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#if _WIN32
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

#endif