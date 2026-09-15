# syslogd(8) -- the syslogd target of syslog.xcodeproj, over aslcommon and
# libbsm.  asl_action.c reads managed configuration through
# <configuration_profile.h>, which include/ carries from Libinfo-600.
# dbserver.c's xpc_copy_entitlement_for_token() is in include/xpc/private.h.
# daemon.c wants PROC_PIDUNIQIDENTIFIERINFO from <libproc.h>; the internal
# SDK's <sys/proc_info.h> ends by including xnu's <sys/proc_info_private.h>,
# which include/ carries, so it is pulled in here the same way.
T_CFLAGS+=	-include sys/proc_info_private.h
T_SRCS=	asl_action.c bsd_out.c daemon.c dbserver.c klog_in.c remote.c \
		syslogd.c udp_in.c
.include "${TOP}/mk/with-aslcommon.mk"
T_LDADD+=	-lbsm
