# libvterm -- the terminal emulator vim's :terminal is built on, the
# libvterm target of vim.xcodeproj; static and only for vim(1).  The
# defines route its allocation and width queries to vim's own.
T_SRCS=	vterm.c screen.c encoding.c unicode.c src/vim/src/beval.c \
		mouse.c pen.c state.c parser.c keyboard.c
T_CFLAGS+=	-std=gnu11 -D_FORTIFY_SOURCE=0 -DHAVE_CONFIG_H -DINLINE="" \
		-DSNPRINTF=vim_snprintf -DVSNPRINTF=vim_vsnprintf \
		-DWCWIDTH_FUNCTION=utf_uint2cells \
		-DIS_COMBINING_FUNCTION=utf_iscomposing_uint \
		-I${TOP}/src/vim/src -I${TOP}/src/vim/src/proto \
		-I${TOP}/src/vim/src/libvterm/include
