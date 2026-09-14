# xxd(1) -- the xxd target of vim.xcodeproj: one source.
T_SRCS=	xxd.c
T_CFLAGS+=	-std=gnu11 -DHAVE_CONFIG_H -I${TOP}/src/vim/src
