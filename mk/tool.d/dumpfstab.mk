# dumpfstab -- the dumpfstab target of autofs.xcodeproj, one of the helper
# tools autofs.kext carries in its Resources.  Stock links libutil.dylib.
T_SRCS=		src/autofs/dumpfstab/dumpfstab.c
T_CFLAGS+=	-std=c11
T_LDADD+=	-lutil
