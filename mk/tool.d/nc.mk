# nc(1) -- USE_SELECT, as netcat.xcodeproj sets it, and Network.framework,
# which stock nc links for copyconninfo()/freeconninfo().
#
# netcat.c includes <nw/private.h> when it can and <network/conninfo.h>
# otherwise; include/ carries the latter, recovered from Network.  The
# connection-order and aux-data definitions it also uses (so_cordreq,
# SIOCGCONNORDER, CIAUX_*), the private TCP options (TCP_ECN_MODE, ...),
# EVFILT_SOCK and the _DSCP_* values are xnu's <sys/socket_private.h>,
# <sys/sockio_private.h>, <netinet/tcp_private.h>, <sys/event_private.h>
# and <netinet/in_private.h>, which the internal SDK's public headers end
# by including; they are pulled in the same way.
#
# EV_SET(..., EVFILT_SOCK_ALL_MASK, NULL, NULL) passes NULL for the
# intptr_t data word, which today's clang makes an error.
T_CFLAGS+=	-DUSE_SELECT -Wno-error=int-conversion \
		-include sys/socket_private.h -include sys/sockio_private.h \
		-include netinet/tcp_private.h -include sys/event_private.h \
		-include netinet/in_private.h
T_LDADD+=	-framework Network
