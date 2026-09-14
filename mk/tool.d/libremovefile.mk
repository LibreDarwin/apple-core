# libremovefile -- one of libSystem's sub-libraries, installed as
# /usr/lib/system/libremovefile.dylib.  The removefile target's sources.
#
# BLOCKED: removefile_tree_walker.c clears purgeable state with
# APFS_CLEAR_PURGEABLE and APFSIOC_MARK_PURGEABLE from <apfs/apfs_fsctl.h>.
# Neither our include/apfs copy nor the internal SDK's has them -- both
# predate removefile-85 -- and no newer copy is on this machine.
T_NOBUILD=	yes

T_SRCS=		removefile_random.c removefile_rename_unlink.c \
		removefile_sunlink.c removefile_tree_walker.c removefile.c
T_CFLAGS+=	-D__DARWIN_NON_CANCELABLE=1 -I${T_SRCDIR}
