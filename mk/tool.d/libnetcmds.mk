# libnetcmds -- network_cmds_lib, shared by arp, netstat, ping, route,
# traceroute and the rest of the network_cmds family.
T_SRCS=		network_cmds_lib.c gmt2local.c
T_CFLAGS+=	-I${T_SRCDIR}
