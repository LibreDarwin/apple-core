# syslog(1) -- the util target of syslog.xcodeproj.
#
# BLOCKED: links aslcommon, whose asl_common.c includes
# <configuration_profile.h> -- as does syslogd's asl_action.c -- and that
# header is in no SDK or source tree on this machine.
T_NOBUILD=	yes
