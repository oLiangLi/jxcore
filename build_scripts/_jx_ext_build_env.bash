#!/usr/bin/env bash

function jxcore_x86_64_Linux_build()
{
	make distclean
	
	sleep 2
	
	unset  TOOLCHAIN PREFIX CFLAGS CPPFLAGS CXXFLAGS LDFLAGS CC CXX AR RANLIB NM AS STRIP READELF STRINGS SIZE ADDR2LINE
	export PREFIX=$HOME/jxcore_binary/jxcore_x86_64_linux_sm
	
	export CFLAGS="-m64 -fvisibility=hidden -fvisibility-inlines-hidden"
	export CPPFLAGS=${CFLAGS}
	export CXXFLAGS=${CPPFLAGS}
	export CC="gcc -m64"
	export CXX="g++ -m64"
	
	echo CC       : $CC
	echo CXX      : $CXX
	echo CFLAGS   : $CFLAGS
	echo CXXFLAGS : $CXXFLAGS	
	sleep 2
	
	rm -rf $PREFIX/lib
	./configure  --prefix=$PREFIX --dest-cpu=x64 --dest-os=linux --shared-library  --engine-mozilla && make -j8
	sleep 5
	
	mkdir -p $PREFIX/lib
	install -m 644 -t $PREFIX/lib  out/Release/libjx.so
}


function jxcore_i686_Linux_build()
{
	make distclean
	
	sleep 2
	
	unset  TOOLCHAIN PREFIX CFLAGS CPPFLAGS CXXFLAGS LDFLAGS CC CXX AR RANLIB NM AS STRIP READELF STRINGS SIZE ADDR2LINE
	export PREFIX=$HOME/jxcore_binary/jxcore_i686_linux_sm
	
	export CFLAGS="-m32 -fvisibility=hidden -fvisibility-inlines-hidden"
	export CPPFLAGS=${CFLAGS}
	export CXXFLAGS=${CPPFLAGS}
	export CC="gcc -m32"
	export CXX="g++ -m32"
	
	echo CC       : $CC
	echo CXX      : $CXX
	echo CFLAGS   : $CFLAGS
	echo CXXFLAGS : $CXXFLAGS	
	sleep 2
	
	rm -rf $PREFIX/lib
	./configure  --prefix=$PREFIX --dest-cpu=ia32 --dest-os=linux --shared-library  --engine-mozilla && make -j8
	sleep 5
	
	mkdir -p $PREFIX/lib
	install -m 644 -t $PREFIX/lib  out/Release/libjx.so
}

function jxcore_arm_Linux_build()
{
	make distclean
	
	sleep 2
	
	unset  TOOLCHAIN PREFIX CFLAGS CPPFLAGS CXXFLAGS LDFLAGS CC CXX AR RANLIB NM AS STRIP READELF STRINGS SIZE ADDR2LINE
	export PREFIX=$HOME/jxcore_binary/jxcore_arm_linux_sm
	
	export TOOLCHAIN=arm-linux-gnueabi
	export CC=${TOOLCHAIN}-gcc
	export CXX=${TOOLCHAIN}-g++
	export AR=${TOOLCHAIN}-ar
	export RANLIB=${TOOLCHAIN}-ranlib
	export NM=${TOOLCHAIN}-nm
	export AS=${TOOLCHAIN}-as
	export STRIP=${TOOLCHAIN}-strip
	export READELF=${TOOLCHAIN}-readelf
	export STRINGS=${TOOLCHAIN}-strings
	export SIZE=${TOOLCHAIN}-size
	export ADDR2LINE=${TOOLCHAIN}-addr2line
	
##
## default, armv7, neon .....
##	
	
	export CFLAGS="-fvisibility=hidden -fvisibility-inlines-hidden -march=armv7-a -mtune=cortex-a8 -mfpu=neon"
	export CPPFLAGS=${CFLAGS}
	export CXXFLAGS=${CPPFLAGS}
	
	echo CC       : $CC
	echo CXX      : $CXX
	echo CFLAGS   : $CFLAGS
	echo CXXFLAGS : $CXXFLAGS	
	sleep 2
	
	rm -rf $PREFIX/lib
	./configure  --prefix=$PREFIX --dest-cpu=arm --dest-os=linux --shared-library  --engine-mozilla && make -j8
	sleep 5
	
	mkdir -p $PREFIX/lib
	install -m 644 -t $PREFIX/lib  out/Release/libjx.so
}


function jxcore_arm_Android_build()
{
	make distclean
	
	sleep 2
	
	unset  TOOLCHAIN PREFIX CFLAGS CPPFLAGS CXXFLAGS LDFLAGS CC CXX AR RANLIB NM AS STRIP READELF STRINGS SIZE ADDR2LINE
	export PREFIX=$HOME/jxcore_binary/jxcore_arm_android_sm
	
	export NDK_ROOT=~/android-ndk-r13b
	export ANDROID_NDK=$NDK_ROOT
	export NDK_PLATROOT=${NDK_ROOT}/platforms/android-16/arch-arm
	export STDCPP_ROOT=${NDK_ROOT}/sources/cxx-stl/gnu-libstdc++/4.9
	
	export TOOLCHAIN=${NDK_ROOT}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi
	export CC=${TOOLCHAIN}-gcc
	export CXX=${TOOLCHAIN}-g++
	export AR=${TOOLCHAIN}-ar
	export RANLIB=${TOOLCHAIN}-ranlib
	export NM=${TOOLCHAIN}-nm
	export AS=${TOOLCHAIN}-as
	export STRIP=${TOOLCHAIN}-strip
	export READELF=${TOOLCHAIN}-readelf
	export STRINGS=${TOOLCHAIN}-strings
	export SIZE=${TOOLCHAIN}-size
	export ADDR2LINE=${TOOLCHAIN}-addr2line
	
##
## default, armv7, neon .....
##	
	
	export CFLAGS="-fvisibility=hidden -fvisibility-inlines-hidden -I${PREFIX}/include -DPIC -D__ARM_ARCH_7__ -D__ARM_NEON__ -fpic -march=armv7-a -mtune=cortex-a8 -mfpu=neon -fno-short-enums -mthumb-interwork -B${NDK_PLATROOT}/usr -I${STDCPP_ROOT}/include -I${STDCPP_ROOT}/libs/armeabi-v7a/include -DANDROID"
	export CPPFLAGS=${CFLAGS}
	export CXXFLAGS=${CPPFLAGS}
	export LDFLAGS="-L${PREFIX}/lib -Wl,-rpath,${PREFIX}/lib --sysroot=${NDK_PLATROOT} -B${NDK_PLATROOT}/usr -L${NDK_PLATROOT}/usr/lib -L${STDCPP_ROOT}/libs/armeabi-v7a"
	
	echo CC       : $CC
	echo CXX      : $CXX
	echo CFLAGS   : $CFLAGS
	echo CXXFLAGS : $CXXFLAGS
	sleep 2
	
	rm -rf $PREFIX/lib
	./configure  --prefix=/system --dest-cpu=arm --dest-os=android --shared-library  --engine-mozilla
	
	make -j8
	sleep 5
	
	mkdir -p $PREFIX/lib
	install -m 644 -t $PREFIX/lib  out/Release/libjx.so
}



