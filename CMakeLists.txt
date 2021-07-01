cmake_minimum_required(VERSION 3.12)
find_program(MAKE_EXE NAMES cargo)

## CPP MAIN
add_executable(Example main.cpp)
include(ExternalProject)
include_directories(include)
set_directory_properties(PROPERTIES EP_PREFIX ${CMAKE_BINARY_DIR}/..)

## RUST LIBRARY DEP.
set(RUST_LIB_NAME "rust_lib")
set(CARGO_TARGET ${CMAKE_SOURCE_DIR}/${RUST_LIB_NAME}/target)

add_dependencies(Example rust_cpp_example)

ExternalProject_Add(
    rust_cpp_example
    STAMP_DIR "."
    BINARY_DIR ${CARGO_TARGET}
    TMP_DIR "."
    SOURCE_DIR "src"
    DOWNLOAD_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND cargo build COMMAND cargo build --release
    INSTALL_COMMAND ""
    LOG_BUILD ON
    )

add_custom_command(
  TARGET rust_cpp_example PRE_BUILD
  COMMAND /bin/bash -c "cbindgen  ./rust_lib -o ./include/example.h"
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  VERBATIM)


target_link_libraries(Example
    debug "${CARGO_TARGET}/debug/lib${RUST_LIB_NAME}.a"
    optimized "${CARGO_TARGET}/release/lib${RUST_LIB_NAME}.a"
    -Wl,--allow-multiple-definition -ldl -lpthread
    )

add_custom_command(
  TARGET Example POST_BUILD
  COMMAND /bin/bash -c "./build/Example"
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  VERBATIM)

set_target_properties(Example PROPERTIES CXX_STANDARD 11 CXX_STANDARD_REQUIRED ON)





