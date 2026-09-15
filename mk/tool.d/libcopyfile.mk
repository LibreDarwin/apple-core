# libcopyfile -- one of libSystem's sub-libraries, installed as
# /usr/lib/system/libcopyfile.dylib.  The copyfile target's sources and
# cancellation flavour.
#
# <System/sys/content_protection.h> is xnu's.  <quarantine.h> is published
# by no one: include/ carries xcode-tools' reconstruction of it, with the
# pieces copyfile needs beyond libarchive recovered from Apple's shipped
# libcopyfile and libquarantine (see the header).
T_SRCS=		copyfile.c xattr_flags.c
T_CFLAGS+=	-D__DARWIN_NOW_CANCELABLE=1 -I${T_SRCDIR}
T_INSTALL_NAME=	/usr/lib/system/libcopyfile.dylib
