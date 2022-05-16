#!/usr/bin/env bash

set -Eeuo pipefail

declare BUILD_TYPE="${1:-Debug}"
declare BUILD_DIR="build.tests"
declare BUILD_ARGS="-u"

# source is used to import environment variables exported in build.sh
source ./build.sh -r "${BUILD_TYPE}" -o "${BUILD_DIR}" "${BUILD_ARGS}"

"./${BUILD_DIR}/${PROJECT_INFO_NAME}-tests-unit"
