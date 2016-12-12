#!/usr/bin/env bash

MASON_NAME=libgsf
MASON_VERSION=1.14.4
MASON_LIB_FILE=lib/libgsf.a
MASON_PKGCONFIG_FILE=lib/pkgconfig/libpng.pc

. ${MASON_DIR}/mason.sh

function mason_load_source {
    mason_download \
        http://ftp.acc.umu.se/pub/GNOME/sources/libgsf/1.14/libgsf-1.14.4.tar.gz \
        342800f9eefdf47194f97c5601083a7b11ebfceb

    mason_extract_tar_gz

    export MASON_BUILD_PATH=${MASON_ROOT}/.build/libgsf-${MASON_VERSION}
}

function mason_prepare_compile {
    ${MASON_DIR}/mason install zlib 1.2.8
    MASON_ZLIB=$(${MASON_DIR}/mason prefix zlib 1.2.8)
    ${MASON_DIR}/mason install glib 2.50.2
    MASON_GLIB=$(${MASON_DIR}/mason prefix glib 2.50.2)
    ${MASON_DIR}/mason install libxml2 2.9.3
    MASON_LIBXML2=$(${MASON_DIR}/mason prefix libxml2 2.9.3)
    export LIBGSF_LIBS="-L$MASON_GLIB/lib"
    export LIBGSF_FLAGS="-I$MASON_GLIB/include/glib-2.0"
    export LDFLAGS="${LDFLAGS:-} -L$MASON_ZLIB/lib -L$MASON_GLIB/lib -lm -lglib-2.0 -L$MASON_LIBXML2/lib"
    export CPPFLAGS="${CPPFLAGS:-} -I$MASON_ZLIB/include -I$MASON_GLIB/include/glib-2.0 -I$MASON_GLIB/lib/glib-2.0/include -I$MASON_LIBXML2/include/libxml2"
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

function mason_clean {
    make clean
}

mason_run "$@"
