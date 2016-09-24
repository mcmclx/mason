#!/usr/bin/env bash

MASON_NAME=luajit
MASON_VERSION=8ada57e
MASON_LIB_FILE=lib/libluajit-5.1.a

. ${MASON_DIR}/mason.sh

function mason_load_source {
    mason_download \
        https://github.com/LuaJIT/LuaJIT/tarball/8ada57e \
        ed6ec0833fe65ab444f3f8167ee426b374a4b11f

    mason_extract_tar_gz

    export MASON_BUILD_PATH=${MASON_ROOT}/.build/LuaJIT-LuaJIT-${MASON_VERSION}
}

function mason_compile {
    mason_step "Loading patch ${MASON_DIR}/scripts/${MASON_NAME}/${MASON_VERSION}/patch.diff"
    patch -N -p1 < ${MASON_DIR}/scripts/${MASON_NAME}/${MASON_VERSION}/patch.diff
    make DEFAULT_CC=$CC CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" PREFIX=${MASON_PREFIX} install
    # put includes at normal place
    mv ${MASON_PREFIX}/include/luajit-2.0/*.* ${MASON_PREFIX}/include/
    rm -rf ${MASON_PREFIX}/include/luajit-2.0
    # clear out shared libs since we only want to provide static lib
    rm -f ${MASON_PREFIX}/lib/*so*
    rm -f ${MASON_PREFIX}/lib/*dylib*
    cd ${MASON_PREFIX}/lib
    ln -s "libluajit-5.1.a" "liblua.a"

}

function mason_cflags {
    echo "-I${MASON_PREFIX}/include"
}

function mason_ldflags {
    echo "ld ${MASON_PREFIX}/lib/libluajit-5.1.a"
}

function mason_clean {
    make clean
}

mason_run "$@"
