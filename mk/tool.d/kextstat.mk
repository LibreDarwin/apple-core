# kextstat(8) -- the kextstat target of kext_tools.xcodeproj.  As on stock
# macOS, it is a shim: KernelManagementShims turns its arguments into a
# `kmutil showloaded' invocation.
# The shims live in a subdirectory of the patched copy, so they are named
# by their TOP-relative path into it.
_KT=		${T_COPYDIR:S|^${TOP}/||}
T_SRCS=		signposts.m kextstat_main.c kext_tools_util.c \
		${_KT}/KernelManagementShims/kextstat.m \
		${_KT}/KernelManagementShims/ShimHelpers.m
.include "${TOP}/mk/with-kext_tools.mk"
