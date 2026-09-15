# fs_usage(1) is built on the ktrace session SPI, declared by
# include/ktrace/session.h (recovered from the ktrace framework and stock
# fs_usage; see the header), and on xnu's private <System/sys/kdebug.h>,
# in include/.  Stock fs_usage links the private ktrace framework and
# libutil.
# The private fcntl commands it names (F_SETCONFINED, F_MARKDEPENDENCY,
# ...) are xnu's <sys/fcntl_private.h>, in include/, which the internal
# SDK's <sys/fcntl.h> ends by including; it is pulled in the same way.
.include "${TOP}/mk/with-libutil.mk"
T_CFLAGS+=	-include sys/fcntl_private.h
T_LDADD+=	-F/System/Library/PrivateFrameworks -framework ktrace
