#!/bin/bash
set -e

libPath=lib
configuration=Release
libSuffix=

shopt -s nocasematch
while test $# -gt 0
do
    case "$1" in
        forceclean|clean) forceclean=1 #actionList=(clean build)
            ;;
        debug) libPath=debug/lib
				configuration=Debug
                libSuffix=d
            ;;
        release) libPath=lib
				configuration=Release
                libSuffix=
            ;;
        *) echo "wrong argument: $1"
			exit 1
            ;;
    esac
    shift
done


# set deployment target to macOS 10.9:
export MACOSX_DEPLOYMENT_TARGET=10.9

## NOTE!!! gobject-instrspection is needed, but install it without installing glib, libffi, or other libraries!!!
## $ brew install autoconf automake gtk-doc gobject-introspection


# Alternatively, you may set the environment variables REQUIRED_CFLAGS
# and REQUIRED_LIBS to avoid the need to call pkg-config.

export OSS_BINARIES_PATH=~/code/sampi/ossBinaries/macOS
export REQUIRED_CFLAGS="-I$OSS_BINARIES_PATH/include"
export REQUIRED_LIBS="-framework CoreServices -framework CoreFoundation -framework CoreGraphics -framework CoreText -liconv \
    -L$OSS_BINARIES_PATH/$libPath -lintl -lffi -lglib-2.0 -lgobject-2.0 -lgio-2.0 -lgmodule-2.0 -lgthread-2.0 -lpango-1 -lpangoft2-1 \
    -lfontconfig -llcms$libSuffix -lpng -lturbojpeg -llibexif -ltiff$libSuffix -lz -lpcre -llzma$libSuffix -lharfbuzz \
    -lfreetype$libSuffix -lbz2$libSuffix -lcairo$libSuffix -lrsvg-2.40$libSuffix"
export GTHREAD_CFLAGS="-I$OSS_BINARIES_PATH/include"
export GTHREAD_LIBS="-L$OSS_BINARIES_PATH/$libPath"
export THREADS_CFLAGS="-I$OSS_BINARIES_PATH/include"
export THREADS_LIBS="-L$OSS_BINARIES_PATH/$libPath"

# also there's a script from glib needed for building vips, we should add the
# last path to the environment variable in order for vips to build correctly:

export PATH=$OSS_BINARIES_PATH:$PATH

export JPEG_CFLAGS="-I$OSS_BINARIES_PATH/include"
export JPEG_LIBS="-L$OSS_BINARIES_PATH/$libPath"
export EXIF_CFLAGS="-I$OSS_BINARIES_PATH/include"
export EXIF_LIBS="-L$OSS_BINARIES_PATH/$libPath"
export PNG_CFLAGS="-I$OSS_BINARIES_PATH/include"
export PNG_LIBS="-L$OSS_BINARIES_PATH/$libPath"
export TIFF_CFLAGS="-I$OSS_BINARIES_PATH/include"
export TIFF_LIBS="-L$OSS_BINARIES_PATH/$libPath"
export PANGOFT2_CFLAGS="-I$OSS_BINARIES_PATH/include"
export PANGOFT2_LIBS="-L$OSS_BINARIES_PATH/$libPath"
export ZLIB_CFLAGS="-I$OSS_BINARIES_PATH/include"
export ZLIB_LIBS="-L$OSS_BINARIES_PATH/$libPath"
export LCMS_CFLAGS="-I$OSS_BINARIES_PATH/include"
export LCMS_LIBS="-L$OSS_BINARIES_PATH/$libPath"
export RSVG_CFLAGS="-I$OSS_BINARIES_PATH/include"
export RSVG_LIBS="-L$OSS_BINARIES_PATH/$libPath"

if [ "$configuration" == "Debug" ]; then
	CFLAGS="$CFLAGS -g -O0" 
	CPPFLAGS="$CPPFLAGS -g -O0" 
	LDFLAGS="$LDFLAGS -g"
fi

export DESTINATION_PATH=~/code/sampi/ossBinaries/custom/macOS

pushd srclibvips

# Autogen calls ./configure

sh autogen.sh --enable-static=no --enable-shared=yes --enable-debug=no --without-magick --without-OpenEXR --without-libwebp --without-heif

make -j 4

install_name_tool -id @rpath/libvips.dylib libvips/.libs/libvips.42.dylib
cp -Ra libvips/.libs/libvips.42.dylib "$DESTINATION_PATH/$configuration/libvips.dylib"
install_name_tool -id @rpath/libvips-cpp.dylib cplusplus/.libs/libvips-cpp.42.dylib 
install_name_tool -change /usr/local/lib/libvips.42.dylib @rpath/libvips.dylib cplusplus/.libs/libvips-cpp.42.dylib 
cp -Ra cplusplus/.libs/libvips-cpp.42.dylib "$DESTINATION_PATH/$configuration/libvips-cpp.dylib"
mkdir -p $DESTINATION_PATH/include/vips
cp -Ra libvips/include/vips/*.h $DESTINATION_PATH/include/vips
cp -Ra cplusplus/include/vips/*.h cplusplus/include/vips/vips8 $DESTINATION_PATH/include/vips/

popd

g++ -dynamiclib -o $DESTINATION_PATH/$configuration/libvipsCC.dylib -install_name @rpath/libvipsCC.dylib libvipsCC/VImage.cc libvipsCC/VError.cc libvipsCC/VDisplay.cc libvipsCC/VMask.cc -Isrclibvips/libvips/include/ -I$OSS_BINARIES_PATH/include -IlibvipsCC/include -lvips -lgobject-2.0 -L$OSS_BINARIES_PATH/$libPath -Lsrclibvips/libvips/.libs -install_name @rpath/libvipsCC.dylib
cp -Ra libvipsCC/include/vips/*.h libvipsCC/include/vips/vips $DESTINATION_PATH/include/vips/

