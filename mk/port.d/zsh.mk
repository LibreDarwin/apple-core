# zsh(1), from Apple's drop: upstream's tree under zsh/, configured with
# the flags Apple's wrapper Makefile passes it.
#
# --enable-pcre, as Apple configure it for macOS, against the PCRE 8.44
# the pcre port stages: its pcre-config on PATH, and its headers, since
# pcre-config names the host's /usr/local for them.  The module links
# libpcre.0.dylib by the install name stock macOS has.
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
			--enable-pcre \
			CPPFLAGS='-DUSE_GETCWD -I${PCRE_STAGE}/include -idirafter ${TOP}/include'
PCRE_STAGE=		${TOP}/build/ports/pcre/stage/usr/local
# Quoted: PATH may contain spaces, and env takes it as one word only so.
P_ENV=			"PATH=${PCRE_STAGE}/bin:$$PATH"
P_PROGS=		../bin/zsh
P_RELEASE_TREES=	lib/zsh usr/lib/zsh \
			share/zsh usr/share/zsh
