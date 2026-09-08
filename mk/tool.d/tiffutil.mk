# tiffutil(1)
#
# tiffdump_wrapper.c reuses libtiff's tiffdump(1) by #include-ing its source
# file: the dump() it wants is static, so it cannot be linked against.  A
# libtiff *installation* is therefore not enough -- homebrew ships headers and
# a library, not the tools sources -- and upstream's Makefile solves this by
# fetching and CMake-building libtiff into .libtiff/.
#
# We vendor instead: mk/compat/libtiff/ holds tiffdump.c from libtiff 4.6.0
# plus stand-ins for the three headers CMake would have generated or that
# libtiff keeps private.  See mk/compat/libtiff/tiffiop.h for why that costs
# nothing in coupling to the libtiff we actually link.
#
# The vendored tiffdump.c is reached through the wrapper's include, not as a
# source of its own, so it must not appear in T_SRCS.
TIFF_CFLAGS!=	pkg-config --cflags libtiff-4 2>/dev/null || true
TIFF_LIBS!=	pkg-config --libs libtiff-4 2>/dev/null || echo -ltiff

T_CFLAGS+=	-fobjc-arc ${TIFF_CFLAGS} \
		-I${TOP}/mk/compat/libtiff \
		-DLOCAL_TIFFDUMP_PATH='"${TOP}/mk/compat/libtiff/tiffdump.c"' \
		-DTIFFUTIL_VERSION=345.6

T_LDADD+=	-framework Foundation \
		-framework ApplicationServices \
		-framework CoreGraphics \
		-framework ImageIO \
		-lobjc ${TIFF_LIBS}

# Caveat: -dump is byte-identical to stock tiffutil, but -info differs
# cosmetically (tag spelling, a few tags shown or omitted).  Those come from
# the tool's patches/ and overlay/ against libtiff's own tif_print.c, which
# only take effect when libtiff itself is rebuilt from source; we link the
# installed one.
