#!/usr/bin/env bash

MASON_NAME=stxxl
MASON_VERSION=1.3.1
MASON_LIB_FILE=lib/libstxxl.a

. ${MASON_DIR}/mason.sh

# https://github.com/stxxl/stxxl/issues/31
function mason_load_source {
    mason_download \
        https://github.com/stxxl/stxxl/releases/download/${MASON_VERSION}/stxxl-${MASON_VERSION}.tar.gz \
        2e9ee23760e7c23caef414c05f4ee8b7d4243fb0

    mason_extract_tar_gz

    export MASON_BUILD_PATH=${MASON_ROOT}/.build/${MASON_NAME}-${MASON_VERSION}
}

function mason_compile {
    mason_step "Loading patch '${MASON_DIR}/scripts/${MASON_NAME}/${MASON_VERSION}/patch.diff'..."
    patch -N -p1 < ${MASON_DIR}/scripts/${MASON_NAME}/${MASON_VERSION}/patch.diff
    GET_FILE_ID="true" COMPILER_GCC="$CXX -D__GXX_EXPERIMENTAL_CXX0X__ ${CXXFLAGS} ${LDFLAGS}" make config_gnu -j${MASON_CONCURRENCY} VERBOSE=1
    GET_FILE_ID="true" COMPILER_GCC="$CXX -D__GXX_EXPERIMENTAL_CXX0X__ ${CXXFLAGS} ${LDFLAGS}" make library_g++ -j${MASON_CONCURRENCY} VERBOSE=1
    mkdir -p ${MASON_PREFIX}/include/
    cp -r include/* ${MASON_PREFIX}/include/
    mkdir -p ${MASON_PREFIX}/lib/
    cp -r lib/libstxxl.a ${MASON_PREFIX}/lib/
}

function mason_cflags {
    echo "-I${MASON_PREFIX}/include"
}

function mason_ldflags {
    echo "-L${MASON_PREFIX}/lib -lstxxl"
}

function mason_clean {
    make clean
}

mason_run "$@"
