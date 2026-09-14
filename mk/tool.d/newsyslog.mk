# newsyslog(8) -- the newsyslog target's two sources.  Unlike the rest of
# syslog.xcodeproj it links no aslcommon, so it is not held up by that
# library's private headers (see mk/tool.d/syslogd.mk).
T_SRCS=		newsyslog.c ptimes.c
T_CFLAGS+=	-std=gnu17 -I${TOP}/src/syslog/libsystem_asl.tproj/include
