# libtop -- the process-sampling half of top(1), which Apple build as a
# static library and link into it.
T_SRCS=		libtop.c
T_CFLAGS+=	-std=gnu11
