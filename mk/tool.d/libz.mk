# libz -- installed as /usr/lib/libz.1.dylib, under every name Apple's
# install phase links to it; exports as libz.exp lists.
#
# Plain zlib, without Apple's AddOn.  VEC_OPTIMIZE and INFFAST_OPT switch
# on their vectorised adler32/crc32 and a decode-ahead inflate_fast, all
# declared in AddOn/zopt_defs.h -- which no file in the drop includes.
# adler32.c, crc32.c and infback.c use those declarations with nothing
# supplying them: no include, prefix header, per-file flag or xcconfig.
# The same tree builds as ordinary zlib 1.2.12 with the switches off.
# ponytail: slower than Apple's; add the AddOn back once a drop that
# wires it up is available.
T_SRCS=		adler32.c compress.c crc32.c deflate.c infback.c inflate.c \
		inftrees.c trees.c uncompr.c zutil.c inffast.c gzclose.c \
		gzlib.c gzread.c gzwrite.c
T_CFLAGS+=	-std=gnu11 -DUSE_MMAP -I${T_SRCDIR}
T_DYLIB=	libz.1.dylib
T_LINKS=	libz.dylib libz.1.1.3.dylib libz.1.2.5.dylib libz.1.2.8.dylib \
		libz.1.2.11.dylib libz.1.2.12.dylib
T_LDADD+=	-Wl,-exported_symbols_list,${TOP}/src/zlib/libz.exp
