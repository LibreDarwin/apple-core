# libbz2 -- installed as /usr/lib/libbz2.1.0.dylib, with the two other
# names create_dylib_symlinks.sh gives it.  crc32vec.s is Apple's
# vectorised CRC, one per architecture under the same file name; only the
# host's is built, as only one could share the object name.
_ARCH!=		uname -m
T_SRCS=		blocksort.c bzlib.c compress.c crctable.c decompress.c \
		huffman.c randtable.c src/bzip2/bzip2/${_ARCH}/crc32vec.s
T_DYLIB=	libbz2.1.0.dylib
T_LINKS=	libbz2.dylib libbz2.1.0.8.dylib
T_LDADD+=	-Wl,-unexported_symbols_list,${TOP}/src/bzip2/unexports
