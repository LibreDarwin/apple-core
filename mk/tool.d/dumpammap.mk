# dumpammap -- the dumpammap target of autofs.xcodeproj, one of the helper
# tools autofs.kext carries in its Resources.
T_SRCS=		src/autofs/dumpammap/dumpammap.c
T_CFLAGS+=	-std=c11
T_LDADD+=	-framework CoreFoundation -framework OpenDirectory
