#!/usr/bin/env bash

MASON_NAME=gettext
MASON_VERSION=0.19.8
MASON_LIB_FILE=lib/libgettextlib.a

. ${MASON_DIR}/mason.sh

function mason_load_source {
    mason_download \
	http://ftp.gnu.org/pub/gnu/gettext/gettext-0.19.8.tar.gz \
	2358a08c331ecf5c513483f49bf37f1f50f88f88

    mason_extract_tar_gz

    export MASON_BUILD_PATH=${MASON_ROOT}/.build/gettext-${MASON_VERSION}
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

mason_run "$@"
