# kextunload(8) -- the kextunload target of kext_tools.xcodeproj.  Like
# Apple's, a KernelManagement shim: it hands unload requests to kmutil,
# and links KernelManagement for KernelManagementClient.
_KT=		${T_COPYDIR:S|^${TOP}/||}
T_SRCS=		signposts.m kextunload_main.c kext_tools_util.c \
		${_KT}/KernelManagementShims/Shims.m \
		${_KT}/KernelManagementShims/kextunload.m \
		${_KT}/KernelManagementShims/ShimHelpers.m
.include "${TOP}/mk/with-kext_tools.mk"
T_LDADD+=	-framework KernelManagement
