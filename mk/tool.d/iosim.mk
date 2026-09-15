# iosim(1) -- the iosim target of system_cmds.xcodeproj.
#
# iosim.c includes "panic.h", system_cmds' at/panic.h; Apple's target
# links IOKit, CoreFoundation and libutil.
T_SRCS=		iosim.c
T_CFLAGS+=	-I${TOP}/src/system_cmds/at
T_LDADD+=	-framework IOKit -framework CoreFoundation -lutil
