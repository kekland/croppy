# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(croppy_ffi_library VERSION 0.0.1 LANGUAGES C)

include_directories(kiwi)

add_library(croppy_ffi SHARED
  "croppy_ffi.c"
  "fit_polygon_in_quad_c_connector.cpp"
  "fit_polygon_in_quad.cpp"
)

set_target_properties(croppy_ffi PROPERTIES
  PUBLIC_HEADER croppy_ffi.h
  OUTPUT_NAME "croppy_ffi"
)

target_compile_definitions(croppy_ffi PUBLIC DART_SHARED_LIB)
