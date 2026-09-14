# libcopyfile -- one of libSystem's sub-libraries, installed as
# /usr/lib/system/libcopyfile.dylib.  The copyfile target's sources and
# cancellation flavour.
#
# BLOCKED: copyfile.c includes <System/sys/content_protection.h> (xnu,
# private) and <quarantine.h> (the quarantine SPI).  The first is in the
# ravynos xnu tree; the second is in no SDK or source tree on this machine.
T_NOBUILD=	yes

T_SRCS=		copyfile.c xattr_flags.c
T_CFLAGS+=	-D__DARWIN_NOW_CANCELABLE=1 -I${T_SRCDIR}
