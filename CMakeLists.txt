cmake_minimum_required(VERSION 3.26)

# must be called before project
if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    set(CMAKE_OSX_DEPLOYMENT_TARGET 14.0.0 CACHE STRING
        "Minimum operating system version for deployment"
    )
elseif(CMAKE_SYSTEM_NAME STREQUAL "iOS")
    set(CMAKE_OSX_DEPLOYMENT_TARGET 17.0.0 CACHE STRING
        "Minimum operating system version for deployment"
    )
endif()

message(STATUS "CMAKE_SYTEM_NAME is ${CMAKE_SYSTEM_NAME}")
message(STATUS "CMAKE_OSX_DEPLOYMENT_TARGET is ${CMAKE_OSX_DEPLOYMENT_TARGET}")

set(CMAKE_OSX_ARCHITECTURES $(ARCHS_STANDARD) CACHE STRING
    "Architectures to compile for on the selected platform"
)

message(STATUS "CMAKE_OSX_ARCHITECTURES is ${CMAKE_OSX_ARCHITECTURES}")

set_property(GLOBAL PROPERTY USE_FOLDERS YES)

project(MyFramework VERSION 0.0.1)

# Set the default signing identity and team ID to use
# for all targets, must be in the top level of the project
set(CMAKE_XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "Apple Development")
set(CMAKE_XCODE_ATTRIBUTE_DEVELOPMENT_TEAM 4PJU5FZK79)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED YES)
set(CMAKE_CXX_EXTENSIONS NO)

set(BUILD_VERSION $ENV{CI_JOB_ID})
if(BUILD_VERSION STREQUAL "")
    # This is a local build, not through CI system
    set(BUILD_VERSION 0)
endif()

set(PublicHeaders
        src/library/include/MyFramework.h
        src/library/include/Integrator.hpp)

set(PrivateHeaders
        src/library/include/IntegratorExperimental.hpp
        src/library/include/VerletIntegratorExperimental.hpp)

set(ProjectHeaders
        src/library/include/IntegratorImplementation.hpp
        src/library/include/VerletIntegratorImplementation.hpp)

add_library(MyFramework STATIC
        src/library/Integrator.cpp
        src/library/VerletIntegrator.cpp
        src/library/TestFile.cpp
        ${PublicHeaders}
        ${PrivateHeaders}
        ${ProjectHeaders})

get_target_property(sources MyFramework SOURCES)

source_group(TREE ${CMAKE_CURRENT_SOURCE_DIR} PREFIX "" FILES ${sources})

set_target_properties(MyFramework PROPERTIES
        FRAMEWORK TRUE
        FRAMEWORK_VERSION A
        PUBLIC_HEADER "${PublicHeaders}"
        PRIVATE_HEADER "${PrivateHeaders}"
        PROJECT_HEADER "${ProjectHeaders}"
        XCODE_ATTRIBUTE_PRODUCT_NAME "MyFramework"
        XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER "ai.fxp.myframework"
        XCODE_ATTRIBUTE_MARKETING_VERSION "${PROJECT_VERSION}" # user-visible version
        XCODE_ATTRIBUTE_CURRENT_PROJECT_VERSION "${BUILD_VERSION}" # build number
        XCODE_ATTRIBUTE_GENERATE_INFOPLIST_FILE YES
        XCODE_ATTRIBUTE_INFOPLIST_FILE ""
        XCODE_ATTRIBUTE_ENABLE_MODULE_VERIFIER YES
        XCODE_ATTRIBUTE_MODULE_VERIFIER_SUPPORTED_LANGUAGES "c++"
        XCODE_ATTRIBUTE_MODULE_VERIFIER_SUPPORTED_LANGUAGE_STANDARDS "c++20"
        XCODE_ATTRIBUTE_SKIP_INSTALL NO
        XCODE_ATTRIBUTE_INSTALL_PATH "/Library/Frameworks" # change for platforms other than macOS
)
