# lsmp(1) -- the lsmp target of system_cmds.xcodeproj.
#
# task_read_for_pid(), which it uses to read other tasks' port spaces, is
# declared by include/mach/task_for_pid_private.h (see the header); the
# internal SDK declares it where the public one declares task_for_pid().
# Stock lsmp links libutil.
T_SRCS=		lsmp.c port_details.c task_details.c
T_CFLAGS+=	-include mach/task_for_pid_private.h
T_LDADD+=	-lutil
