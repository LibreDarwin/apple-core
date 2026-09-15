# kextlibs(8) -- the kextlibs target of kext_tools.xcodeproj.
T_SRCS=		signposts.m kextlibs_main.c kext_tools_util.c
.include "${TOP}/mk/with-kext_tools.mk"
