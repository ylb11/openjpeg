# -----------------------------------------------------------------------------
# Nihtly script for OpenJPEG trunk
# This will retrieve/compile/run tests/upload to cdash OpenJPEG
# Results will be available at: http://my.cdash.org/index.php?project=OPENJPEG
# ctest -S PO9450-OpenJPEG-trunk-Nightly-Debug.cmake -V
# Author: mickael.savinaud@c-s.fr
# Date: 2012-03-15
# -----------------------------------------------------------------------------

cmake_minimum_required(VERSION 2.8)

# Set where to find src and test data and where to build binaries.
SET (CTEST_SOURCE_DIRECTORY       "C:/Users/msavinau/dev/nightly/src/opj-trunk")
SET (CTEST_BINARY_DIRECTORY       "C:/Users/msavinau/dev/nightly/build/opj-trunk-Debug")
SET (CTEST_SOURCE_DATA_DIRECTORY  "C:/Users/msavinau/dev/nightly/data/opj-data")

# User inputs:
SET( CTEST_CMAKE_GENERATOR      "Visual Studio 9 2008" )      # What is your compilation apps ?
SET( CTEST_CMAKE_COMMAND        "C:/Program Files/CMake 2.8/bin/cmake.exe" )
SET( CTEST_SITE                 "PO9450.c-s.fr" )             # Generally the output of hostname
SET( CTEST_BUILD_CONFIGURATION  Debug)                        # What type of build do you want ?
SET( CTEST_BUILD_NAME           "Win7-VS2008-32bits-trunk-${CTEST_BUILD_CONFIGURATION}") # Build Name

SET(CTEST_CUSTOM_WARNING_EXCEPTION  
    ${CTEST_CUSTOM_WARNING_EXCEPTION}
    ".*windef.h.*warning C4255.*"
    ".*stdio.h.*warning C4255.*"
    ".*stdlib.h.*warning C4255.*"
    ".*shellapi.h.*warning C4255.*"
    ".*rpcndr.h.*warning C4255.*"
    ".*winbase.h.*warning C4255.*"
    
    ".*basetsd.h.*warning C4668.*"
    ".*winnt.h.*warning C4668.*"
    ".*winuser.h.*warning C4668.*"
    ".*winperf.h.*warning C4668.*"
    ".*objbase.h.*warning C4668.*"
    ".*winioctl.h.*warning C4668.*"
    ".*wincrypt.h.*warning C4668.*"
    ".*objidl.h.*warning C4668.*"
    ".*rpcasync.h.*warning C4668.*"
    ".*shellapi.h.*warning C4668.*"
    ".*rpcdce.h.*warning C4668.*"
    ".*rpcdcep.h.*warning C4668.*"

    ".*winnt.h.*warning C4820.*"
    ".*winioctl.h.*warning C4820.*"
    ".*wtypes.h.*warning C4820.*"
    ".*winbase.h.*warning C4820.*"
    ".*winspool.h.*warning C4820.*"
    ".*winnls.h.*warning C4820.*"
    ".*winuser.h.*warning C4820.*"
    ".*wincon.h.*warning C4820.*"
    ".*mcx.h.*warning C4820.*"
    ".*winnetwk.h.*warning C4820.*"
    ".*wingdi.h.*warning C4820.*"
    ".*winperf.h.*warning C4820.*"
    ".*ktmtypes.h.*warning C4820.*"
    ".*dde.h.*warning C4820.*"
    ".*ddeml.h.*warning C4820.*"
    ".*rpcdce.h.*warning C4820.*"
    ".*rpcasync.h.*warning C4820.*"
    ".*shellapi.h.*warning C4820.*"
    ".*winsock.h.*warning C4820.*"
    ".*winsmcrd.h.*warning C4820.*"
    ".*objidl.h.*warning C4820.*"
    ".*oaidl.h.*warning C4820.*"
    ".*propidl.h.*warning C4820.*"
    ".*oleauto.h.*warning C4820.*"

#   ".*warning C4668.*"
#   ".*warning C4820.*"
)

set(KDUPATH "C:/Program Files/Kakadu")
set(ENV{PATH} "$ENV{PATH};${KDUPATH}")

set( CACHE_CONTENTS "
CMAKE_BUILD_TYPE:STRING=${CTEST_BUILD_CONFIGURATION}

#CMAKE_C_FLAGS:STRING= 

BUILD_TESTING:BOOL=TRUE

OPJ_DATA_ROOT:PATH=${CTEST_SOURCE_DATA_DIRECTORY}

" )

# Files to submit to the dashboard
SET (CTEST_NOTES_FILES
${CTEST_SCRIPT_DIRECTORY}/${CTEST_SCRIPT_NAME}
${CTEST_BINARY_DIRECTORY}/CMakeCache.txt
)

# Update method 
# repository: http://openjpeg.googlecode.com/svn/trunk/ (openjpeg-read-only)
# need to use https for CS machine
set( CTEST_UPDATE_COMMAND   "svn")

# 3. cmake specific:
#set( CTEST_NOTES_FILES      "${CTEST_SCRIPT_DIRECTORY}/${CTEST_SCRIPT_NAME}")

ctest_empty_binary_directory( "${CTEST_BINARY_DIRECTORY}" )
file(WRITE "${CTEST_BINARY_DIRECTORY}/CMakeCache.txt" "${CACHE_CONTENTS}")

# Perform the Nightly build
ctest_start(Nightly TRACK "Nightly Expected")
ctest_update(SOURCE "${CTEST_SOURCE_DIRECTORY}")
ctest_configure(BUILD "${CTEST_BINARY_DIRECTORY}")
ctest_read_custom_files(${CTEST_BINARY_DIRECTORY})
ctest_build(BUILD "${CTEST_BINARY_DIRECTORY}")
ctest_test(BUILD "${CTEST_BINARY_DIRECTORY}")
ctest_submit()
