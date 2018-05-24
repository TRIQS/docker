# Start configuration
cmake_minimum_required(VERSION 2.8.12)
project(triqs_tests CXX)

# Default to Release build type
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Type of build" FORCE)
endif()
message( STATUS "-------- BUILD-TYPE: ${CMAKE_BUILD_TYPE} --------")

# Global options and definitions
add_compile_options(
	-std=c++17
	$<$<CONFIG:Debug>:-Og>
	)

# Load Triqs specific test macros in the proper way
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR})
macro(add_all_subdirectories_with_cmakelist)
  SET(print_decal_sub_dir "${print_decal_sub_dir}  ")
  FILE(GLOB ALLSUBS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} */CMakeLists.txt)
  foreach(f ${ALLSUBS})
     get_filename_component(d ${f} PATH)
     add_subdirectory(${d})
  endforeach(f ${ALLSUBS}) 
endmacro()

# Load Dependencies
find_package(Cpp2Py)
find_package(TRIQS)
link_libraries(triqs)

enable_testing()

# The C++ Triqs Tests
add_subdirectory(triqs)

# The Python Triqs Tests
if(${TRIQS_WITH_PYTHON_SUPPORT})
  add_subdirectory(pytriqs)
endif()
