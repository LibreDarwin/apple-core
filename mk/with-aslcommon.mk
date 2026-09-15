# mk/with-aslcommon.mk
#
# Shared fragment: link against aslcommon, syslog.xcodeproj's static
# library, and see what it sees -- libsystem_asl's private headers, its
# own, and the asl_ipc headers MIG generates into build/gen/aslcommon.
#
#	.include "${TOP}/mk/with-aslcommon.mk"

ASL_GEN=	${TOP}/build/gen/aslcommon
T_CFLAGS+=	-std=gnu99 -DINET6 -I${ASL_GEN} \
		-I${TOP}/src/syslog/libsystem_asl.tproj/include \
		-I${TOP}/src/syslog/aslcommon
T_LDADD+=	${LIBDIR}/libaslcommon.a
