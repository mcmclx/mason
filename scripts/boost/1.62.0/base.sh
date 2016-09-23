#!/usr/bin/env bash

export MASON_VERSION=1.62.0
export BOOST_VERSION=${MASON_VERSION//./_}
export BOOST_TOOLSET="clang"
export BOOST_TOOLSET_CXX="clang++"
export BOOST_ARCH="x86"
export BOOST_SHASUM=c0c68b803898c12d7852fbe163d8ff34f663ae56
