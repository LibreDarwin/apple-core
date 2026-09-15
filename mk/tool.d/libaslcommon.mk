# libaslcommon -- the aslcommon target of syslog.xcodeproj, the code
# syslog, syslogd and aslmanager share.  asl_ipc.defs is built with MIG as
# both client and server, as the target's file attributes ask; the headers
# land in build/gen/aslcommon for the programs to include too.
#
# libsystem_asl's private headers include <os/object_private.h>, which
# include/ stubs: they use nothing past the public <os/object.h>.
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
