#!/usr/bin/env bash

MASON_NAME=zlib
MASON_VERSION=system
MASON_SYSTEM_PACKAGE=true

. ${MASON_DIR:-~/.mason}/mason.sh


MASON_CFLAGS="-I${MASON_PREFIX}/include"
MASON_LDFLAGS="-L${MASON_PREFIX}/lib"

if [[ ${MASON_PLATFORM} = 'osx' || ${MASON_PLATFORM} = 'ios' ]]; then
    ZLIB_PREFIX="${MASON_SDK_PATH}/usr"
    ZLIB_LIBRARY="libz.dylib"
    MASON_LDFLAGS="${MASON_LDFLAGS} -lz"
elif [[ ${MASON_PLATFORM} = 'android' ]]; then
    ZLIB_PREFIX="${MASON_SDK_PATH}/usr"
    ZLIB_LIBRARY="libz.so"
    MASON_LDFLAGS="${MASON_LDFLAGS} -lz"
elif [[ -d /usr/include/zlib.h ]] && [[ -d /usr/include/zconf.h ]]; then
    ZLIB_PREFIX="/usr"
    ZLIB_LIBRARY="libz.so"
    MASON_LDFLAGS="${MASON_LDFLAGS} -lz"
else
    ZLIB_PREFIX="`pkg-config zlib --variable=prefix`"
    ZLIB_LIBRARY="libz.so"
    MASON_CFLAGS="${MASON_CFLAGS} `pkg-config zlib --cflags-only-other`"
    MASON_LDFLAGS="${MASON_LDFLAGS} `pkg-config zlib --libs-only-other --libs-only-l`"
fi

if [ ! -f "${ZLIB_PREFIX}/include/zlib.h" ]; then
    mason_error "Can't find header file ${ZLIB_PREFIX}/include/zlib.h"
    exit 1
fi
if [ ! -f "${ZLIB_PREFIX}/lib/${ZLIB_LIBRARY}" ]; then
    mason_error "Can't find library file ${ZLIB_PREFIX}/lib/${ZLIB_LIBRARY}"
    exit 1
fi

function mason_system_version {
    mkdir -p "${MASON_PREFIX}"
    cd "${MASON_PREFIX}"
    if [ ! -f version ]; then
        echo "#include <zlib.h>
#include <stdio.h>
int main() {
    printf(\"%s\", ZLIB_VERSION);
    return 0;
}
" > version.c && cc version.c $(mason_cflags) -o version
    fi
    ./version
}

function mason_build {
    mkdir -p ${MASON_PREFIX}/{include,lib}
    ln -sf ${ZLIB_PREFIX}/include/{zlib,zconf}.h ${MASON_PREFIX}/include/
    ln -sf ${ZLIB_PREFIX}/lib/${ZLIB_LIBRARY} ${MASON_PREFIX}/lib/
}

function mason_cflags {
    echo ${MASON_CFLAGS}
}

function mason_ldflags {
    echo ${MASON_LDFLAGS}
}

mason_run "$@"
