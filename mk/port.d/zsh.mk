# zsh(1), from Apple's drop: upstream's tree under zsh/, configured with
# the flags Apple's wrapper Makefile passes it.
#
# --enable-pcre is left out: Apple turn it on for macOS, but the public
# SDK carries no PCRE headers, so the zsh/pcre module is not built.
# ponytail: add it back once a pcre port exists.
#
# init.c includes <System/sys/codesign.h> for csops(), which only our
# include/ carries.  -idirafter reaches it without letting anything there
# shadow the SDK's own headers.
#
# zsh loads most of itself -- zle included -- as modules at run time, so
# they and the shell functions are installed beside it under usr/lib/zsh
# and usr/share/zsh, where it looks for them.
P_CONFIGURE_ARGS=	--bindir=/bin --with-tcsetpgrp --enable-multibyte \
			--enable-unicode9 --enable-max-function-depth=700 \
			CPPFLAGS='-DUSE_GETCWD -idirafter ${TOP}/include'
P_PROGS=		../bin/zsh
P_RELEASE_TREES=	lib/zsh usr/lib/zsh \
			share/zsh usr/share/zsh
