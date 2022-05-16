#!/usr/bin/env bash

set -Eeuo pipefail

declare SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

export PROJECT_INFO_NAME=$(cat project_info | grep "^Name:" | sed -E "s/^.*:[[:blank:]]*//g")
export PROJECT_INFO_VERSION=$(cat project_info | grep "^Version:" | sed -E "s/^.*:[[:blank:]]*//g")
export PROJECT_INFO_DESCRIPTION=$(cat project_info | grep "^Description:" | sed -E "s/^.*:[[:blank:]]*//g")

declare CMAKE="cmake"
declare CMAKE_GENERATOR="Unix Makefiles"

declare CMAKE_C_COMPILER="${CC:-gcc}"
declare CMAKE_CXX_COMPILER="${CXX:-g++}"

declare BUILD_TYPE="Release"
declare BUILD_DIR="build"

declare ASAN_OPTIONS="${ASAN_OPTIONS:-allow_user_poisoning=1,use_sigaltstack=0,halt_on_error=1,detect_stack_use_after_return=1,alloc_dealloc_mismatch=0}"
declare CMAKE_OPTIONS=

if [ -x "$(which ninja)" ]; then
  CMAKE_GENERATOR="Ninja"
fi

while getopts "r:o:b:c:x:tupad" arg; do
  unset noargs
  case "${arg}" in
  r)
    BUILD_TYPE="${OPTARG}"
    ;;

  o)
    BUILD_DIR="${OPTARG}"
    ;;

  b)
    CMAKE_GENERATOR="${OPTARG}"
    ;;

  c)
    CMAKE_C_COMPILE="${OPTARG}"
    ;;

  x)
    CMAKE_CXX_COMPILER="${OPTARG}"
    ;;

  t)
    CMAKE_OPTIONS="-DCMAKE_COMPILE_TEST=1 ${CMAKE_OPTIONS}"
    ;;

  u)
    CMAKE_OPTIONS="-DCMAKE_COMPILE_UNIT=1 ${CMAKE_OPTIONS}"
    ;;

  p)
    CMAKE_OPTIONS="-DCMAKE_COMPILE_PERF=1 ${CMAKE_OPTIONS}"
    ;;

  a)
    CMAKE_OPTIONS="-DADDRESS_SANITIZER=1 ${CMAKE_OPTIONS}"

    export ASAN_OPTIONS
    ;;

  d)
    CMAKE_OPTIONS="-DUSE_CLANG_TIDY=1 ${CMAKE_OPTIONS}"
    ;;

  *)
    exit 1
    ;;
  esac
done

shift $(expr ${OPTIND} - 1)

mkdir -p "${BUILD_DIR}"

"${CMAKE}" -B "${BUILD_DIR}" \
           -G "${CMAKE_GENERATOR}" \
           -DPROJECT_INFO_NAME="${PROJECT_INFO_NAME}" \
           -DPROJECT_INFO_VERSION="${PROJECT_INFO_VERSION}" \
           -DPROJECT_INFO_DESCRIPTION="${PROJECT_INFO_DESCRIPTION}" \
           -DCMAKE_BUILD_TYPE="${BUILD_TYPE}" \
           -DCMAKE_C_COMPILER="${CMAKE_C_COMPILER}" \
           -DCMAKE_CXX_COMPILER="${CMAKE_CXX_COMPILER}" \
           ${CMAKE_OPTIONS} \
           "${SCRIPT_DIR}"

"${CMAKE}" --build "${BUILD_DIR}" -j $(nproc)
