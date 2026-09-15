# rtadvd(8) -- the rtadvd target of network_cmds.xcodeproj, as
# network_cmds-705.100.5 last published it.
#
# network_cmds-741.100.2 keeps only rtadvd.tproj/run-rtadvd, though macOS
# still ships /usr/sbin/rtadvd; mk/patches/rtadvd restores the daemon's
# sources from 705.100.5, so they are named by their TOP-relative path into
# the patched copy.  The flags and libutil link are that release's target's.
_RT=		${T_COPYDIR:S|^${TOP}/||}/rtadvd.tproj
T_SRCS=		${_RT}/rtadvd_logging.c ${_RT}/advcap.c ${_RT}/config.c \
		${_RT}/dump.c ${_RT}/if.c ${_RT}/rrenum.c ${_RT}/rtadvd.c \
		${_RT}/timer.c
# Apple's build reaches the RFC 3542 IPv6 socket options (IPV6_PKTINFO, ...)
# and the traffic-class socket options (SO_TRAFFIC_CLASS, SO_TC_CTL) through
# the internal SDK; here they come from __APPLE_USE_RFC_3542 and xnu's
# <sys/socket_private.h>, which include/ carries.
T_CFLAGS+=	-DINET6 -DHAVE_GETIFADDRS -I${TOP}/src/libutil \
		-D__APPLE_USE_RFC_3542 -include sys/socket_private.h
T_LDADD+=	-lutil
