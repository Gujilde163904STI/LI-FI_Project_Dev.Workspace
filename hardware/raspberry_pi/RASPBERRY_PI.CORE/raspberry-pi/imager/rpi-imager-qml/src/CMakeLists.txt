# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2020-2025 Raspberry Pi Ltd

cmake_minimum_required(VERSION 3.22)
OPTION (ENABLE_CHECK_VERSION "Check for version updates" ON)
OPTION (ENABLE_TELEMETRY "Enable sending telemetry" ON)

# We use FetchContent_Populate() instead of FetchContent_MakeAvailable() to allow EXCLUDE_FROM_ALL
# This prevents the dependencies from being built by default, which is our desired behavior
# CMP0169 warns about this usage, but we intentionally want the old behavior
if(POLICY CMP0169)
    cmake_policy(SET CMP0169 OLD)
endif()

# OVERRIDE_FIND_PACKAGE is only available in CMake 3.24+
# Create a variable to conditionally use it
if(CMAKE_VERSION VERSION_GREATER_EQUAL "3.24")
    set(USE_OVERRIDE_FIND_PACKAGE "OVERRIDE_FIND_PACKAGE")
else()
    set(USE_OVERRIDE_FIND_PACKAGE "")
endif()

set(CMAKE_OSX_ARCHITECTURES "arm64;x86_64" CACHE STRING "Which macOS architectures to build for")

project(rpi-imager LANGUAGES CXX C)
set(IMAGER_VERSION_MAJOR 1)
set(IMAGER_VERSION_MINOR 9)
set(IMAGER_VERSION_PATCH 4)
set(IMAGER_VERSION_STR "${IMAGER_VERSION_MAJOR}.${IMAGER_VERSION_MINOR}.${IMAGER_VERSION_PATCH}")
set(IMAGER_VERSION_CSV "${IMAGER_VERSION_MAJOR},${IMAGER_VERSION_MINOR},${IMAGER_VERSION_PATCH},0")
add_definitions(-DIMAGER_VERSION_STR="${IMAGER_VERSION_STR}")
add_definitions(-DIMAGER_VERSION_CSV=${IMAGER_VERSION_CSV})
set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
#add_compile_options("-fsanitize=address")
#add_link_options("-fsanitize=address")

# You _must_ set your Qt6 root for the build to progress.
set(Qt6_ROOT "/opt/Qt/6.9.0/gcc_arm64" CACHE PATH "Your Qt6 root path")

if (WIN32)
    set(MINGW64_ROOT "" CACHE PATH "Your MinGW64 root path, likely provided by QtCreator")
    set(IMAGER_SIGNED_APP OFF CACHE BOOL "Sign Imager and its installer as part of the build. Requires a valid Code Signing certificate.")
endif()

if (APPLE)
    set(IMAGER_SIGNED_APP OFF CACHE BOOL "Perform signing of the Imager .app as part of the build")
    set(IMAGER_SIGNING_IDENTITY "" CACHE STRING "The Developer Identity to use for signing.")
    set(IMAGER_NOTARIZE_APP OFF CACHE BOOL "Perform notarization of the Imager .dmg as part of the build")
    set(IMAGER_NOTARIZE_KEYCHAIN_PROFILE "" CACHE STRING "The name of the Keychain item containing your notarization credentials")

    # Per CMake Bug 21918, if you do not use the following block, CMake will automatically include homebrew libraries.
    # This is undesirable, as on macOS/Apple Silicon, you may find newer versions of Qt will pull in new dependencies
    # - breaking your x86_64 build prematurely. Regardless, this is desirable behaviour to make the build more predictable.
    set(CMAKE_IGNORE_PATH)
    foreach(_prefix /sw /opt/local /usr/local /opt/homebrew)
      list(APPEND CMAKE_IGNORE_PATH ${_prefix}/bin ${_prefix}/include ${_prefix}/lib)
      list(APPEND CMAKE_SYSTEM_IGNORE_PATH ${_prefix}/bin ${_prefix}/include ${_prefix}/lib)
    endforeach()
endif(APPLE)

# Bundled code will occasionally use identical options - eg, BUILD_TESTING.
set(BUILD_TESTING OFF)
set(BUILD_STATIC_LIBS ON)
set(BUILD_SHARED_LIBS OFF)

include(FetchContent)

# Bundled liblzma
set(LIBLZMA_VERSION "5.8.1")
FetchContent_Declare(xz
    GIT_REPOSITORY https://github.com/tukaani-project/xz.git
    GIT_TAG v${LIBLZMA_VERSION}
    ${USE_OVERRIDE_FIND_PACKAGE}
)
set(XZ_MICROLZMA_DECODER OFF CACHE BOOL "" FORCE)
set(XZ_MICROLZMA_ENCODER OFF CACHE BOOL "" FORCE)
set(XZ_LZIP_DECODER OFF CACHE BOOL "" FORCE)
set(XZ_ENABLE_SANDBOX OFF CACHE BOOL "" FORCE)
set(XZ_BUILD_SHARED_LIBS OFF CACHE BOOL "" FORCE)
set(XZ_ENABLE_DOXYGEN OFF CACHE BOOL "" FORCE)
set(XZ_DECODERS
    lzma1
    lzma2
    delta
)
set(XZ_ENCODERS
    lzma1
    lzma2
    delta
)
set(CREATE_LZMA_SYMLINKS OFF CACHE BOOL "" FORCE)
set(CREATE_XZ_SYMLINKS OFF CACHE BOOL "" FORCE)
FetchContent_GetProperties(xz)
if(NOT xz_POPULATED)
    FetchContent_Populate(xz)
    add_subdirectory(${xz_SOURCE_DIR} ${xz_BINARY_DIR} EXCLUDE_FROM_ALL)
endif()
unset(XZ_MICROLZMA_DECODER)
unset(XZ_MICROLZMA_ENCODER)
unset(XZ_LZIP_DECODER)
unset(XZ_ENABLE_SANDBOX)
unset(XZ_BUILD_SHARED_LIBS)
unset(XZ_ENABLE_DOXYGEN)
unset(CREATE_LZMA_SYMLINKS)
unset(CREATE_XZ_SYMLINKS)
set(LIBLZMA_FOUND true CACHE BOOL "" FORCE)
set(LIBLZMA_INCLUDE_DIR ${xz_SOURCE_DIR}/src/liblzma/api CACHE PATH "" FORCE)
set(LIBLZMA_INCLUDE_DIRS ${xz_SOURCE_DIR}/src/liblzma/api CACHE PATH "" FORCE)
set(LIBLZMA_LIBRARY liblzma CACHE FILEPATH "" FORCE)
set(LIBLZMA_LIBRARIES ${xz_BINARY_DIR}/liblzma.a CACHE FILEPATH "" FORCE)
set(LIBLZMA_HAS_AUTO_DECODER true CACHE BOOL "" FORCE)
set(LIBLZMA_HAS_EASY_ENCODER true CACHE BOOL "" FORCE)
set(LIBLZMA_HAS_LZMA_PRESET true CACHE BOOL "" FORCE)

# Bundled zstd
set(ZSTD_VERSION "1.5.7")
FetchContent_Declare(zstd
    GIT_REPOSITORY https://github.com/facebook/zstd.git
    GIT_TAG v${ZSTD_VERSION}
    SOURCE_SUBDIR build/cmake
    ${USE_OVERRIDE_FIND_PACKAGE}
)
set(ZSTD_BUILD_PROGRAMS OFF CACHE BOOL "" FORCE)
set(ZSTD_BUILD_SHARED OFF CACHE BOOL "" FORCE)
set(ZSTD_BUILD_STATIC ON CACHE BOOL "" FORCE)
set(ZSTD_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(ZSTD_BUILD_DICTBUILDER OFF CACHE BOOL "" FORCE)
FetchContent_GetProperties(zstd)
if(NOT zstd_POPULATED)
    FetchContent_Populate(zstd)
    add_subdirectory(${zstd_SOURCE_DIR}/build/cmake ${zstd_BINARY_DIR} EXCLUDE_FROM_ALL)
endif()
unset(ZSTD_BUILD_PROGRAMS)
unset(ZSTD_BUILD_SHARED)
unset(ZSTD_BUILD_STATIC)
unset(ZSTD_BUILD_TESTS)
unset(ZSTD_BUILD_DICTBUILDER)
set(ZSTD_FOUND true CACHE BOOL "" FORCE)
set(Zstd_VERSION ${ZSTD_VERSION} CACHE STRING "" FORCE)
set(Zstd_INCLUDE_DIR ${CMAKE_CURRENT_BINARY_DIR}/_deps/zstd-src/lib CACHE PATH "" FORCE)
set(ZSTD_INCLUDE_DIR ${CMAKE_CURRENT_BINARY_DIR}/_deps/zstd-src/lib CACHE PATH "" FORCE)
set(Zstd_INCLUDE_DIRS ${CMAKE_CURRENT_BINARY_DIR}/_deps/zstd-src/lib CACHE PATH "" FORCE)
set(ZSTD_INCLUDE_DIRS ${CMAKE_CURRENT_BINARY_DIR}/_deps/zstd-src/lib CACHE PATH "" FORCE)
set(Zstd_LIBRARIES libzstd_static CACHE FILEPATH "" FORCE)
set(ZSTD_LIBRARIES libzstd_static CACHE FILEPATH "" FORCE)
set(ZSTD_LIBRARY ${CMAKE_CURRENT_BINARY_DIR}/_deps/zstd-build/lib/libzstd.a CACHE FILEPATH "" FORCE)

# Remote nghttp2
set(NGHTTP2_VERSION "1.65.0")
FetchContent_Declare(nghttp2
    GIT_REPOSITORY https://github.com/nghttp2/nghttp2.git
    GIT_TAG        v${NGHTTP2_VERSION}
    ${USE_OVERRIDE_FIND_PACKAGE}
)
set(BUILD_EXAMPLES OFF)
set(ENABLE_LIB_ONLY ON)
set(ENABLE_FAILMALLOC OFF)
FetchContent_GetProperties(nghttp2)
if(NOT nghttp2_POPULATED)
    FetchContent_Populate(nghttp2)
    add_subdirectory(${nghttp2_SOURCE_DIR} ${nghttp2_BINARY_DIR} EXCLUDE_FROM_ALL)
endif()
unset(ENABLE_LIB_ONLY)
unset(ENABLE_FAILMALLOC)
unset(BUILD_EXAMPLES)
set(NGHTTP2_LIBRARIES nghttp2_static CACHE FILEPATH "" FORCE)
set(NGHTTP2_LIBRARY nghttp2_static CACHE FILEPATH "" FORCE)
set(NGHTTP2_INCLUDE_DIR ${nghttp2_SOURCE_DIR}/lib CACHE PATH "" FORCE)
set(NGHTTP2_INCLUDE_DIRS ${nghttp2_SOURCE_DIR}/lib CACHE PATH "" FORCE)
set(NGHTTP2_FOUND true CACHE BOOL "" FORCE)


# Bundled zlib
set(ZLIB_VERSION "1.4.1.1")
set(ZLIB_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(ZLIB_BUILD_SHARED OFF CACHE BOOL "" FORCE)
set(ZLIB_BUILD_STATIC ON CACHE BOOL "" FORCE)
set(ZLIB_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(SKIP_INSTALL_ALL ON CACHE BOOL "" FORCE)
FetchContent_Declare(zlib
    GIT_REPOSITORY https://github.com/madler/zlib.git
    GIT_TAG 5a82f71ed1dfc0bec044d9702463dbdf84ea3b71 # v1.4.1.1, as of 27/05/2025
    ${USE_OVERRIDE_FIND_PACKAGE}
)
FetchContent_GetProperties(zlib)
if(NOT zlib_POPULATED)
    FetchContent_Populate(zlib)
    add_subdirectory(${zlib_SOURCE_DIR} ${zlib_BINARY_DIR} EXCLUDE_FROM_ALL)
endif()
unset(ZLIB_BUILD_EXAMPLES)
unset(ZLIB_BUILD_SHARED)
unset(ZLIB_BUILD_STATIC)
unset(ZLIB_BUILD_TESTS)
unset(SKIP_INSTALL_ALL)
# Set zlib variables that libarchive's CMake will use
set(ZLIB_USE_STATIC_LIBS ON CACHE BOOL "" FORCE) # This is to help FindZlib.cmake find the static library over the shared one
set(ZLIB_ROOT ${zlib_SOURCE_DIR} CACHE PATH "" FORCE)

# On Windows with MinGW, zlib builds with .a extension, not .lib
# Set the correct library path before find_package
if (WIN32 AND CMAKE_COMPILER_IS_GNUCXX)
    set(ZLIB_LIBRARY ${zlib_BINARY_DIR}/libzlibstatic.a CACHE FILEPATH "" FORCE)
    set(ZLIB_LIBRARIES ${zlib_BINARY_DIR}/libzlibstatic.a CACHE STRING "" FORCE)
else()
    set(ZLIB_LIBRARY ${zlib_BINARY_DIR}/libz.a CACHE FILEPATH "" FORCE)
    set(ZLIB_LIBRARIES ${zlib_BINARY_DIR}/libz.a CACHE STRING "" FORCE)
endif()

# Since we're building zlib ourselves with EXCLUDE_FROM_ALL, we don't need find_package
# Instead, we'll create the ZLIB::ZLIB target manually and set all required variables
set(ZLIB_INCLUDE_DIR ${zlib_SOURCE_DIR} CACHE PATH "" FORCE)
set(ZLIB_INCLUDE_DIRS ${zlib_SOURCE_DIR} CACHE PATH "" FORCE)

# Create ZLIB::ZLIB target manually since we're not using find_package
# Set zlib variables that other packages expect
set(ZLIB_FOUND TRUE CACHE BOOL "" FORCE)
add_library(ZLIB::ZLIB STATIC IMPORTED)
if (WIN32 AND CMAKE_COMPILER_IS_GNUCXX)
    set_target_properties(ZLIB::ZLIB PROPERTIES
        IMPORTED_LOCATION "${zlib_BINARY_DIR}/libzlibstatic.a"
        INTERFACE_INCLUDE_DIRECTORIES "${zlib_SOURCE_DIR};${zlib_BINARY_DIR}"
    )
    add_dependencies(ZLIB::ZLIB zlibstatic)
else()
    set_target_properties(ZLIB::ZLIB PROPERTIES
        IMPORTED_LOCATION "${zlib_BINARY_DIR}/libz.a"
        INTERFACE_INCLUDE_DIRECTORIES "${zlib_SOURCE_DIR};${zlib_BINARY_DIR}"
    )
    add_dependencies(ZLIB::ZLIB zlibstatic)
endif()

# Debug output
message(STATUS "ZLIB_LIBRARY set to: ${ZLIB_LIBRARY}")
message(STATUS "ZLIB_LIBRARIES set to: ${ZLIB_LIBRARIES}")
message(STATUS "ZLIB_INCLUDE_DIRS set to: ${ZLIB_INCLUDE_DIRS}")

# Bundled libarchive

set(ENABLE_WERROR OFF CACHE BOOL "")
set(ENABLE_INSTALL OFF CACHE BOOL "")
set(ENABLE_TEST OFF CACHE BOOL "")
set(ENABLE_CNG OFF CACHE BOOL "")
set(ENABLE_MBEDTLS OFF CACHE BOOL "")
set(ENABLE_NETTLE OFF CACHE BOOL "")
set(ENABLE_OPENSSL OFF CACHE BOOL "")
# Configure libarchive with explicit zlib support
set(ENABLE_ZLIB ON CACHE BOOL "")
set(ENABLE_BZip2 OFF CACHE BOOL "")
set(ENABLE_LZ4 OFF CACHE BOOL "")
set(ENABLE_LZO OFF CACHE BOOL "")
set(ENABLE_LIBB2 OFF CACHE BOOL "")
set(ENABLE_LIBXML2 OFF CACHE BOOL "")
set(ENABLE_EXPAT OFF CACHE BOOL "")
set(ENABLE_PCREPOSIX OFF CACHE BOOL "")
set(ENABLE_PCRE2POSIX OFF CACHE BOOL "")
set(ENABLE_LIBGCC OFF CACHE BOOL "")
set(ENABLE_TAR OFF CACHE BOOL "")
set(ENABLE_CPIO OFF CACHE BOOL "")
set(ENABLE_CAT OFF CACHE BOOL "")
set(BUILD_SHARED_LIBS OFF CACHE BOOL "")
set(ARCHIVE_BUILD_STATIC_LIBS ON CACHE BOOL "")
set(ARCHIVE_BUILD_EXAMPLES OFF CACHE BOOL "")
set(ENABLE_ZSTD ON CACHE BOOL "")
set(POSIX_REGEX_LIB "libc" CACHE STRING "" FORCE)
set(LIBARCHIVE_VERSION "3.8.0")

# Create a patch script to fix ZSTD detection in libarchive
set(LIBARCHIVE_PATCH_FILE "${CMAKE_CURRENT_BINARY_DIR}/libarchive_zstd_patch.cmake")
file(WRITE ${LIBARCHIVE_PATCH_FILE} "
# Read the original CMakeLists.txt
file(READ \"\${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.txt\" CONTENT)

# Find the start and end of the ZSTD section
string(FIND \"\${CONTENT}\" \"IF(ZSTD_FOUND)\" ZSTD_START)
string(FIND \"\${CONTENT}\" \"MARK_AS_ADVANCED(CLEAR ZSTD_INCLUDE_DIR)\" ZSTD_END)

if(ZSTD_START GREATER -1 AND ZSTD_END GREATER -1)
    # Calculate positions
    math(EXPR ZSTD_END \"\${ZSTD_END} + 40\") # Length of \"MARK_AS_ADVANCED(CLEAR ZSTD_INCLUDE_DIR)\"
    
    # Extract parts before and after the ZSTD section
    string(SUBSTRING \"\${CONTENT}\" 0 \${ZSTD_START} BEFORE_ZSTD)
    string(SUBSTRING \"\${CONTENT}\" \${ZSTD_END} -1 AFTER_ZSTD)
    
    # Create the new ZSTD section
    set(NEW_ZSTD_SECTION \"IF(ZSTD_FOUND)
  SET(HAVE_ZSTD_H 1)
  INCLUDE_DIRECTORIES(\\\${ZSTD_INCLUDE_DIR})
  LIST(APPEND ADDITIONAL_LIBS \\\${ZSTD_LIBRARY})
  
  # Check if ZSTD variables were provided externally (indicating static build)
  get_property(ZSTD_LIB_IS_CACHE CACHE ZSTD_LIBRARY PROPERTY TYPE)
  get_property(ZSTD_INC_IS_CACHE CACHE ZSTD_INCLUDE_DIR PROPERTY TYPE)
  if(ZSTD_LIB_IS_CACHE AND ZSTD_INC_IS_CACHE)
    # Skip function checks for static builds and assume all functions are available
    message(STATUS \\\"Using provided ZSTD library: \\\${ZSTD_LIBRARY}\\\")
    SET(HAVE_LIBZSTD 1)
    SET(HAVE_ZSTD_compressStream 1)
    SET(HAVE_ZSTD_minCLevel 1)
  else()
    # Original function checks for dynamic builds
    CMAKE_PUSH_CHECK_STATE()
    SET(CMAKE_REQUIRED_LIBRARIES \\\${ZSTD_LIBRARY})
    SET(CMAKE_REQUIRED_INCLUDES \\\${ZSTD_INCLUDE_DIR})
    CHECK_FUNCTION_EXISTS(ZSTD_decompressStream HAVE_LIBZSTD)
    CHECK_FUNCTION_EXISTS(ZSTD_compressStream HAVE_ZSTD_compressStream)
    CHECK_FUNCTION_EXISTS(ZSTD_minCLevel HAVE_ZSTD_minCLevel)
    CMAKE_POP_CHECK_STATE()
  endif()
ENDIF(ZSTD_FOUND)
MARK_AS_ADVANCED(CLEAR ZSTD_INCLUDE_DIR)\")
    
    # Combine the parts
    set(NEW_CONTENT \"\${BEFORE_ZSTD}\${NEW_ZSTD_SECTION}\")
    
    # Write the modified content back
    file(WRITE \"\${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.txt\" \"\${NEW_CONTENT}\${AFTER_ZSTD}\")
    message(STATUS \"Patched libarchive CMakeLists.txt for static ZSTD support\")
else()
    message(WARNING \"Could not find ZSTD section in libarchive CMakeLists.txt\")
endif()
")

FetchContent_Declare(libarchive
    GIT_REPOSITORY https://github.com/libarchive/libarchive.git
    GIT_TAG v${LIBARCHIVE_VERSION}
    PATCH_COMMAND ${CMAKE_COMMAND} -P ${LIBARCHIVE_PATCH_FILE}
    ${USE_OVERRIDE_FIND_PACKAGE}
)
FetchContent_GetProperties(libarchive)
if(NOT libarchive_POPULATED)
    FetchContent_Populate(libarchive)
    add_subdirectory(${libarchive_SOURCE_DIR} ${libarchive_BINARY_DIR} EXCLUDE_FROM_ALL)
endif()

# Ensure libarchive is built after zlib
if (TARGET archive_static AND TARGET ZLIB::ZLIB)
    add_dependencies(archive_static ZLIB::ZLIB)
endif()

unset(POSIX_REGEX_LIB)
unset(ENABLE_WERROR)
unset(ENABLE_INSTALL)
unset(ENABLE_TEST)
unset(ENABLE_CNG)
unset(ENABLE_MBEDTLS)
unset(ENABLE_NETTLE)
unset(ENABLE_OPENSSL)
unset(ENABLE_ZLIB)
unset(ENABLE_BZip2)
unset(ENABLE_LZ4)
unset(ENABLE_LZO)
unset(ENABLE_LIBB2)
unset(ENABLE_LIBXML2)
unset(ENABLE_EXPAT)
unset(ENABLE_PCREPOSIX)
unset(ENABLE_PCRE2POSIX)
unset(ENABLE_LIBGCC)
unset(ENABLE_TAR)
unset(ENABLE_CPIO)
unset(ENABLE_CAT)
unset(ARCHIVE_BUILD_SHARED_LIBS)
unset(ENABLE_ZSTD)
set(LibArchive_FOUND true CACHE BOOL "" FORCE)
set(LibArchive_LIBRARIES archive_static CACHE FILEPATH "" FORCE)
set(LibArchive_INCLUDE_DIR ${libarchive_SOURCE_DIR}/libarchive CACHE PATH "" FORCE)
set(LibArchive_INCLUDE_DIRS ${libarchive_SOURCE_DIR}/libarchive CACHE PATH "" FORCE)

# Bundled libcurl
set(CURL_VERSION "8.14.1")
string(REPLACE "." "_" CURL_TAG ${CURL_VERSION})
FetchContent_Declare(curl
    GIT_REPOSITORY https://github.com/curl/curl.git
    GIT_TAG curl-${CURL_TAG}
    ${USE_OVERRIDE_FIND_PACKAGE}
)
set(BUILD_CURL_EXE OFF CACHE BOOL "" FORCE)
set(BUILD_LIBCURL_DOCS OFF CACHE BOOL "" FORCE)
set(BUILD_MISC_DOCS OFF CACHE BOOL "" FORCE)
set(ENABLE_CURL_MANUAL OFF CACHE BOOL "" FORCE)
set(BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(CURL_USE_LIBPSL OFF CACHE BOOL "" FORCE)
set(CURL_USE_LIBSSH2 OFF CACHE BOOL "" FORCE)
set(CURL_DISABLE_ALTSVC ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_BASIC_AUTH ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_BEARER_AUTH ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_DIGEST_AUTH ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_KERBEROS_AUTH ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_NEGOTIATE_AUTH ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_NTLM ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_AWS ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_DICT ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_FILE ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_FTP ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_GOPHER ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_IMAP ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_LDAP ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_LDAPS ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_MQTT ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_POP3 ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_RTSP ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_SMB ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_SMTP ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_TELNET ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_TFTP ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_DOH ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_HSTS ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_IPFS ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_WEBSOCKETS ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_PROXY ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_QUIC ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_FORM_API ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_MIME ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_BINDLOCAL ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_GETOPTIONS ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_HEADERS_API ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_LIBCURL_OPTION ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_NETRC ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_PARSEDATE ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_SHA512_256 ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_SHUFFLE_DNS ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_SOCKETPAIR ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_SRP ON CACHE BOOL "" FORCE)
set(CURL_DISABLE_VERBOSE_STRINGS ON CACHE BOOL "" FORCE)
set(USE_NGHTTP2 ON CACHE BOOL "" FORCE)
set(CURL_ZSTD ON)
set(CURL_ENABLE_EXPORT_TARGET OFF CACHE BOOL "" FORCE)
set(CURL_DISABLE_INSTALL ON)
if (APPLE)
    # TODO: SecureTransport is a deprecated API in macOS, supporting
    #       only up to TLS v1.2. cURL has not implemented the replacement,
    #       Network.framework, and so we will need to select an alternative.
    #       Best recommendation: Libressl, as used by Apple in the curl binary
    #       on macOS.
    set(CURL_USE_SECTRANSP ON)
    set(CURL_DEFAULT_SSL_BACKEND "secure-transport")
    set(USE_APPLE_IDN ON)
else()
    if (WIN32)
        set(CURL_USE_SCHANNEL ON)
        set(CURL_DEFAULT_SSL_BACKEND "schannel")
    else ()
        set(CURL_USE_GNUTLS ON)
        set(CURL_DEFAULT_SSL_BACKEND "gnutls")
    endif(WIN32)
endif(APPLE)

FetchContent_GetProperties(curl)
if(NOT curl_POPULATED)
    FetchContent_Populate(curl)
    add_subdirectory(${curl_SOURCE_DIR} ${curl_BINARY_DIR} EXCLUDE_FROM_ALL)
endif()

unset(BUILD_CURL_EXE)
unset(BUILD_LIBCURL_DOCS)
unset(BUILD_MISC_DOCS)
unset(ENABLE_CURL_MANUAL)
unset(BUILD_EXAMPLES)
unset(CURL_USE_LIBPSL)
unset(CURL_USE_LIBSSH2)
unset(CURL_DISABLE_ALTSVC)
unset(CURL_DISABLE_BASIC_AUTH)
unset(CURL_DISABLE_BEARER_AUTH)
unset(CURL_DISABLE_DIGEST_AUTH)
unset(CURL_DISABLE_KERBEROS_AUTH)
unset(CURL_DISABLE_NEGOTIATE_AUTH)
unset(CURL_DISABLE_NTLM)
unset(CURL_DISABLE_AWS)
unset(CURL_DISABLE_DICT)
unset(CURL_DISABLE_FILE)
unset(CURL_DISABLE_FTP)
unset(CURL_DISABLE_GOPHER)
unset(CURL_DISABLE_IMAP)
unset(CURL_DISABLE_LDAP)
unset(CURL_DISABLE_LDAPS)
unset(CURL_DISABLE_MQTT)
unset(CURL_DISABLE_POP3)
unset(CURL_DISABLE_RTSP)
unset(CURL_DISABLE_SMB)
unset(CURL_DISABLE_SMTP)
unset(CURL_DISABLE_TELNET)
unset(CURL_DISABLE_TFTP)
unset(CURL_DISABLE_DOH)
unset(CURL_DISABLE_HSTS)
unset(CURL_DISABLE_IPFS)
unset(CURL_DISABLE_WEBSOCKETS)
unset(CURL_DISABLE_PROXY)
unset(CURL_DISABLE_QUIC)
unset(CURL_DISABLE_FORM_API)
unset(CURL_DISABLE_MIME)
unset(CURL_DISABLE_BINDLOCAL)
unset(CURL_DISABLE_GETOPTIONS)
unset(CURL_DISABLE_HEADERS_API)
unset(CURL_DISABLE_LIBCURL_OPTION)
unset(CURL_DISABLE_NETRC)
unset(CURL_DISABLE_PARSEDATE)
unset(CURL_DISABLE_SHA512_256)
unset(CURL_DISABLE_SHUFFLE_DNS)
unset(CURL_DISABLE_SOCKETPAIR)
unset(CURL_DISABLE_SRP)
unset(CURL_DISABLE_VERBOSE_STRINGS)
unset(USE_NGHTTP2)
unset(CURL_ZSTD)
unset(CURL_ENABLE_EXPORT_TARGET)
unset(CURL_DISABLE_INSTALL)
unset(CURL_USE_SECTRANSP)
unset(CURL_DEFAULT_SSL_BACKEND)
unset(USE_APPLE_IDN)
unset(CURL_USE_SCHANNEL)
unset(CURL_USE_GNUTLS)

set(CURL_FOUND true CACHE BOOL "" FORCE)
set(CURL_LIBRARIES libcurl_static CACHE FILEPATH "" FORCE)
set(CURL_INCLUDE_DIR ${curl_SOURCE_DIR}/include CACHE PATH "" FORCE)
set(CURL_INCLUDE_DIRS ${curl_SOURCE_DIR}/include CACHE PATH "" FORCE)

# Adding headers explicity so they are displayed in Qt Creator
set(HEADERS config.h imagewriter.h networkaccessmanagerfactory.h nan.h drivelistitem.h drivelistmodel.h drivelistmodelpollthread.h driveformatthread.h powersaveblocker.h cli.h
    devicewrapper.h devicewrapperblockcacheentry.h devicewrapperpartition.h devicewrapperstructs.h devicewrapperfatpartition.h wlancredentials.h
    downloadthread.h downloadextractthread.h localfileextractthread.h downloadstatstelemetry.h dependencies/mountutils/src/mountutils.hpp dependencies/sha256crypt/sha256crypt.h
    hwlistmodel.h
    oslistmodel.h
)

# Add dependencies
if (APPLE)
    set_source_files_properties("icons/rpi-imager.icns" PROPERTIES MACOSX_PACKAGE_LOCATION "Resources")
    set(PLATFORM_SOURCES
        mac/acceleratedcryptographichash_commoncrypto.cpp
        mac/macfile.cpp
        mac/macfile.h
        dependencies/mountutils/src/darwin/functions.cpp
        mac/macwlancredentials.h
        mac/macwlancredentials.cpp
        dependencies/drivelist/src/darwin/list.mm
        dependencies/drivelist/src/darwin/REDiskList.m
    )
    set(DEPENDENCIES  icons/rpi-imager.icns)
    enable_language(OBJC C)
elseif (UNIX)
    find_package(GnuTLS REQUIRED)
    set(PLATFORM_SOURCES
        dependencies/mountutils/src/linux/functions.cpp
        linux/linuxdrivelist.cpp
        linux/networkmanagerapi.h
        linux/networkmanagerapi.cpp
        linux/stpanalyzer.h
        linux/stpanalyzer.cpp
        linux/acceleratedcryptographichash_gnutls.cpp
    )
    set(EXTRALIBS ${EXTRALIBS} GnuTLS::GnuTLS idn2 nettle)
    set(DEPENDENCIES "")
    add_definitions(-DHAVE_GNUTLS)
elseif (WIN32)
    add_custom_command(
        OUTPUT wlanapi_delayed.lib
        COMMAND ${CMAKE_DLLTOOL} --input-def "${CMAKE_CURRENT_SOURCE_DIR}/windows/wlanapi.def"
                --output-delaylib "wlanapi_delayed.lib" --dllname "wlanapi.dll"
        DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/windows/wlanapi.def
        VERBATIM
    )
    set(PLATFORM_SOURCES
        windows/acceleratedcryptographichash_cng.cpp
        dependencies/mountutils/src/windows/functions.cpp
        dependencies/drivelist/src/windows/list.cpp
        windows/winfile.cpp
        windows/winfile.h
        windows/winwlancredentials.h
        windows/winwlancredentials.cpp
    )
    set(DEPENDENCIES
        windows/rpi-imager.rc
        wlanapi_delayed.lib
    )
    set(EXTRALIBS setupapi ${CMAKE_CURRENT_BINARY_DIR}/wlanapi_delayed.lib Bcrypt.dll)

endif()

include_directories(BEFORE .)

# Test if we need libatomic
include(CheckCXXSourceCompiles)
check_cxx_source_compiles("
    #include <atomic>
    #include <stdint.h>
    int main() {
        std::atomic<int64_t> x;
        x = 1;
        return (int) x;
    }"
    atomicbuiltin)

if (NOT atomicbuiltin)
        find_library(ATOMIC_LIBRARY NAMES atomic libatomic.so.1)
        if (NOT ATOMIC_LIBRARY)
                message( FATAL_ERROR "Missing libatomic while architecture does need it" )
        endif()
endif()

include(TestBigEndian)
test_big_endian(IS_BIG_ENDIAN)
if( IS_BIG_ENDIAN )
    message( FATAL_ERROR "We currently only support 'little endian' CPU architectures" )
endif( IS_BIG_ENDIAN )

set(SOURCES ${PLATFORM_SOURCES} "main.cpp" "networkaccessmanagerfactory.cpp"
    "drivelistitem.cpp" "drivelistmodel.cpp" "drivelistmodelpollthread.cpp" "downloadthread.cpp" "downloadextractthread.cpp"
    "devicewrapper.cpp" "devicewrapperblockcacheentry.cpp" "devicewrapperpartition.cpp" "devicewrapperfatpartition.cpp"
    "driveformatthread.cpp" "localfileextractthread.cpp" "powersaveblocker.cpp" "downloadstatstelemetry.cpp" "qml.qrc" "dependencies/sha256crypt/sha256crypt.c" "cli.cpp" "disk_formatter.cpp")

find_package(Qt6 6.7 QUIET COMPONENTS Core Quick LinguistTools Svg OPTIONAL_COMPONENTS Widgets DBus WinExtras)
if (Qt6_FOUND)
    set(QT Qt6)
    if (APPLE)
        set(CMAKE_OSX_DEPLOYMENT_TARGET "11" CACHE STRING "" FORCE)
    endif()
else()
    message(FATAL_ERROR "Missing suitable Qt library (must be at least version 6.7)" )
endif()

if (${QT}Widgets_FOUND)
    set(EXTRALIBS ${EXTRALIBS} ${QT}::Widgets)
endif()
if(${QT}DBus_FOUND AND UNIX AND NOT APPLE)
    set(DEPENDENCIES ${DEPENDENCIES} linux/udisks2api.cpp linux/udisks2api.h)
    set(EXTRALIBS ${EXTRALIBS} ${QT}::DBus)
    message("udisks2 support enabled")
endif()
if (NOT ${QT}Widgets_FOUND AND UNIX AND NOT APPLE)
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(LIBDRM REQUIRED libdrm)
endif()
if(${QT}WinExtras_FOUND)
    set(EXTRALIBS ${EXTRALIBS} ${QT}::WinExtras)
endif()

set(TRANSLATIONS i18n/rpi-imager_en.ts i18n/rpi-imager_nl.ts i18n/rpi-imager_zh.ts i18n/rpi-imager_tr.ts
    i18n/rpi-imager_fr.ts i18n/rpi-imager_de.ts i18n/rpi-imager_sk.ts i18n/rpi-imager_it.ts
    i18n/rpi-imager_ca.ts i18n/rpi-imager_sl.ts i18n/rpi-imager_ko.ts i18n/rpi-imager_ja.ts
    i18n/rpi-imager_ru.ts i18n/rpi-imager_es.ts i18n/rpi-imager_uk.ts i18n/rpi-imager_zh-TW.ts
    i18n/rpi-imager_pl.ts i18n/rpi-imager_he.ts i18n/rpi-imager_pt.ts i18n/rpi-imager_ka.ts)
#qt6_create_translation(QM_FILES ${CMAKE_SOURCE_DIR} ${TRANSLATIONS})
qt_add_translation(QM_FILES  ${TRANSLATIONS})
configure_file(i18n/translations.qrc "${CMAKE_CURRENT_BINARY_DIR}" COPYONLY)
set(SOURCES ${SOURCES} ${CMAKE_CURRENT_BINARY_DIR}/translations.qrc ${QM_FILES})

# Create an rpi-imager_lupdate target
qt_add_lupdate(TS_FILES ${TRANSLATIONS} SOURCE_TARGETS ${PROJECT_NAME} OPTIONS -no-obsolete -locations none)

if (WIN32)
    # Adding WIN32 prevents a console window being opened on Windows
    add_executable(${PROJECT_NAME} WIN32 ${SOURCES} ${HEADERS} ${DEPENDENCIES})
else()
    add_executable(${PROJECT_NAME} ${SOURCES} ${HEADERS} ${DEPENDENCIES})
endif()

set_property(TARGET ${PROJECT_NAME} PROPERTY AUTOMOC ON)
set_property(TARGET ${PROJECT_NAME} PROPERTY AUTORCC ON)
set_property(TARGET ${PROJECT_NAME} PROPERTY AUTOUIC ON)

if(ENABLE_TELEMETRY)
    add_definitions(-DTELEMETRY_ENABLED_DEFAULT=true)
else()
    add_definitions(-DTELEMETRY_ENABLED_DEFAULT=false)
endif()

if(ENABLE_CHECK_VERSION)
    add_definitions(-DCHECK_VERSION_DEFAULT=true)
else()
    add_definitions(-DCHECK_VERSION_DEFAULT=false)
endif()

qt_policy(SET QTP0001 NEW)

if (QT_KNOWN_POLICY_QTP0004)
    qt_policy(SET QTP0004 NEW)
endif()

set(QT_QML_GENERATE_QMLLS_INI ON)

set(IMAGER_QML_FILES
    main.qml
    MsgPopup.qml
    OptionsGeneralTab.qml
    OptionsMiscTab.qml
    OptionsPopup.qml
    OptionsServicesTab.qml
    OptionsTabBase.qml
    Style.qml
    UseSavedSettingsPopup.qml
    qmlcomponents/ImButton.qml
    qmlcomponents/ImButtonRed.qml
    qmlcomponents/ImCheckBox.qml
    qmlcomponents/ImCloseButton.qml
    qmlcomponents/ImPopup.qml
    qmlcomponents/ImRadioButton.qml
    MainPopupBase.qml
    HwPopup.qml
    OSPopup.qml
    DstPopup.qml
    MainPopupListViewBase.qml
)

set_source_files_properties(Style.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

# C++ types exposed to QML
set(IMAGER_QML_CPP_TYPES
    imagewriter.cpp
    hwlistmodel.cpp
    oslistmodel.cpp
)

qt_add_qml_module(${PROJECT_NAME}
    URI RpiImager
    VERSION 1.0
    QML_FILES ${IMAGER_QML_FILES}
    SOURCES ${IMAGER_QML_CPP_TYPES}
    NO_CACHEGEN
    OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/RpiImager
    DEPENDENCIES QtQuick
    NO_PLUGIN
)

# Because dependencies are typically not available by default on Windows, build bundled code
if (WIN32)
    # Target Windows 10, in line with Qt requirements
    add_definitions(-DWINVER=0x0A00 -D_WIN32_WINNT=0x0A00 -DNTDDI_VERION=0x0A000000)

    # Bundled fat32format
    add_subdirectory(dependencies/fat32format)
    add_dependencies(${PROJECT_NAME} fat32format)

    # Strip debug symbols
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_STRIP} "${CMAKE_BINARY_DIR}/${PROJECT_NAME}.exe")

    if (IMAGER_SIGNED_APP)
    # Borrowed from the 'mstdlib' project: Code signing
    # First, determine our build architecture
    if (CMAKE_SIZEOF_VOID_P EQUAL 8)
            set(arch x64)
    else ()
            set(arch x86)
    endif ()
    #
    #  Now find signtool
    if (NOT SIGNTOOL)
            # Try to list all Windows 10 SDK versions, if any.
            set(win10_kit_versions)
            set(regkey "HKEY_LOCAL_MACHINE\\SOFTWARE\\WOW6432Node\\Microsoft\\Windows Kits\\Installed Roots")
            set(regval "KitsRoot10")
            # Note: must be a cache operation in order to read from the registry.
            get_filename_component(w10_kits_path "[${regkey};${regval}]" ABSOLUTE CACHE)
            if (w10_kits_path)
                message(WARNING "Found Windows 10 kits path: ${w10_kits_path}")
                    file(GLOB w10_kit_versions "${w10_kits_path}/bin/10.*")
                    # Reverse list, so newer (higher-numbered) versions appear first.
                    list(REVERSE w10_kit_versions)
            endif ()
            unset(w10_kits_path CACHE)
            if (w10_kit_versions)
                    find_program(SIGNTOOL
                                    NAMES           signtool
                                    PATHS           ${w10_kit_versions}
                                    PATH_SUFFIXES   ${arch}
                                                    bin/${arch}
                                                    bin
                                    NO_DEFAULT_PATH
                    )
            endif ()
    endif ()

    if (NOT SIGNTOOL)
        message(FATAL_ERROR "Unable to locate signtool.exe used for code signing")
    endif()
    add_definitions(-DSIGNTOOL="${SIGNTOOL}")

    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND "${SIGNTOOL}" sign /tr http://timestamp.digicert.com /td sha256 /fd sha256 /a "${CMAKE_BINARY_DIR}/${PROJECT_NAME}.exe")

    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND "${SIGNTOOL}" sign /tr http://timestamp.digicert.com /td sha256 /fd sha256 /a "${CMAKE_BINARY_DIR}/dependencies/fat32format/fat32format.exe")

    endif(IMAGER_SIGNED_APP)

    # Windeploy
    find_program(WINDEPLOYQT "windeployqt.exe" PATHS "${Qt6_ROOT}/bin")
    if (NOT WINDEPLOYQT)
        message(FATAL_ERROR "Unable to locate windeployqt.exe")
    endif()

    file(MAKE_DIRECTORY "${CMAKE_BINARY_DIR}/deploy")

    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy
            "${CMAKE_BINARY_DIR}/${PROJECT_NAME}.exe" "${CMAKE_BINARY_DIR}/dependencies/fat32format/fat32format.exe"
            "${CMAKE_SOURCE_DIR}/../license.txt" "${CMAKE_SOURCE_DIR}/windows/rpi-imager-cli.cmd"
            "${CMAKE_BINARY_DIR}/deploy")

    # Inno Setup configuration
    option(ENABLE_INNO_INSTALLER "Build Inno Setup installer instead of NSIS" OFF)
    
    if(ENABLE_INNO_INSTALLER)
        # Create installer output directory
        file(MAKE_DIRECTORY "${CMAKE_BINARY_DIR}/installer")
        
        # Configure the Inno Setup script
        configure_file(
            "${CMAKE_CURRENT_SOURCE_DIR}/windows/rpi-imager.iss.in"
            "${CMAKE_CURRENT_BINARY_DIR}/rpi-imager.iss"
            @ONLY)
            
        # Find Inno Setup compiler
        find_program(INNO_COMPILER NAMES iscc ISCC "iscc.exe" PATHS
            "C:/Program Files (x86)/Inno Setup 6"
            "C:/Program Files/Inno Setup 6"
            DOC "Path to Inno Setup compiler")
            
        if(INNO_COMPILER)
            if(IMAGER_SIGNED_APP)
                add_custom_target(inno_installer
                    COMMAND "${INNO_COMPILER}" "${CMAKE_CURRENT_BINARY_DIR}/rpi-imager.iss" "/DSIGNING_ENABLED" "/Ssign=${SIGNTOOL} sign /tr http://timestamp.digicert.com /td sha256 /fd sha256 /a $p"
                    DEPENDS ${PROJECT_NAME}
                    COMMENT "Building Inno Setup installer"
                    VERBATIM)
            else()
                add_custom_target(inno_installer
                    COMMAND "${INNO_COMPILER}" "${CMAKE_CURRENT_BINARY_DIR}/rpi-imager.iss"
                    DEPENDS ${PROJECT_NAME}
                    COMMENT "Building Inno Setup installer"
                    VERBATIM)
            endif()
            message(STATUS "Added 'inno_installer' target to build the Inno Setup installer")
        else()
            message(WARNING "Inno Setup compiler not found. Install Inno Setup from https://jrsoftware.org/isinfo.php")
        endif()
    else()
        # NSIS Installer (legacy option)
        configure_file(
            "${CMAKE_CURRENT_SOURCE_DIR}/windows/rpi-imager.nsi.in"
            "${CMAKE_CURRENT_BINARY_DIR}/rpi-imager.nsi"
            @ONLY)
    endif()

    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy
            "${MINGW64_ROOT}/bin/libgcc_s_seh-1.dll"
            "${MINGW64_ROOT}/bin/libstdc++-6.dll"
            "${MINGW64_ROOT}/bin/libwinpthread-1.dll"
            "${CMAKE_BINARY_DIR}/deploy")

    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND "${WINDEPLOYQT}" --no-translations --qmldir "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_BINARY_DIR}/deploy/rpi-imager.exe")

    # Remove excess files
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E remove
            "${CMAKE_BINARY_DIR}/deploy/imageformats/qtiff.dll"
            "${CMAKE_BINARY_DIR}/deploy/imageformats/qwebp.dll"
            "${CMAKE_BINARY_DIR}/deploy/imageformats/qgif.dll")

elseif(APPLE)
    find_library(Cocoa Cocoa)
    find_library(CoreFoundation CoreFoundation)
    find_library(DiskArbitration DiskArbitration)
    find_library(Security Security)
    find_library(IOKit IOKit)
    find_library(SystemConfiguration SystemConfiguration)
    set(EXTRALIBS ${EXTRALIBS} ${CoreFoundation} ${DiskArbitration} ${Security} ${Cocoa} ${IOKit} ${SystemConfiguration} iconv)
    
    # Set application name with proper spacing
    set(APP_NAME "Raspberry Pi Imager")
    
    # Set all required bundle properties
    set(MACOSX_BUNDLE_BUNDLE_NAME "${APP_NAME}")
    set(MACOSX_BUNDLE_EXECUTABLE_NAME "${PROJECT_NAME}")
    set(MACOSX_BUNDLE_GUI_IDENTIFIER "org.raspberrypi.imagingutility")
    set(MACOSX_BUNDLE_BUNDLE_VERSION "${IMAGER_VERSION_STR}")
    set(MACOSX_BUNDLE_SHORT_VERSION_STRING "${IMAGER_VERSION_STR}")
    set(MACOSX_BUNDLE_LONG_VERSION_STRING "${IMAGER_VERSION_STR}")
    set(MACOSX_BUNDLE_ICON_FILE "rpi-imager.icns")
    string(TIMESTAMP CURRENT_YEAR "%Y")
    set(MACOSX_BUNDLE_COPYRIGHT "Copyright © 2020-${CURRENT_YEAR} Raspberry Pi Ltd")
    
    # Simple macos bundle with minimal Info.plist configuration
    set_target_properties(${PROJECT_NAME} PROPERTIES 
        MACOSX_BUNDLE YES)

    # Define app bundle location
    set(APP_BUNDLE_PATH "${CMAKE_BINARY_DIR}/${PROJECT_NAME}.app")
    set(DMG_PATH "${CMAKE_BINARY_DIR}/${APP_NAME}.dmg")
    set(FINAL_DMG_PATH "${CMAKE_BINARY_DIR}/${APP_NAME}-${IMAGER_VERSION_STR}.dmg")

    # Manually configure the Info.plist file from a template
    configure_file(
        "${CMAKE_CURRENT_SOURCE_DIR}/mac/Info.plist.in" 
        "${CMAKE_BINARY_DIR}/Info.plist"
        @ONLY
    )

    # Clean only specific files/directories but not the entire app bundle
    # This ensures directory structure for lipo doesn't get removed
    add_custom_command(TARGET ${PROJECT_NAME} PRE_BUILD
        COMMAND ${CMAKE_COMMAND} -E echo "Cleaning up previous macOS DMG files..."
        COMMAND ${CMAKE_COMMAND} -E remove -f "${DMG_PATH}"
        COMMAND ${CMAKE_COMMAND} -E remove -f "${FINAL_DMG_PATH}"
        COMMENT "Cleaning previous macOS build artifacts"
    )

    # Ensure required directories exist before building
    add_custom_command(TARGET ${PROJECT_NAME} PRE_LINK
        COMMAND ${CMAKE_COMMAND} -E echo "Ensuring app bundle directories exist..."
        COMMAND ${CMAKE_COMMAND} -E make_directory "${APP_BUNDLE_PATH}"
        COMMAND ${CMAKE_COMMAND} -E make_directory "${APP_BUNDLE_PATH}/Contents"
        COMMAND ${CMAKE_COMMAND} -E make_directory "${APP_BUNDLE_PATH}/Contents/MacOS"
        COMMAND ${CMAKE_COMMAND} -E make_directory "${APP_BUNDLE_PATH}/Contents/Resources"
        COMMENT "Creating app bundle directory structure"
    )

    # Add a post-build command to copy the Info.plist file to the app bundle
    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_BINARY_DIR}/Info.plist" "${APP_BUNDLE_PATH}/Contents/Info.plist"
        COMMENT "Installing custom Info.plist"
    )

    find_program(MACDEPLOYQT "macdeployqt" PATHS "${Qt6_ROOT}/bin")
    if (NOT MACDEPLOYQT)
        message(FATAL_ERROR "Unable to locate macdeployqt")
    endif()

    if(IMAGER_SIGNED_APP)
        if(IMAGER_SIGNING_IDENTITY)
            # Using a simpler script for macOS post-processing
            configure_file(
                "${CMAKE_CURRENT_SOURCE_DIR}/mac/macos_post_build.sh.in"
                "${CMAKE_BINARY_DIR}/macos_post_build.sh"
                @ONLY
            )
            
            # Make the script executable
            execute_process(
                COMMAND chmod +x "${CMAKE_BINARY_DIR}/macos_post_build.sh"
            )
            
            # Execute the post-build script
            add_custom_command(TARGET ${PROJECT_NAME}
                POST_BUILD
                COMMAND "${CMAKE_BINARY_DIR}/macos_post_build.sh"
                COMMENT "Running macOS post-build operations (deploy, sign, create DMG)"
            )
        else()
            message(FATAL_ERROR "Signing requested, but no signing identity provided")
        endif(IMAGER_SIGNING_IDENTITY)
    else()
        # Unsigned application - simpler approach
        add_custom_command(TARGET ${PROJECT_NAME}
            POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E echo "Deploying Qt dependencies..."
            COMMAND "${MACDEPLOYQT}" "${APP_BUNDLE_PATH}" -qmldir="${CMAKE_CURRENT_SOURCE_DIR}" -always-overwrite
            COMMENT "Deploying Qt dependencies"
        )
        
        # Create DMG
        add_custom_command(TARGET ${PROJECT_NAME}
            POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E echo "Creating DMG..."
            COMMAND hdiutil create -volname "${APP_NAME}" -srcfolder "${APP_BUNDLE_PATH}" -ov -format UDBZ "${DMG_PATH}"
            COMMENT "Creating DMG"
        )
        
        # Create the versioned DMG
        add_custom_command(TARGET ${PROJECT_NAME}
            POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E echo "Creating versioned DMG at ${FINAL_DMG_PATH}..."
            COMMAND ${CMAKE_COMMAND} -E copy "${DMG_PATH}" "${FINAL_DMG_PATH}"
            COMMENT "Creating versioned DMG"
        )
    endif(IMAGER_SIGNED_APP)

else()
    # UNIX, Linux systems
    if (NOT CMAKE_CROSSCOMPILING)
        find_program(LSBLK "lsblk")
        if (NOT LSBLK)
            message(FATAL_ERROR "Unable to locate lsblk (used for disk enumeration)")
        endif()

        execute_process(COMMAND "${LSBLK}" "--json" OUTPUT_QUIET RESULT_VARIABLE ret)
        if (ret EQUAL "1")
            message(FATAL_ERROR "util-linux package too old. lsblk does not support --json (used for disk enumeration)")
        endif()
    endif()

    install(TARGETS ${PROJECT_NAME} DESTINATION bin)
    install(FILES "${CMAKE_CURRENT_LIST_DIR}/../debian/rpi-imager.png" DESTINATION share/icons/hicolor/128x128/apps)
    install(FILES "${CMAKE_CURRENT_LIST_DIR}/../debian/org.raspberrypi.rpi-imager.desktop" DESTINATION share/applications)
    install(FILES "${CMAKE_CURRENT_LIST_DIR}/../debian/org.raspberrypi.rpi-imager.metainfo.xml" DESTINATION share/metainfo)
endif()

add_dependencies(${PROJECT_NAME} ZLIB::ZLIB)
include_directories(${CURL_INCLUDE_DIR} ${LibArchive_INCLUDE_DIR} ${LIBLZMA_INCLUDE_DIRS} ${LIBDRM_INCLUDE_DIRS} ${ZLIB_INCLUDE_DIRS} ${ZSTD_INCLUDE_DIR})
target_link_libraries(${PROJECT_NAME} PRIVATE ${QT}::Core ${QT}::Quick ${QT}::Svg ${CURL_LIBRARIES} ${LibArchive_LIBRARIES} ${ZSTD_LIBRARIES} ${LIBLZMA_LIBRARIES} ZLIB::ZLIB ${LIBDRM_LIBRARIES} ${ATOMIC_LIBRARY} ${EXTRALIBS})
