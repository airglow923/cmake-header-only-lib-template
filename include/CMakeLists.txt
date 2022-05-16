add_library(${PROJECT_NAME} INTERFACE)

target_include_directories(${PROJECT_NAME}
  INTERFACE
    "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>"
    "$<INSTALL_INTERFACE:${PROJECT_SOURCE_DIR}/include>")

target_compile_options(${PROJECT_NAME}
  INTERFACE
    ${COMMON_COMPILE_FLAGS}
    "$<$<CONFIG:Debug>:${DEBUG_COMPILE_FLAGS}>"
    "$<$<CONFIG:Release>:${RELEASE_COMPILE_FLAGS}>")

target_link_libraries(${PROJECT_NAME}
  INTERFACE
    ${COMMON_LINK_FLAGS})
