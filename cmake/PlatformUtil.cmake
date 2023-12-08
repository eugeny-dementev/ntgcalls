set(cmake_dir ${CMAKE_SOURCE_DIR}/cmake)
if(WIN32)
    set(OS_NAME WINDOWS)
    set(WINDOWS TRUE)
    add_compile_definitions(IS_WINDOWS)
elseif (UNIX AND NOT APPLE)
    set(OS_NAME LINUX)
    set(LINUX TRUE)
    add_compile_definitions(IS_LINUX)
elseif (UNIX AND APPLE)
    set(OS_NAME MACOS)
    set(MACOS TRUE)
    add_compile_definitions(IS_MACOS)
endif ()

if (DEFINED CMAKE_OSX_ARCHITECTURES AND NOT
        CMAKE_OSX_ARCHITECTURES STREQUAL "")
    set(OS_ARCH ${CMAKE_OSX_ARCHITECTURES})
else ()
    set(OS_ARCH ${CMAKE_HOST_SYSTEM_PROCESSOR})
endif ()

if (OS_ARCH STREQUAL "AMD64" OR OS_ARCH STREQUAL "x86_64")
    set(${OS_NAME}_x86_64 TRUE)
elseif (OS_ARCH STREQUAL "aarch64" OR OS_ARCH STREQUAL "arm64")
    set(${OS_NAME}_ARM64 TRUE)
endif ()

set(OS_FULL_NAME ${CMAKE_SYSTEM_NAME};${OS_ARCH})

function(setup_platform_libs target_name)
    if (WINDOWS)
        include(${cmake_dir}/Windows.cmake)
    elseif(LINUX)
        include(${cmake_dir}/Linux.cmake)
    elseif(MACOS)
        include(${cmake_dir}/macOS.cmake)
    else()
        message(FATAL_ERROR "${CMAKE_SYSTEM_NAME} with ${OS_ARCH} is not supported yet")
    endif()
endfunction()