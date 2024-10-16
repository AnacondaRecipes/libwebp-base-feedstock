#!/bin/bash
set -ex

cmake -G Ninja -S . -B build ${CMAKE_ARGS} \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    -DBUILD_SHARED_LIBS=ON \
    -DWEBP_BUILD_CWEBP:BOOL=OFF \
    -DWEBP_BUILD_DWEBP:BOOL=OFF \
    -DWEBP_BUILD_EXTRAS:BOOL=OFF \
    -DWEBP_BUILD_GIF2WEBP:BOOL=OFF \
    -DWEBP_BUILD_IMG2WEBP:BOOL=OFF \
    -DWEBP_BUILD_LIBWEBPMUX:BOOL=ON \
    -DWEBP_BUILD_VWEBP:BOOL=OFF \
    -DWEBP_BUILD_WEBP_JS:BOOL=OFF \
    -DWEBP_BUILD_WEBPINFO:BOOL=OFF \
    -DWEBP_BUILD_WEBPMUX:BOOL=OFF \
    -DWEBP_LINK_STATIC:BOOL=OFF

cmake --build build -j${CPU_COUNT}

cmake --install build --prefix ${PREFIX}

# Problems in Prefect
if [[ ${target_platform} == "osx-arm64" ]] ; then
    set +x
    uname -a
    id -a
    sw_vers
    env | sort
    echo
    BUILD_ROOT=${SRC_DIR%/*}
    echo BUILD_ROOT=${BUILD_ROOT}

    for dir in build ${PREFIX}/lib ; do
	for lib in ${dir}/lib{sharpyuv,webpdecoder,webp,webpdemux,webpmux}.dylib; do
	    echo "**** ${dir##*/}/${lib##*/}"
	    otool -L $lib
	    otool -l $lib | grep -A2 PATH
	    echo
	done
    done

    if [[ -d $HOME/ifitchet ]] ; then
	echo Copying ${BUILD_ROOT}
	set -x
	cp -r ${BUILD_ROOT} $HOME/ifitchet
    fi
fi
