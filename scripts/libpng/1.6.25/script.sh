#!/usr/bin/env bash

MASON_NAME=libpng
MASON_VERSION=1.6.25
MASON_LIB_FILE=lib/libpng.a
MASON_PKGCONFIG_FILE=lib/pkgconfig/libpng.pc

. ${MASON_DIR}/mason.sh

function mason_load_source {
    mason_download \
        http://downloads.sourceforge.net/project/libpng/libpng16/${MASON_VERSION}/libpng-${MASON_VERSION}.tar.gz \
        a88b710714a8e27e5e5aa52de28076860fc7748c

    mason_extract_tar_gz

    export MASON_BUILD_PATH=${MASON_ROOT}/.build/libpng-${MASON_VERSION}
}

function mason_prepare_compile {
    ${MASON_DIR}/mason install zlib 1.2.8
    MASON_ZLIB=$(${MASON_DIR}/mason prefix zlib 1.2.8)
    export ZLIBLIB="$MASON_ZLIB/lib"
    export ZLIBINC="$MASON_ZLIB/include"
    export LDFLAGS="${LDFLAGS:-} -L$MASON_ZLIB/lib"
    export CPPFLAGS="${CPPFLAGS:-} -I$MASON_ZLIB/include"
}

function mason_compile {
    export CFLAGS="${CFLAGS:-} -O3"
    ./configure \
        --prefix=${MASON_PREFIX} \
        ${MASON_HOST_ARG} \
        --enable-static \
        --with-pic \
        --disable-shared \
        --disable-dependency-tracking

    make install -j${MASON_CONCURRENCY}
}

function mason_strip_ldflags {
    shift # -L...
    shift # -lpng16
    echo "$@"
}

function mason_ldflags {
    mason_strip_ldflags $(`mason_pkgconfig` --static --libs)
}

function mason_clean {
    make clean
}

mason_run "$@"
