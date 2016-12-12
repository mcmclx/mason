#!/usr/bin/env bash

MASON_NAME=libpcre
MASON_VERSION=8.39
MASON_LIB_FILE=lib/libpcre.a
MASON_PKGCONFIG_FILE=lib/pkgconfig/libpcre.pc

. ${MASON_DIR}/mason.sh

function mason_load_source {
    mason_download \
	ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.39.tar.bz2 \
	2e82eaaee5f53d8403a4211d15c43001638e696f

    mason_extract_tar_bz2

    export MASON_BUILD_PATH=${MASON_ROOT}/.build/pcre-${MASON_VERSION}
}

function mason_compile {
    export CFLAGS="${CFLAGS:-} -O3"
    ./configure \
        --prefix=${MASON_PREFIX} \
        ${MASON_HOST_ARG} \
        --enable-static \
        --with-pic \
        --disable-shared \
        --disable-dependency-tracking \
        --enable-unicode-properties \
	--enable-utf8 \
	--enable-pcre16 \
	--enable-pcre32 \
        --enable-jit


    make install -j${MASON_CONCURRENCY}
}

mason_run "$@"
