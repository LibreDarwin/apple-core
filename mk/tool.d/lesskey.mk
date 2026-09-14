# lesskey(1) -- the lesskey target's sources, shared in part with less.
T_SRCS=		xbuf.c version.c lesskey.c lesskey_parse.c
T_CFLAGS+=	-I${TOP}/src/less -std=gnu99
