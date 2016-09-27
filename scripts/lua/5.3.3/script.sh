#!/usr/bin/env bash

MASON_NAME=lua
MASON_VERSION=5.3.3
MASON_LIB_FILE=lib/liblua.a

. ${MASON_DIR}/mason.sh

function mason_load_source {
    mason_download \
        http://www.lua.org/ftp/lua-${MASON_VERSION}.tar.gz \
        a7c45a7ffd08401a61341c59338e58bdea239c6e

    mason_extract_tar_gz

    export MASON_BUILD_PATH=${MASON_ROOT}/.build/${MASON_NAME}-${MASON_VERSION}
}

function mason_compile {
    make generic CC=$CC INSTALL_TOP=${MASON_PREFIX} install
}

function mason_cflags {
    echo "-I${MASON_PREFIX}/include"
}

function mason_ldflags {
    echo "-L${MASON_PREFIX}/lib -llua"
}

function mason_clean {
    make clean
}

mason_run "$@"
