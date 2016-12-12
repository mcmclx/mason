#!/usr/bin/env bash

MASON_NAME=glib
MASON_VERSION=2.50.2
MASON_LIB_FILE=lib/libglib-2.0.a
MASON_PKGCONFIG_FILE=lib/pkgconfig/glib-2.0.pc

. ${MASON_DIR}/mason.sh

function mason_load_source {
    mason_download \
        http://ftp.gnome.org/pub/gnome/sources/glib/2.50/glib-2.50.2.tar.xz \
        bfef18703f56d41bb24caf5ee176e0c1000aa809

    mason_extract_tar_xz

    export MASON_BUILD_PATH=${MASON_ROOT}/.build/glib-${MASON_VERSION}
}

function mason_prepare_compile {

    ${MASON_DIR}/mason install libffi 3.2.1
    MASON_LIBFFI=$(${MASON_DIR}/mason prefix libffi 3.2.1)
    ${MASON_DIR}/mason install zlib 1.2.8
    MASON_ZLIB=$(${MASON_DIR}/mason prefix zlib 1.2.8)
    ${MASON_DIR}/mason install gettext 0.19.8
    MASON_GETTEXT=$(${MASON_DIR}/mason prefix gettext 0.19.8)
    ${MASON_DIR}/mason install util-linux 2.27
    MASON_UTILLINUX=$(${MASON_DIR}/mason prefix util-linux 2.27)
    export LDFLAGS="${LDFLAGS:-} -L$MASON_LIBFFI/lib -L$MASON_ZLIB/lib -L$MASON_GETTEXT/lib -L$MASON_UTILLINUX/lib"
    export CPPFLAGS="${CPPFLAGS:-} -I$MASON_LIBFFI/include -I$MASON_ZLIB/include -I$MASON_GETTEXT/include -I$MASON_UTILLINUX/include"
    export LIBFFI_LIBS="-L$MASON_LIBFFI/lib -lffi"
    export LIBFFI_CFLAGS="-I$MASON_LIBFFI/include"
    export PATH="$MASON_GETTEXT/bin:$PATH"

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
        --with-pcre=internal

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
