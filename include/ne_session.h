/*
 * <ne_session.h> -- what configd's SCNetworkConnectionPrivate.h takes from
 * NetworkExtension's session SPI, as PowerManagement's pmset pulls it in.
 *
 * Apple publish no copy of this header; the ne_session functions live in
 * libsystem_networkextension, whose SDK stub exports them.  The one name
 * the tree needs is the status type SCNetworkConnectionGetStatusFromNEStatus()
 * takes.  Read from SystemConfiguration in macOS 26.5.2's (25F84) dyld
 * shared cache: that function subtracts 1 from its 32-bit argument, maps
 * 1..5 through a table and returns -1 otherwise, so the status is a
 * 32-bit enumeration.  Only what the tree uses is declared.
 */
#ifndef _NE_SESSION_H_
#define _NE_SESSION_H_

#include <stdint.h>

typedef int32_t ne_session_status_t;

#endif /* _NE_SESSION_H_ */
