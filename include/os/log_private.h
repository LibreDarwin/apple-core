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

/*
 * The in-process log hook, for system_cmds' gcore, which mirrors os_log
 * output to stderr through it.  libsystem_trace exports both functions.
 * Read from libsystem_trace in macOS 26.5.2's (25F84) dyld shared cache:
 * os_log_set_hook() hands its level and its block on to its implementation
 * (with NULL between them) and gcore keeps its result as the previous hook
 * it chains to; os_log_copy_message_string() reads the message's fields
 * through its one pointer argument before composing the string gcore
 * prints and frees.
 */
typedef struct os_log_message_s *os_log_message_t;
typedef void (^os_log_hook_t)(os_log_type_t type, os_log_message_t msg);

os_log_hook_t os_log_set_hook(os_log_type_t level, os_log_hook_t hook);
char *os_log_copy_message_string(os_log_message_t msg);

__END_DECLS

#endif /* __OS_LOG_PRIVATE_H__ */
