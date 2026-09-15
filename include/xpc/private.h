/*
 * <xpc/private.h> -- the libxpc SPI apple-core's sources call.
 *
 * Apple publish no copy of this header.  Every declaration below was read
 * from libxpc.dylib, libsystem_asl.dylib and libsystem_info.dylib in
 * macOS 26.5.2's (25F84) dyld shared cache with ipsw and otool; each
 * symbol is exported by libxpc and listed in the SDK's libxpc stub.
 * Only what the tree uses is declared.
 */
#ifndef __XPC_PRIVATE_H__
#define __XPC_PRIVATE_H__

#include <sys/cdefs.h>
#include <mach/message.h>
#include <stdbool.h>
#include <stdint.h>
#include <xpc/xpc.h>

__BEGIN_DECLS

/*
 * Pipes: synchronous request/reply over a Mach service.  libxpc carries
 * an OS_xpc_pipe class, so the type is declared like the public objects.
 *
 * xpc_pipe_create() tests bit 1 of its flags itself and looks the name up
 * privileged when it is set.  libsystem_asl's shim passes 0x6 for
 * PRIVILEGED | USE_SYNC_IPC_OVERRIDE, libsystem_info's ds and membership
 * modules 0xa for PRIVILEGED | PROPAGATE_QOS (Libinfo-600's sources name
 * both), which leaves 0x4 and 0x8 for the other two.
 */
XPC_DECL(xpc_pipe);

#define XPC_PIPE_PRIVILEGED		(1ULL << 1)
#define XPC_PIPE_USE_SYNC_IPC_OVERRIDE	(1ULL << 2)
#define XPC_PIPE_PROPAGATE_QOS		(1ULL << 3)

XPC_RETURNS_RETAINED
xpc_pipe_t xpc_pipe_create(const char *name, uint64_t flags);

/* Clears the pipe's port and returns nothing. */
void xpc_pipe_invalidate(xpc_pipe_t pipe);

/* Tail-calls _xpc_pipe_routine(pipe, 0, message, reply, 0); an errno. */
int xpc_pipe_routine(xpc_pipe_t pipe, xpc_object_t message,
    xpc_object_t *reply);

/*
 * Entitlements.  The token form reads all eight audit_token_t words from
 * its second argument; a NULL key copies the whole dictionary.
 */
XPC_RETURNS_RETAINED
xpc_object_t xpc_copy_entitlement_for_token(const char *key,
    audit_token_t *token);

XPC_RETURNS_RETAINED
xpc_object_t xpc_connection_copy_entitlement_value(xpc_connection_t connection,
    const char *entitlement);

/* Takes nothing; marks the calling daemon active for launchd. */
void xpc_track_activity(void);

/* Takes nothing and returns a byte from libxpc's runtime state. */
bool _xpc_runtime_is_app_sandboxed(void);

__END_DECLS

#endif /* __XPC_PRIVATE_H__ */
