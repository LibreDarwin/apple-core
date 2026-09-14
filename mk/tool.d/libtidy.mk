# libtidy -- the libtidy-static target's sources, which Apple force-load
# into /usr/lib/libtidy.A.dylib; symbols are hidden unless TIDY_EXPORT
# marks them, and the dylib exports what libtidy.exp lists.
T_SRCS=		access.c alloc.c attrask.c attrdict.c attrget.c attrs.c \
		buffio.c clean.c config.c entities.c fileio.c istack.c \
		lexer.c localize.c mappedio.c parser.c pprint.c streamio.c \
		tagask.c tags.c tidylib.c tmbstr.c utf8.c
T_CFLAGS+=	-I${T_SRCDIR} -I${TOP}/src/tidy/tidy/include \
		-fvisibility=hidden -DTIDY_APPLE_BUILD_NUMBER=00 \
		-DTIDY_APPLE_BUILD_NUMBER_STR='"00"' \
		-DTIDY_EXPORT='__attribute__((visibility("default")))'
T_DYLIB=	libtidy.A.dylib
T_LINKS=	libtidy.dylib
T_LDADD+=	-Wl,-exported_symbols_list,${TOP}/src/tidy/libtidy.exp
