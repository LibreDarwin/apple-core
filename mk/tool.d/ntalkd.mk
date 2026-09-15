# ntalkd(8) -- the ntalkd target of remote_cmds.xcodeproj, installed as
# stock macOS installs it, /usr/libexec/ntalkd.
#
# The target builds talkd/ with wall/'s ttymsg.c and puts wall/ on the
# header path for ttymsg.h.
T_SRCS=		process.c table.c print.c announce.c talkd.c \
		src/remote_cmds/wall/ttymsg.c
T_CFLAGS+=	-D__FBSDID=__RCSID -DCOLLATE_DEBUG -DYY_NO_UNPUT \
		-I${TOP}/src/remote_cmds/wall
