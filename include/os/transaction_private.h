/*
 * <os/transaction_private.h> -- the os_transaction SPI syslogd and
 * aslmanager call.
 *
 * Apple publish no copy of this header.  Read from libxpc.dylib in
 * macOS 26.5.2's (25F84) dyld shared cache with ipsw and otool:
 * os_transaction_create() strlen()s its one argument, copies up to 0x1cf
 * bytes of it (or keeps the pointer when dyld says the memory is
 * immutable) and returns a freshly allocated OS_os_transaction, a direct
 * OS_object subclass -- callers drop it with os_release().
 * Only what the tree uses is declared.
 */
#ifndef __OS_TRANSACTION_PRIVATE_H__
#define __OS_TRANSACTION_PRIVATE_H__

#include <sys/cdefs.h>
#include <os/object.h>

__BEGIN_DECLS

OS_OBJECT_DECL_CLASS(os_transaction);

OS_OBJECT_RETURNS_RETAINED OS_WARN_RESULT_NEEDS_RELEASE
os_transaction_t os_transaction_create(const char *description);

__END_DECLS

#endif /* __OS_TRANSACTION_PRIVATE_H__ */
