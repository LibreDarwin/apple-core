# mk/with-netcmds.mk
#
# Shared fragment: include from a network_cmds tool's
# mk/tool.d/<prog>.mk to build against the shared network_cmds_lib
# helpers (getsocket, gmt2local, ...).
#
#	T_CFLAGS+= -I${TOP}/src/network_cmds/network_cmds_lib
#	T_CFLAGS+= -include ${TOP}/mk/net-private-compat.h
#	T_LDADD+=  ${LIBDIR}/libnetcmds.a

T_CFLAGS+=	-I${TOP}/src/network_cmds/network_cmds_lib
# Apple builds this project with private header sections enabled.
T_CFLAGS+=	-DPRIVATE
T_CFLAGS+=	-include ${TOP}/mk/net-private-compat.h
T_LDADD+=	${LIBDIR}/libnetcmds.a
