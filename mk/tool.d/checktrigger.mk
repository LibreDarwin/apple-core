# checktrigger -- the checktrigger target of autofs.xcodeproj, one of the
# helper tools autofs.kext carries in its Resources.
T_SRCS=		src/autofs/checktrigger/checktrigger.c
T_CFLAGS+=	-std=c11
