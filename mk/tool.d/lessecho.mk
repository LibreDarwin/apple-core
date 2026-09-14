# lessecho(1) -- one source, and the defines.h less(1) uses.
T_SRCS=		lessecho.c
T_CFLAGS+=	-I${TOP}/src/less -std=gnu99
