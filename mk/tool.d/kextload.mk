# kextload(8) -- the kextload target of kext_tools.xcodeproj: a
# KernelManagement shim, as on stock macOS, which still audits and
# policy-checks what it hands over.
#
# The private headers its sources include are in include/: SystemPolicy.h
# (class-dumped), MultiverseSupport/kext_audit_plugin_common.h (read from
# stock kextutil), CoreFoundation/CFXPCBridge.h (read from CoreFoundation)
# and os/cleanup.h (Libc-1752.120.2).  Stock kextload links SystemPolicy,
# Security and KernelManagement beside what every kext tool links.
_KT=		${T_COPYDIR:S|^${TOP}/||}
T_SRCS=		driverkit.m security.c staging.m syspolicy.m kextload_main.c \
		kext_tools_util.c signposts.m kextaudit.c \
		${_KT}/KernelManagementShims/kextload.m \
		${_KT}/KernelManagementShims/Shims.m \
		${_KT}/KernelManagementShims/ShimHelpers.m
T_CFLAGS+=	-DDEV_KERNEL_SUPPORT
.include "${TOP}/mk/with-kext_tools.mk"
T_LDADD+=	-framework KernelManagement -framework Security \
		-F/System/Library/PrivateFrameworks -framework SystemPolicy
