# sc_usage(1) reads the trace buffer through kdebug's private types
# (kbufinfo_t, ...).  The internal SDK's <sys/kdebug.h> ends by including
# xnu's <sys/kdebug_private.h>, which include/ carries; it is pulled in the
# same way.
.include "${TOP}/mk/with-libutil.mk"
T_CFLAGS+=	-include sys/kdebug_private.h
T_LDADD+=	-lncurses
