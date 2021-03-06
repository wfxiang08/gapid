# The settings common to all armlinux builds
set(TARGET_OS LINUX)

if(CMAKE_BUILD_TYPE STREQUAL "Release")
    set(ARMLINUX_C_FLAGS "${ARMLINUX_C_FLAGS} -O2 -fPIC")
else()
    set(ARMLINUX_C_FLAGS "${ARMLINUX_C_FLAGS} -O0 -fPIC")
endif()

set(ARMLINUX_SYSROOT "")
if(NOT EXISTS ${ARMLINUX_SYSROOT})
    message( FATAL_ERROR "sysroot needs to be set for armlinux" )
endif()

# Set all derived variables
set(ARMLINUX_C_FLAGS "--sysroot=${ARMLINUX_SYSROOT} ${ARMLINUX_C_FLAGS} -funwind-tables -fsigned-char -no-canonical-prefixes -fvisibility=hidden")
set(ARMLINUX_CXX_FLAGS "${ARMLINUX_C_FLAGS} ${ARMLINUX_CXX_FLAGS}")
set(ARMLINUX_LINKER_FLAGS "${ARMLINUX_LINKER_FLAGS} -shared")

# Update cmake settings from armlinux ones
set(CMAKE_SYSROOT "${ARMLINUX_SYSROOT}")
set(CMAKE_STAGING_PREFIX ${CMAKE_BINARY_DIR}/stage)
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${ARMLINUX_C_FLAGS}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${ARMLINUX_CXX_FLAGS}")
include_directories("${ARMLINUX_SYSROOT}/usr/include")

set(ARMLINUX_COMPILER_BIN_PATH "")
if(NOT EXISTS ${ARMLINUX_COMPILER_BIN_PATH})
    message( FATAL_ERROR "compiler bin path needs to be set for armlinux" )
endif()

set(ARMLINUX_GCC_PATH "${ARMLINUX_COMPILER_BIN_PATH}/arm-linux-gcc")
set(ARMLINUX_GXX_PATH "${ARMLINUX_COMPILER_BIN_PATH}/arm-linux-g++")
set(ARMLINUX_RANLIB_PATH "${ARMLINUX_COMPILER_BIN_PATH}/arm-linux-gcc-ranlib")
set(ARMLINUX_AR_PATH "${ARMLINUX_COMPILER_BIN_PATH}/arm-linux-ar")
set(ARMLINUX_LD_PATH "${ARMLINUX_COMPILER_BIN_PATH}/arm-linux-ld")

# only search for libraries and includes in the toolchain
set(CMAKE_FIND_ROOT_PATH "${ARMLINUX_SYSROOT}")
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY BOTH)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

include (CMakeForceCompiler)
CMAKE_FORCE_C_COMPILER("${ARMLINUX_GCC_PATH}" GNU)
CMAKE_FORCE_CXX_COMPILER("${ARMLINUX_GXX_PATH}" GNU)
set(CMAKE_RANLIB "${ARMLINUX_RANLIB_PATH}" CACHE FILEPATH "" FORCE)
set(CMAKE_AR "${ARMLINUX_AR_PATH}" CACHE FILEPATH "" FORCE)
set(CMAKE_LINKER "${ARMLINUX_LD_PATH}" CACHE FILEPATH "" FORCE)
set(CMAKE_C_COMPILER_WORKS TRUE)
set(CMAKE_CXX_COMPILER_WORKS TRUE)
