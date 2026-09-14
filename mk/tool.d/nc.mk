# nc(1) -- USE_SELECT, as netcat.xcodeproj sets it, and libnetwork for
# the Network.framework calls Apple's netcat makes.
#
# BLOCKED: netcat.c includes <nw/private.h> and <network/conninfo.h>, for
# the copyconninfo()/freeconninfo() pair that reports a connectx(2)
# connection.  nw/private.h is in the internal SDK; network/conninfo.h is
# in no SDK or source tree on this machine, and neither function is
# declared in the public SDK or exported by any of its stubs.
T_NOBUILD=	yes

T_CFLAGS+=	-DUSE_SELECT
T_LDADD+=	-lnetwork
