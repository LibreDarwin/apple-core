# kextfind(8) -- the kextfind target of kext_tools.xcodeproj.
T_SRCS=		signposts.m kextfind_main.c QEQuery.c kextfind_query.c \
		kextfind_commands.c kextfind_tables.c kextfind_report.c \
		kext_tools_util.c
.include "${TOP}/mk/with-kext_tools.mk"
