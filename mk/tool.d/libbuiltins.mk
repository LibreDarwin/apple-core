# libbuiltins -- bash's builtins, the builtins/*.c sources of Apple's bash
# target (pre-generated from their .def files in the drop).  Static, and
# only for bash(1); see mk/tool.d/bash.mk for why it is an archive.
T_SRCS=	alias.c bashgetopt.c bind.c break.c builtin.c builtins.c \
		caller.c cd.c colon.c command.c common.c complete.c \
		declare.c echo.c enable.c eval.c evalfile.c evalstring.c \
		exec.c exit.c fc.c fg_bg.c getopt.c getopts.c hash.c \
		help.c history.c jobs.c kill.c let.c printf.c pushd.c \
		read.c return.c set.c setattr.c shift.c shopt.c source.c \
		suspend.c test.c times.c trap.c type.c ulimit.c umask.c \
		wait.c

.include "${TOP}/mk/with-bash.mk"
