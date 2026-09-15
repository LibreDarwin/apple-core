# mount_url(8) -- the mount_url target of autofs.xcodeproj, which mounts
# URL-type automount entries through NetFS.
#
# <mntopts.h> is libutil's, as Apple's libutil.tbd publishes it; the
# NetFS and NetAuth private declarations it needs are in include/NetFS and
# include/NetAuth.  Stock mount_url links CoreFoundation, NetAuth, NetFS
# and libutil.
T_SRCS=		src/autofs/mount_url/mount_url.c
T_CFLAGS+=	-std=c11 -fobjc-arc -I${TOP}/src/libutil
T_LDADD+=	-framework CoreFoundation -framework NetFS \
		-F/System/Library/PrivateFrameworks -framework NetAuth -lutil
