# libaslcommon -- the aslcommon target of syslog.xcodeproj, the code
# syslog, syslogd and aslmanager share.  asl_ipc.defs is built with MIG as
# both client and server, as the target's file attributes ask; the headers
# land in build/gen/aslcommon for the programs to include too.
#
# BLOCKED: libsystem_asl's private headers (asl_private.h, asl_msg_list.h)
# include <os/object_private.h>.  libdispatch's copy is on this machine,
# but it does not compile against the public SDK -- its line 202,
#     API_AVAILABLE(macos(10.14), ios(12.0), tvos(12.0), watchos(5.0), bridgeos(4.0))
# needs private availability macros -- and syslogd and aslmanager also
# include <xpc/private.h>, the private XPC tree.  <configuration_profile.h>,
# the header these first stopped on, is in include/ from Libinfo-600.
T_NOBUILD=	yes
ASL_GEN=	${TOP}/build/gen/aslcommon
T_SRCS=		asl_memory.c asl_common.c \
		build/gen/aslcommon/asl_ipcUser.c build/gen/aslcommon/asl_ipcServer.c
T_CFLAGS+=	-std=gnu99 -D__MigTypeCheck=1 -I${ASL_GEN} -I${T_SRCDIR} \
		-I${TOP}/src/syslog/libsystem_asl.tproj/include

${ASL_GEN}/asl_ipc.h ${ASL_GEN}/asl_ipcUser.c ${ASL_GEN}/asl_ipcServer.h \
    ${ASL_GEN}/asl_ipcServer.c: ${T_SRCDIR}/asl_ipc.defs
	@mkdir -p ${ASL_GEN}
	cd ${ASL_GEN} && ${MIG} -header asl_ipc.h -user asl_ipcUser.c \
	    -sheader asl_ipcServer.h -server asl_ipcServer.c \
	    ${T_SRCDIR}/asl_ipc.defs

.for s in ${T_SRCS:N*/*}
${T_OBJDIR}/${s:R}.o: ${ASL_GEN}/asl_ipc.h
.endfor
