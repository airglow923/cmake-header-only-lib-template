if (NOT CMAKE_COMPILE_TEST AND
    NOT CMAKE_COMPILE_UNIT AND
    NOT CMAKE_COMPILE_PERF)
  return()
endif()

set(PROJECT_TEST_UNIT_NAME "${PROJECT_NAME}-tests-unit")
set(PROJECT_TEST_PERF_NAME "${PROJECT_NAME}-tests-perf")

# disable clang-tidy for testing as it uses third-party framework
set(CMAKE_CXX_CLANG_TIDY "")

find_package(GTest)

if (NOT GTest_FOUND)
  include(${PROJECT_SOURCE_DIR}/cmake/FetchGoogleTest.cmake)
endif()

set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

file(GLOB COMMON_TEST_SOURCES src/*.cc)

if (CMAKE_COMPILE_TEST OR CMAKE_COMPILE_UNIT)
  file(GLOB TEST_FILES ${CMAKE_CURRENT_LIST_DIR}/src/unit/*.cc)

  add_executable(${PROJECT_TEST_UNIT_NAME} "")

  set_target_properties(${PROJECT_TEST_UNIT_NAME}
    PROPERTIES
      RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}")

  target_include_directories(${PROJECT_TEST_UNIT_NAME}
    PRIVATE
      "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/tests/include>"
      "$<INSTALL_INTERFACE:${PROJECT_SOURCE_DIR}/tests/include>")

  target_sources(${PROJECT_TEST_UNIT_NAME}
    PRIVATE
      ${COMMON_TEST_SOURCES}
      ${TEST_FILES})

  target_compile_options(${PROJECT_TEST_UNIT_NAME}
    PRIVATE
      -fPIE)

  target_link_libraries(${PROJECT_TEST_UNIT_NAME}
    PRIVATE
      ${PROJECT_NAME}
      GTest::gtest
      GTest::gtest_main)

  add_test(NAME CMAKE_TEST COMMAND enricher_test)
endif()

if (CMAKE_COMPILE_TEST OR CMAKE_COMPILE_PERF)
  file(GLOB PERF_FILES ${CMAKE_CURRENT_LIST_DIR}/src/perf/*.cc)

  add_executable(${PROJECT_TEST_PERF_NAME} "")

  set_target_properties(${PROJECT_TEST_PERF_NAME}
    PROPERTIES
      RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}")

  target_include_directories(${PROJECT_TEST_PERF_NAME}
    PRIVATE
      "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/tests/include>"
      "$<INSTALL_INTERFACE:${PROJECT_SOURCE_DIR}/tests/include>")

  target_sources(${PROJECT_TEST_PERF_NAME}
    PRIVATE
      ${COMMON_TEST_SOURCES}
      ${PERF_FILES})

  target_compile_options(${PROJECT_TEST_PERF_NAME}
    PRIVATE
      -fPIE)

  target_link_libraries(${PROJECT_TEST_PERF_NAME}
    PRIVATE
      ${PROJECT_NAME}
      GTest::gtest
      GTest::gtest_main)

  add_test(NAME CMAKE_PERF COMMAND enricher_perf)
endif()
