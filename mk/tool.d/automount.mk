# automount(8) -- the automount target of autofs.xcodeproj.
#
# Private headers, in include/: ServerInformation.h, fakelink.h and
# os/log_private.h (recovered from the shipped libraries), and
# <oncrpc/rpc.h>, the SDK's Sun RPC renamed to oncrpc.framework's exports.
# <mntopts.h> is libutil's.  Stock automount links CoreFoundation,
# OpenDirectory, ServerInformation, SystemConfiguration, libfakelink,
# libutil and oncrpc.
T_SRCS=	src/autofs/automount/automount.c \
		src/autofs/automountlib/auto_subr.c \
		src/autofs/automountlib/deflt.c \
		src/autofs/automountlib/host_is_us.c \
		src/autofs/automountlib/ns_files.c \
		src/autofs/automountlib/ns_fstab.c \
		src/autofs/automountlib/ns_generic.c \
		src/autofs/automountlib/ns_od.c \
		src/autofs/automountlib/selfcheck.c \
		src/autofs/automountlib/sysctl_fsid.c \
		src/autofs/automountlib/umount_by_fsid.c \
		src/autofs/automountlib/we_are_a_server.c
.include "${TOP}/mk/with-autofs.mk"
