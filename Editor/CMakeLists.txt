find_package(Vulkan REQUIRED)

age_add_target(
    NAME Editor EXECUTABLE
    FILES_CMAKE
        Editor_files.cmake
    INCLUDE_DIRECTORIES
        PRIVATE
            ${Vulkan_INCLUDE_DIR}
    BUILD_DEPENDENCIES
        PRIVATE
            ${Vulkan_LIBRARIES}
)

# enable_testing()
# 
# add_executable(EditorTest EditorTest.cpp)
# target_link_libraries(EditorTest gtest_main)
# 
# include(GoogleTest)
# gtest_discover_tests(EditorTest)
# 