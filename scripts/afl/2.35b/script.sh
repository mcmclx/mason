#!/usr/bin/env bash

MASON_NAME=afl
MASON_VERSION=2.35b
MASON_LIB_FILE=bin/afl-fuzz

. ${MASON_DIR}/mason.sh

function mason_load_source {
    mason_download \
        http://lcamtuf.coredump.cx/afl/releases/afl-2.35b.tgz \
        df3ca4a3dbb939587caaea711346e35e8dac1c57

    mason_extract_tar_gz

    export MASON_BUILD_PATH=${MASON_ROOT}/.build/${MASON_NAME}-${MASON_VERSION}
}

function mason_prepare_compile {
    ${MASON_DIR}/mason install clang 3.8.0
    MASON_CLANG=$(${MASON_DIR}/mason prefix clang 3.8.0)
}

function mason_compile {
    export PATH=${MASON_CLANG}/bin:$PATH
    export CXX="${MASON_CLANG}/bin/clang++" 
    export CC="${MASON_CLANG}/bin/clang" 

    make -j${MASON_CONCURRENCY}
    cd llvm_mode
    make -j${MASON_CONCURRENCY}
    cd ..
    PREFIX=${MASON_PREFIX} make install
}

function mason_cflags {
    :
}

function mason_ldflags {
    :
}

function mason_static_libs {
    :
}

mason_run "$@"
