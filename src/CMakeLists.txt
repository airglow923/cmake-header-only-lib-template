set(PROJECT_EXE_NAME "${PROJECT_NAME}-cli")

file(GLOB_RECURSE PROJECT_SOURCES *.cc)

add_executable(${PROJECT_EXE_NAME} "")

set_target_properties(${PROJECT_EXE_NAME}
  PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}")

target_sources(${PROJECT_EXE_NAME}
  PRIVATE
    ${PROJECT_SOURCES})

target_compile_options(${PROJECT_EXE_NAME}
  PRIVATE
    -fPIE)

target_link_libraries(${PROJECT_EXE_NAME}
  PRIVATE
    ${PROJECT_NAME})

install(
  TARGETS ${PROJECT_EXE_NAME}
  DESTINATION /opt/hyundeok/cmake-template/bin)
