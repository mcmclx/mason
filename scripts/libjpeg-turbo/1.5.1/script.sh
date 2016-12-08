#!/usr/bin/env bash

MASON_NAME=libjpeg-turbo
MASON_VERSION=1.5.1
MASON_LIB_FILE=lib/libjpeg.a

. ${MASON_DIR}/mason.sh

function mason_load_source {
    mason_download \
        http://downloads.sourceforge.net/project/libjpeg-turbo/1.5.1/libjpeg-turbo-1.5.1.tar.gz \
        4038bb4242a3fc3387d5dc4e37fc2ac7fffaf5da

    mason_extract_tar_gz

    export MASON_BUILD_PATH=${MASON_ROOT}/.build/libjpeg-turbo-1.5.1
}

function mason_prepare_compile {
    ${MASON_DIR}/mason install nasm 2.12.02
    MASON_NASM=$(${MASON_DIR}/mason prefix nasm 2.12.02)
}

function mason_compile {
    export CFLAGS="${CFLAGS:-} -O3"
    ./configure \
        --prefix=${MASON_PREFIX} \
        ${MASON_HOST_ARG} \
        --with-jpeg8 \
        --without-turbojpeg \
        --enable-static \
        --with-pic \
        --disable-shared \
        --disable-dependency-tracking \
        NASM=${MASON_NASM}/bin/nasm

    V=1 make install -j${MASON_CONCURRENCY}
    rm -rf ${MASON_PREFIX}/bin
}

function mason_cflags {
    echo -I${MASON_PREFIX}/include
}

function mason_ldflags {
    : # We're only using the full path to the archive, which is output in static_libs
}

function mason_clean {
    make clean
}

mason_run "$@"
