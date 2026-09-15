# pmset(1) -- the pmset target of PowerManagement.xcodeproj.
#
# Open-source headers in include/: IOKitUser-100231.120.3's power
# management and power source private headers and IOPlatformSupportPrivate.h,
# configd-1405.120.5's SCValidation.h, and xnu's IOHibernatePrivate.h,
# IOReportTypes.h and corecrypto headers.  Recovered from the shipped
# binaries: IOReport.h, LockdownMode/LockdownMode.h,
# SkyLight/SLSDisplayManager.h and MobileGestalt.h (see each header).
#
# pmconfigd's powermanagement.defs is built with MIG as the client pmset
# is.  Stock pmset links LockdownMode, SkyLight, libIOReport,
# DisplayServices, CoreFoundation, IOKit, SystemConfiguration,
# libMobileGestalt, Foundation and libobjc.
PM_GEN=		${TOP}/build/gen/pmset
T_SRCS=		src/PowerManagement/common/CommonLib.c \
		src/PowerManagement/pmset/pmset.m \
		build/gen/pmset/powermanagementUser.c
T_CFLAGS+=	-fobjc-arc -D__I_AM_PMSET__ -DUSE_SYSTEMCONFIGURATION_PRIVATE_HEADERS \
		-I${PM_GEN} -I${TOP}/src/PowerManagement/common \
		-I${TOP}/src/PowerManagement/pmconfigd \
		'-D__API_AVAILABLE_PLATFORM_bridgeos(x)=bridgeos,introduced=x' \
		'-D__API_DEPRECATED_PLATFORM_bridgeos(x,y)=bridgeos,introduced=x,deprecated=y' \
		'-D__API_UNAVAILABLE_PLATFORM_bridgeos=bridgeos,unavailable'
T_LDADD+=	-framework CoreFoundation -framework IOKit \
		-framework SystemConfiguration -framework Foundation -lobjc \
		-F/System/Library/PrivateFrameworks -framework LockdownMode \
		-framework SkyLight -framework DisplayServices \
		-lIOReport -lMobileGestalt

${PM_GEN}/powermanagement.h ${PM_GEN}/powermanagementUser.c: \
    ${TOP}/src/PowerManagement/pmconfigd/powermanagement.defs
	@mkdir -p ${PM_GEN}
	cd ${PM_GEN} && ${MIG} -I${TOP}/src/PowerManagement/pmconfigd -I${TOP}/include \
	    -header powermanagement.h -user powermanagementUser.c \
	    -sheader /dev/null -server /dev/null \
	    ${TOP}/src/PowerManagement/pmconfigd/powermanagement.defs

.for s in ${T_SRCS:N*/gen/*}
${T_OBJDIR}/${s:T:R}.o: ${PM_GEN}/powermanagement.h
.endfor
