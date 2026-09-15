# libremovefile -- one of libSystem's sub-libraries, installed as
# /usr/lib/system/libremovefile.dylib.  The removefile target's sources.
# APFS_CLEAR_PURGEABLE and APFSIOC_MARK_PURGEABLE, which no published
# header has, are in include/apfs/apfs_fsctl.h, recovered from Apple's
# shipped libremovefile.
T_SRCS=		removefile_random.c removefile_rename_unlink.c \
		removefile_sunlink.c removefile_tree_walker.c removefile.c
T_CFLAGS+=	-D__DARWIN_NON_CANCELABLE=1 -I${T_SRCDIR}
T_INSTALL_NAME=	/usr/lib/system/libremovefile.dylib
