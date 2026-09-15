# syslogd(8) -- the syslogd target of syslog.xcodeproj, over aslcommon and
# libbsm.  asl_action.c reads managed configuration through
# <configuration_profile.h>, which include/ carries from Libinfo-600.
#
# BLOCKED: libsystem_asl's private headers (asl_private.h, asl_msg_list.h)
# include <os/object_private.h>.  libdispatch's copy is on this machine,
# but it does not compile against the public SDK -- its line 202,
#     API_AVAILABLE(macos(10.14), ios(12.0), tvos(12.0), watchos(5.0), bridgeos(4.0))
# needs private availability macros -- and syslogd and aslmanager also
# include <xpc/private.h>, the private XPC tree.  <configuration_profile.h>,
# the header these first stopped on, is in include/ from Libinfo-600.
T_NOBUILD=	yes
T_SRCS=	asl_action.c bsd_out.c daemon.c dbserver.c klog_in.c remote.c \
		syslogd.c udp_in.c
.include "${TOP}/mk/with-aslcommon.mk"
T_LDADD+=	-lbsm
