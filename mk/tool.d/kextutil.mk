# kextutil(8) -- the kextutil target of kext_tools.xcodeproj: a
# KernelManagement shim, as on stock macOS.
#
# Its private headers are kextload's, in include/ (see kextload.mk).
# Stock kextutil links SystemPolicy, Security and KernelManagement beside
# what every kext tool links, and libbless statically: kext_tools_util.c
# builds getKernelPathForURL() only when <bless.h> is reachable, and
# kextutil calls it.
_KT=		${T_COPYDIR:S|^${TOP}/||}
T_SRCS=		driverkit.m signposts.m kextutil_main.c staging.m syspolicy.m \
		kext_tools_util.c security.c kextaudit.c \
		${_KT}/KernelManagementShims/kextutil.m \
		${_KT}/KernelManagementShims/ShimHelpers.m
T_CFLAGS+=	-DDEV_KERNEL_SUPPORT -I${TOP}/src/bless/libbless
.include "${TOP}/mk/with-kext_tools.mk"
T_LDADD+=	${LIBDIR}/libbless.a \
		-framework KernelManagement -framework Security \
		-F/System/Library/PrivateFrameworks -framework SystemPolicy
