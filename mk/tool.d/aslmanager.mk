# aslmanager(8) -- the aslmanager target of syslog.xcodeproj, over
# aslcommon and zlib.
T_SRCS=	daemon.c aslmanager.c
.include "${TOP}/mk/with-aslcommon.mk"
T_LDADD+=	-lz
