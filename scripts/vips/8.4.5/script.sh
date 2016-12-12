#!/usr/bin/env bash

MASON_NAME=vips
MASON_VERSION=8.4.5

. ${MASON_DIR}/mason.sh

function mason_load_source {
    mason_download \
	http://www.vips.ecs.soton.ac.uk/supported/current/vips-8.4.5.tar.gz \
	1388890790e8c589fa5852dadd159d82f042ead2

    mason_extract_tar_gz

    export MASON_BUILD_PATH=${MASON_ROOT}/.build/vips-${MASON_VERSION}
}

function mason_prepare_compile {
    ${MASON_DIR}/mason install libxml2 2.9.3
    MASON_LIBXML2=$(${MASON_DIR}/mason prefix libxml2 2.9.3)
    ${MASON_DIR}/mason install glib 2.50.2
    MASON_GLIB=$(${MASON_DIR}/mason prefix glib 2.50.2)
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
