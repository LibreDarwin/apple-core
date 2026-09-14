# less(1), and more(1), which Apple install as a hardlink to it.  The
# less target's sources; defines.h is Apple's pre-configured copy at the
# top of the submodule.
T_SRCS=		pattern.c cvt.c brac.c ch.c xbuf.c charset.c cmdbuf.c \
		command.c decode.c edit.c filename.c lesskey_parse.c \
		forwback.c help.c ifile.c input.c jump.c line.c linenum.c \
		lsystem.c main.c mark.c optfunc.c option.c opttbl.c os.c \
		output.c position.c prompt.c screen.c search.c signal.c \
		tags.c evar.c ttyin.c version.c
T_CFLAGS+=	-I${TOP}/src/less -std=gnu99 \
		-DSYSDIR='"/etc"' -DBINDIR='"/usr/bin"'
T_LDADD+=	-lncurses
T_LINKS=	more
