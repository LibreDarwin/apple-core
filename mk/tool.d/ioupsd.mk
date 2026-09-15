# ioupsd(8) -- the ioupsd target of PowerManagement.xcodeproj, the UPS and
# accessory battery daemon.
#
# IOKit/hid/AppleHIDUsageTables.h, in include/, is recovered from stock
# ioupsd (see the header); the power source private headers are
# IOKitUser-100231.120.3's.  ioupspluginmig.defs is built with MIG on both
# sides: IOUPSPrivate.c is its client, upsd.m its server.  Stock ioupsd
# links CoreFoundation, IOKit, SystemConfiguration, Foundation, libobjc and
# the private SoftLinking framework.
#
# mk/patches/ioupsd declares needsMerge, which upsd.m tests but the drop
# never declares or sets (see the patch); the sources are therefore named
# by their TOP-relative path into the patched copy.
UPS_GEN=	${TOP}/build/gen/ioupsd
_UPS=		${T_COPYDIR:S|^${TOP}/||}
T_SRCS=		${_UPS}/ioupsd/IOUPSPrivate.c \
		${_UPS}/ioupsd/upsd.m \
		${_UPS}/ioupsd/ioupsplugin.c \
		build/gen/ioupsd/ioupspluginmigUser.c \
		build/gen/ioupsd/ioupspluginmigServer.c
T_CFLAGS+=	-fobjc-arc -I${UPS_GEN} -I${TOP}/src/PowerManagement/ioupsd \
		-I${TOP}/src/PowerManagement/common \
		'-D__API_AVAILABLE_PLATFORM_bridgeos(x)=bridgeos,introduced=x' \
		'-D__API_DEPRECATED_PLATFORM_bridgeos(x,y)=bridgeos,introduced=x,deprecated=y' \
		'-D__API_UNAVAILABLE_PLATFORM_bridgeos=bridgeos,unavailable'
T_LDADD+=	-framework CoreFoundation -framework IOKit \
		-framework SystemConfiguration -framework Foundation -lobjc \
		-F/System/Library/PrivateFrameworks -framework SoftLinking

${UPS_GEN}/ioupspluginmig.h ${UPS_GEN}/ioupspluginmigUser.c \
    ${UPS_GEN}/ioupspluginmigServer.h ${UPS_GEN}/ioupspluginmigServer.c: \
    ${TOP}/src/PowerManagement/ioupsd/ioupspluginmig.defs
	@mkdir -p ${UPS_GEN}
	cd ${UPS_GEN} && ${MIG} -header ioupspluginmig.h \
	    -user ioupspluginmigUser.c -sheader ioupspluginmigServer.h \
	    -server ioupspluginmigServer.c \
	    ${TOP}/src/PowerManagement/ioupsd/ioupspluginmig.defs

.for s in ${T_SRCS:N*/gen/*}
${T_OBJDIR}/${s:T:R}.o: ${UPS_GEN}/ioupspluginmig.h
.endfor
