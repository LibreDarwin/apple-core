# telnetd(8) -- the telnetd target of remote_cmds.xcodeproj.
#
# The target compiles eight files, not every .c in telnetd/: authenc.c,
# which the directory also holds, is left out of Apple's build -- and
# does not compile, its tail closing an #ifdef it never opened.
# password_enabled.c sits one level up, shared with the other remote_cmds
# daemons.  Apple link libncurses and libtelnet, which lib/ builds here.
T_SRCS=		termstat.c telnetd.c slc.c utility.c state.c \
		src/remote_cmds/password_enabled.c sys_term.c global.c
T_CFLAGS+=	-D__FBSDID=__RCSID -DNO_UTMP -DLINEMODE -DKLUDGELINEMODE \
		-DUSE_TERMIO -DDIAGNOSTICS -DOLD_ENVIRON -DENV_HACK -DINET6
.include "${TOP}/mk/with-libtelnet.mk"
T_LDADD+=	-lncurses
