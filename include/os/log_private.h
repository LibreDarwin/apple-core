/*
 * <os/log_private.h> -- apple-core's stand-in for libtrace's userspace
 * private logging header.
 *
 * Apple publish the userspace copy nowhere.  autofs' automount calls
 * os_log_with_args(), which libsystem_trace exports and stock
 * /usr/sbin/automount imports; xnu-12377.121.6's libkern/os/log_private.h
 * publishes the declaration of the same function, copied here.  Only what
 * the tree uses is declared.
 */
#ifndef __OS_LOG_PRIVATE_H__
#define __OS_LOG_PRIVATE_H__

#include <os/log.h>
#include <stdarg.h>

__BEGIN_DECLS

void os_log_with_args(os_log_t oslog, os_log_type_t type, const char *format,
    va_list args, void *ret_addr);

/*
 * The log pack handle, for configd's <SystemConfiguration/SCPrivate.h>,
 * which declares __SC_log_send() with one.  libsystem_trace exports the
 * os_log_pack_* functions that take it, and SystemConfiguration's
 * __SC_log_send() in macOS 26.5.2's (25F84) dyld shared cache hands its
 * fourth argument on as a 64-bit pointer: an opaque pack.
 */
typedef struct os_log_pack_s *os_log_pack_t;

__END_DECLS

#endif /* __OS_LOG_PRIVATE_H__ */
