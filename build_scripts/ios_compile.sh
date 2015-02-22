#!/bin/bash

NORMAL_COLOR='\033[0m'
RED_COLOR='\033[0;31m'
GREEN_COLOR='\033[0;32m'
GRAY_COLOR='\033[0;37m'

ARM7=out_ios/arm
ARM64=out_ios/arm64
INTEL64=out_ios/x64
FATBIN=out_ios/ios

LOG() {
    COLOR="$1"
    TEXT="$2"
    echo -e "${COLOR}$TEXT ${NORMAL_COLOR}"
}


ERROR_ABORT() {
	if [[ $? != 0 ]]
	then
		LOG $RED_COLOR "Compilation aborted\n"
		exit	
	fi
}


ERROR_ABORT_MOVE() {
	if [[ $? != 0 ]]
	then
	    $($1)
		LOG $RED_COLOR "Compilation aborted\n"
		exit	
	fi
}

# ./configure --prefix=out_ios/arm64 --static-library --dest-os=ios --dest-cpu=arm64 --engine-mozilla

MAKE_INSTALL() {
    TARGET_DIR="out_$1_ios"
    PREFIX_DIR="out_ios/$1"
    mv $TARGET_DIR out
    ./configure --prefix=$PREFIX_DIR --static-library --dest-os=ios --dest-cpu=$1 --engine-mozilla
    ERROR_ABORT_MOVE "mv out $TARGET_DIR"
	rm -rf $PREFIX_DIR/bin
	make install
	ERROR_ABORT_MOVE "mv out $TARGET_DIR"
	mv out $TARGET_DIR
	
	mv $PREFIX_DIR/bin/libcares.a "$PREFIX_DIR/bin/libcares_$1.a"
	mv $PREFIX_DIR/bin/libchrome_zlib.a "$PREFIX_DIR/bin/libchrome_zlib_$1.a"
	mv $PREFIX_DIR/bin/libhttp_parser.a "$PREFIX_DIR/bin/libhttp_parser_$1.a"
	mv $PREFIX_DIR/bin/libjx.a "$PREFIX_DIR/bin/libjx_$1.a"
	mv $PREFIX_DIR/bin/libmozjs.a "$PREFIX_DIR/bin/libmozjs_$1.a"
	mv $PREFIX_DIR/bin/libopenssl.a "$PREFIX_DIR/bin/libopenssl_$1.a"
	mv $PREFIX_DIR/bin/libuv.a "$PREFIX_DIR/bin/libuv_$1.a"
	mv $PREFIX_DIR/bin/libsqlite3.a "$PREFIX_DIR/bin/libsqlite3_$1.a"
}


MAKE_FAT() {
	lipo -create "$ARM64/bin/$1_arm64.a" "$ARM7/bin/$1_arm.a" "$INTEL64/bin/$1_x64.a" -output "$FATBIN/bin/$1.a"
	ERROR_ABORT
}


mkdir out_arm_ios
mkdir out_arm64_ios
mkdir out_x64_ios
mkdir out_ios

rm -rf out

LOG $GREEN_COLOR "Compiling IOS ARM7\n"
MAKE_INSTALL arm

LOG $GREEN_COLOR "Compiling IOS ARM64\n"
MAKE_INSTALL arm64

LOG $GREEN_COLOR "Compiling IOS INTEL64\n"
MAKE_INSTALL x64
 

LOG $GREEN_COLOR "Preparing FAT binaries\n"
rm -rf $FATBIN
mkdir -p $FATBIN/bin
mv $ARM7/include $FATBIN/
cp deps/mozjs/src/js.msg $FATBIN/include/node/

MAKE_FAT "libcares"
MAKE_FAT "libchrome_zlib"
MAKE_FAT "libhttp_parser"
MAKE_FAT "libjx"
MAKE_FAT "libmozjs"
MAKE_FAT "libopenssl"
MAKE_FAT "libuv"
MAKE_FAT "libsqlite3"

