# mkextunpack(8) -- the mkextunpack target of kext_tools.xcodeproj.
T_SRCS=		signposts.m mkextunpack_main.c compression.c kext_tools_util.c
.include "${TOP}/mk/with-kext_tools.mk"
