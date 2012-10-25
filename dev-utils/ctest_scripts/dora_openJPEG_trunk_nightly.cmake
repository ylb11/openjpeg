# -----------------------------------------------------------------------------
# Nightly script for OpenJPEG trunk with hulk paltform (with dynamic analysis)
# This will retrieve/compile/run tests/upload to cdash OpenJPEG
# Results will be available at: http://my.cdash.org/index.php?project=OPENJPEG
# ctest -S dora_openJPEG_trunk_nightly.cmake -V
# Author: mickael.savinaud@c-s.fr
# Date: 2012-10-17
# -----------------------------------------------------------------------------

cmake_minimum_required(VERSION 2.8)

# Set where to find src and test data and where to build binaries.
SET (CTEST_SOURCE_DIRECTORY       "$ENV{HOME}/Dashboard/nightly/OPJ-Debug/src")
SET (CTEST_BINARY_DIRECTORY       "$ENV{HOME}/Dashboard/nightly/OPJ-Debug/build")
SET (CTEST_SOURCE_DATA_DIRECTORY  "$ENV{HOME}/Data/OPJ-Data")

# User inputs:
SET( CTEST_CMAKE_GENERATOR      "Unix Makefiles" )    # What is your compilation apps ? (Eclipse CDT4 - Unix Makefiles)
SET( CTEST_CMAKE_COMMAND        "cmake" )
SET( CTEST_BUILD_COMMAND        "/usr/bin/make -j3" )
SET( CTEST_SITE                  "dora.c-s.fr" )       # Generally the output of hostname
SET( CTEST_BUILD_CONFIGURATION  Debug)                # What type of build do you want ?
SET( CTEST_BUILD_NAME           "XUbuntu12.04-64bits-gcc463-${CTEST_BUILD_CONFIGURATION}") # Build Name
SET (CTEST_USE_LAUNCHERS ON)

# Input for dynamic analysis
SET(CTEST_MEMORYCHECK_COMMAND /usr/bin/valgrind)
SET(CTEST_MEMORYCHECK_COMMAND_OPTIONS "--trace-children=yes --quiet --tool=memcheck --leak-check=yes --show-reachable=yes --num-callers=50 --verbose --demangle=yes --gen-suppressions=all")
# If necessery add a file which remove some vlagrind warnings (see InsightValgrind.supp file from ITK)
#SET(CTEST_MEMORYCHECK_SUPPRESSIONS_FILE ${CTEST_SOURCE_DIRECTORY}/CMake/openjpeg_valgrind.supp)

#set(KDUPATH $ENV{HOME}/Dashboard/src/OpenJPEG/kakadu)
#set(ENV{LD_LIBRARY_PATH} ${KDUPATH})
#set(ENV{PATH} $ENV{PATH}:${KDUPATH})

# User Options
set( CACHE_CONTENTS "
CTEST_USE_LAUNCHERS:BOOL=ON
CMAKE_BUILD_TYPE:STRING=${CTEST_BUILD_CONFIGURATION}

CMAKE_C_FLAGS:STRING= -Wall 

BUILD_TESTING:BOOL=TRUE

OPJ_DATA_ROOT:PATH=${CTEST_SOURCE_DATA_DIRECTORY}

MEMORYCHECK_COMMAND:FILEPATH=${CTEST_MEMORYCHECK_COMMAND}
MEMORYCHECK_COMMAND_OPTIONS:STRING=${CTEST_MEMORYCHECK_COMMAND_OPTIONS}
MEMORYCHECK_SUPPRESSIONS_FILE:FILEPATH=${CTEST_MEMORYCHECK_SUPPRESSIONS_FILE}

" )

# Files to submit to the dashboard
SET (CTEST_NOTES_FILES
${CTEST_SCRIPT_DIRECTORY}/${CTEST_SCRIPT_NAME}
${CTEST_BINARY_DIRECTORY}/CMakeCache.txt
)

# Update method 
# repository: http://openjpeg.googlecode.com/svn/trunk (openjpeg-read-only)
SET( CTEST_SVN_COMMAND      "/usr/bin/svn")

# 3. cmake specific:
ctest_empty_binary_directory( "${CTEST_BINARY_DIRECTORY}" )
file(WRITE "${CTEST_BINARY_DIRECTORY}/CMakeCache.txt" "${CACHE_CONTENTS}")

# Perform the Nightly build with dynamic analysis (memcheck)
ctest_start(Nightly TRACK "Nightly Expected")
ctest_update(SOURCE "${CTEST_SOURCE_DIRECTORY}")
ctest_configure(BUILD "${CTEST_BINARY_DIRECTORY}")
ctest_read_custom_files(${CTEST_BINARY_DIRECTORY})
ctest_build(BUILD "${CTEST_BINARY_DIRECTORY}")
ctest_test(BUILD "${CTEST_BINARY_DIRECTORY}" PARALLEL_LEVEL 3)
ctest_memcheck(BUILD "${CTEST_BINARY_DIRECTORY}" PARALLEL_LEVEL 3)
ctest_submit()
