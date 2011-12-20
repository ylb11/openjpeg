# -----------------------------------------------------------------------------
# Nightly script for OpenJPEG v1.5 with hulk paltform
# This will retrieve/compile/run tests/upload to cdash OpenJPEG
# Results will be available at: http://my.cdash.org/index.php?project=OPENJPEG
# ctest -S hulk_openJPEG_v1.5_nightly.cmake -V
# Author: mickael.savinaud@c-s.fr
# Date: 2011-07-12
# -----------------------------------------------------------------------------

cmake_minimum_required(VERSION 2.8)

# Set where to find src and test data and where to build binaries.
SET (CTEST_SOURCE_DIRECTORY       "$ENV{HOME}/Dashboard/src/OpenJPEG/opj-1.5")
SET (CTEST_BINARY_DIRECTORY       "$ENV{HOME}/Dashboard/build/OpenJPEG_v1.5-release")
SET (CTEST_SOURCE_DATA_DIRECTORY  "$ENV{HOME}/Dashboard/src/OpenJPEG/opj-data")

# User inputs:
SET( CTEST_CMAKE_GENERATOR      "Unix Makefiles" )    # What is your compilation apps ? (Eclipse CDT4 - Unix Makefiles)
SET( CTEST_CMAKE_COMMAND        "cmake" )
SET( CTEST_BUILD_COMMAND        "/usr/bin/make -j2" )
SET( CTEST_SITE                 "hulk.c-s.fr" )       # Generally the output of hostname
SET( CTEST_BUILD_CONFIGURATION  Release)                # What type of build do you want ?
SET( CTEST_BUILD_NAME           "Ubuntu10.04-64bits-v1.5-${CTEST_BUILD_CONFIGURATION}") # Build Name

set(KDUPATH $ENV{HOME}/Dashboard/src/OpenJPEG/kakadu)
set(ENV{LD_LIBRARY_PATH} ${KDUPATH})
set(ENV{PATH} $ENV{PATH}:${KDUPATH})

# User Options
set( CACHE_CONTENTS "
CMAKE_BUILD_TYPE:STRING=${CTEST_BUILD_CONFIGURATION}

CMAKE_C_FLAGS:STRING= -Wall 

BUILD_TESTING:BOOL=TRUE

OPJ_DATA_ROOT:PATH=${CTEST_SOURCE_DATA_DIRECTORY}

" )

# Files to submit to the dashboard
SET (CTEST_NOTES_FILES
${CTEST_SCRIPT_DIRECTORY}/${CTEST_SCRIPT_NAME}
${CTEST_BINARY_DIRECTORY}/CMakeCache.txt
)

# Update method 
# repository: http://openjpeg.googlecode.com/svn/branches/openjpeg-1.5 (openjpeg-read-only)
SET( CTEST_SVN_COMMAND      "/usr/bin/svn")


# 3. cmake specific:
ctest_empty_binary_directory( "${CTEST_BINARY_DIRECTORY}" )
file(WRITE "${CTEST_BINARY_DIRECTORY}/CMakeCache.txt" "${CACHE_CONTENTS}")

# Perform the Nightly build
ctest_start(Nightly TRACK "Nightly Release v1.5")
ctest_update(SOURCE "${CTEST_SOURCE_DIRECTORY}")
ctest_configure(BUILD "${CTEST_BINARY_DIRECTORY}")
ctest_read_custom_files(${CTEST_BINARY_DIRECTORY})
ctest_build(BUILD "${CTEST_BINARY_DIRECTORY}")
ctest_test(BUILD "${CTEST_BINARY_DIRECTORY}" PARALLEL_LEVEL 2)
ctest_submit()
