#!/usr/bin/env bash

MASON_NAME=libffi
MASON_VERSION=3.2.1
MASON_LIB_FILE=lib/libffi.a
MASON_PKGCONFIG_FILE=lib/pkgconfig/libffi.pc

. ${MASON_DIR}/mason.sh

function mason_load_source {
    mason_download \
	ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz \
	5c21bb01242a3a46e538fa54bf32f96f8d3cf85b

    mason_extract_tar_gz

    export MASON_BUILD_PATH=${MASON_ROOT}/.build/libffi-${MASON_VERSION}
}

function mason_compile {
    /usr/bin/perl -pe 's#^AM_CFLAGS = .*#AM_CFLAGS = -g#' -i Makefile.in
    /usr/bin/perl -pe 's#^includesdir = .*#includesdir = \@includedir\@#' -i include/Makefile.in

    export CFLAGS="${CFLAGS:-} -O3"
    ./configure \
        --prefix=${MASON_PREFIX} \
        ${MASON_HOST_ARG} \
        --includedir=${MASON_PREFIX}/include \
        --enable-static \
        --with-pic \
        --disable-shared \
        --disable-dependency-tracking

    make install -j${MASON_CONCURRENCY}
}

mason_run "$@"
