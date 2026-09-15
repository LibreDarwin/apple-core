# lskq(1) -- system_cmds' lskq.
#
# <libproc_private.h> is xnu's (libsyscall), in include/.  The dynamic
# kqueue flavours and extended kevent records it reads
# (PROC_PIDDYNKQUEUE_INFO, PROC_PIDFDKQUEUE_EXTINFO, struct kevent_extinfo)
# are xnu's <sys/proc_info_private.h> and <sys/event_private.h>, which the
# internal SDK's public headers end by including; they are pulled in the
# same way.
T_CFLAGS+=	-include sys/proc_info_private.h -include sys/event_private.h
