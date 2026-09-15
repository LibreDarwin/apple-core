/*
 * <network/conninfo.h> -- Network.framework's connection-info SPI.
 *
 * Apple publish no copy of this header.  Read from Network in macOS
 * 26.5.2's (25F84) dyld shared cache with ipsw and otool, and checked
 * against stock /usr/bin/nc, the one caller in the tree:
 *
 *  - copyconninfo(s, cid, &cfo) returns 0 or an errno, after
 *    ioctl(s, SIOCGCONNINFO) with cid stored in the request.
 *  - freeconninfo() frees the pointers at 0x8, 0x10 and 0x20, then the
 *    structure.  nc reads flags at 0x0, the interface index at 0x4, the
 *    source and destination sockaddrs at 0x8 and 0x10, and compares the
 *    32-bit word at 0x1c with CIAUX_TCP before using the pointer at 0x20.
 *
 * The CIF_* and CIAUX_* values are xnu's, in <sys/socket_private.h>.
 */
#ifndef _NETWORK_CONNINFO_H_
#define _NETWORK_CONNINFO_H_

#include <sys/cdefs.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <stdint.h>

__BEGIN_DECLS

typedef struct conninfo {
	uint32_t	ci_flags;	/* CIF_* */
	uint32_t	ci_ifindex;	/* outgoing interface */
	struct sockaddr	*ci_src;
	struct sockaddr	*ci_dst;
	int		ci_error;
	uint32_t	ci_aux_type;	/* CIAUX_* */
	void		*ci_aux_data;
} conninfo_t;

int copyconninfo(int s, sae_connid_t cid, conninfo_t **cfop);
void freeconninfo(conninfo_t *cfo);

__END_DECLS

#endif /* _NETWORK_CONNINFO_H_ */
