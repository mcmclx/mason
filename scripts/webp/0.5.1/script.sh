#!/usr/bin/env bash

MASON_NAME=webp
MASON_VERSION=0.5.1
MASON_LIB_FILE=lib/libwebp.a
MASON_PKGCONFIG_FILE=lib/pkgconfig/libwebp.pc

. ${MASON_DIR}/mason.sh

function mason_load_source {
    mason_download \
        http://downloads.webmproject.org/releases/webp/libwebp-$MASON_VERSION.tar.gz \
        7c2350c6524e8419e6b541a9087607c91c957377

    mason_extract_tar_gz

    export MASON_BUILD_PATH=${MASON_ROOT}/.build/libwebp-${MASON_VERSION}
}

function mason_prepare_compile {
    ${MASON_DIR}/mason install libjpeg-turbo 1.5.1
    MASON_JPEG=$(${MASON_DIR}/mason prefix libjpeg-turbo 1.5.1)
    ${MASON_DIR}/mason install libpng 1.6.25
    MASON_PNG=$(${MASON_DIR}/mason prefix libpng 1.6.25)
    ${MASON_DIR}/mason install libtiff 4.0.7
    MASON_PNG=$(${MASON_DIR}/mason prefix libtiff 4.0.7)

    ## TODO add giflib stuff

}

function mason_compile {
    export CFLAGS="${CFLAGS:-} -Os"
    ./configure \
        --prefix=${MASON_PREFIX} \
        ${MASON_HOST_ARG} \
        --enable-static \
        --disable-shared \
        --with-pic \
        --enable-libwebpdecoder \
        --disable-cwebp \
        --disable-dwebp \
        --enable-swap-16bit-csp \
        --disable-gl \
        --disable-png \
        --disable-jpeg \
        --disable-tiff \
        --disable-gif \
        --disable-wic \
        --disable-dependency-tracking

    make install -j${MASON_CONCURRENCY}
}

function mason_strip_ldflags {
    ldflags=()
    while [[ $1 ]]
    do
        case "$1" in
            -lwebp)
                shift
                ;;
            -L*)
                shift
                ;;
            *)
                ldflags+=("$1")
                shift
                ;;
        esac
    done
    echo "${ldflags[@]}"
}

function mason_ldflags {
    mason_strip_ldflags $(`mason_pkgconfig` --static --libs)
}

function mason_clean {
    make clean
}

mason_run "$@"
