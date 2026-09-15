# vm_purgeable_stat(1) -- the vm_purgeable_stat target of
# system_cmds.xcodeproj.
#
# task_inspect_for_pid() is declared by include/mach/task_for_pid_private.h
# (see the header).  Apple's target links libutil.
T_SRCS=		vm_purgeable_stat.c
T_CFLAGS+=	-include mach/task_for_pid_private.h
T_LDADD+=	-lutil
