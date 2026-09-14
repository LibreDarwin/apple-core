# screen(1) -- the screen target of screen.xcodeproj.  config.h and
# osdef.h are Apple's pre-configured copies inside the tree; RUN_LOGIN is
# the one define the target adds.
T_SRCS=	acls.c ansi.c attacher.c braille_tsi.c braille.c comm.c \
		display.c encoding.c fileio.c help.c input.c layer.c \
		loadav.c logfile.c mark.c misc.c nethack.c process.c \
		pty.c putenv.c resize.c sched.c screen.c search.c \
		socket.c teln.c term.c termcap.c utmp.c window.c \
		kmapdef.c tty.c
T_CFLAGS+=	-std=gnu99 -DRUN_LOGIN -I${T_SRCDIR}
T_LDADD+=	-lncurses
