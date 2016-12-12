#!/usr/bin/env bash

MASON_NAME=util-linux
MASON_VERSION=2.27
MASON_LIB_FILE=lib/libmount.a
MASON_PKGCONFIG_FILE=lib/pkgconfig/libmount.pc

. ${MASON_DIR}/mason.sh

function mason_load_source {
    mason_download \
	https://www.kernel.org/pub/linux/utils/util-linux/v2.27/util-linux-2.27.tar.gz \
	bbcdf7a7cd6d107b6abb930dfb1bdd37904d575e

    mason_extract_tar_gz

    export MASON_BUILD_PATH=${MASON_ROOT}/.build/util-linux-${MASON_VERSION}
}

function mason_compile {
    export CFLAGS="${CFLAGS:-} -O3"
    ./configure \
        --prefix=${MASON_PREFIX} \
        ${MASON_HOST_ARG} \
        --disable-wall \
        --disable-bash-completion \
        --enable-static \
        --with-pic \
        --disable-shared \
        --disable-dependency-tracking

    make install -j${MASON_CONCURRENCY}
}

mason_run "$@"
