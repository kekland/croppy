# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(croppy VERSION 0.0.1 LANGUAGES C CXX)

include_directories(kiwi)

add_library(croppy SHARED
  "fit_polygon_in_quad.cpp"
  "croppy.c"
)

set_target_properties(croppy PROPERTIES
  PUBLIC_HEADER croppy.h
  OUTPUT_NAME "croppy"
)

target_compile_definitions(croppy PUBLIC DART_SHARED_LIB)
