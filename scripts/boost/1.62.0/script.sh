#!/usr/bin/env bash

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"

# inherit from boost base (used for all boost library packages)
source ${HERE}/base.sh

# this package is the one that is header-only
MASON_NAME=boost
MASON_HEADER_ONLY=true
unset MASON_LIB_FILE

# setup mason env
. ${MASON_DIR}/mason.sh

# source common build functions
source ${HERE}/common.sh

# override default unpacking to just unpack headers
function mason_load_source {
    mason_download \
        http://downloads.sourceforge.net/project/boost/boost/${MASON_VERSION}.beta.2/boost_${BOOST_VERSION}_b2.tar.bz2 \
        ${BOOST_SHASUM}

    mason_extract_tar_bz2 boost_${BOOST_VERSION}/boost

    MASON_BUILD_PATH=${MASON_ROOT}/.build/boost_${BOOST_VERSION}
}

# override default "compile" target for just the header install
function mason_compile {
    mkdir -p ${MASON_PREFIX}/include
    cp -r ${MASON_ROOT}/.build/boost_${BOOST_VERSION}/boost ${MASON_PREFIX}/include
}

mason_run "$@"
