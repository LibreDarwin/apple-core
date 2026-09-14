# top(1) -- the top target's sources, linked as Apple link it: against
# libtop (their own static library, mk/libs.mk), libutil, ncurses and
# panel.
T_SRCS=		command.c cpu.c csw.c faults.c generic.c globalstats.c \
		layout.c log.c main.c memstats.c messages.c options.c pgrp.c \
		pid.c ports.c ppid.c preferences.c pstate.c statistic.c \
		syscalls.c threads.c timestat.c top.c uid.c uinteger.c user.c \
		userinput.c userinput_mode.c userinput_order.c \
		userinput_sleep.c userinput_user.c workqueue.c \
		userinput_signal.c logging.c userinput_secondary_order.c \
		sig.c userinput_help.c power.c
T_CFLAGS+=	-std=gnu11
.include "${TOP}/mk/with-libutil.mk"
T_LDADD+=	${LIBDIR}/libtop.a -framework CoreFoundation -framework IOKit \
		-lncurses -lpanel
