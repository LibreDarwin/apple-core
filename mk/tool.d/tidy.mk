# tidy(1) -- the console front end, over libtidy's archive.
T_SRCS=		tidy.c
T_CFLAGS+=	-I${TOP}/src/tidy/tidy/include
T_LDADD+=	${LIBDIR}/libtidy.a
