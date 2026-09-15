/*
 * <CoreFoundation/CFXPCBridge.h> -- the CF-to-XPC conversion SPI.
 *
 * Apple publish no copy of this header.  Read from CoreFoundation in
 * macOS 26.5.2's (25F84) dyld shared cache with ipsw and otool:
 * _CFXPCCreateXPCObjectFromCFObject() returns NULL for a NULL argument and
 * otherwise dispatches on CFGetTypeID() of its one argument, starting
 * with CFNull, returning a new xpc object.  kext_tools' driverkit.m, the
 * one caller, hands it a CFDictionaryRef and checks the result for NULL.
 * Only what the tree uses is declared.
 */
#ifndef __COREFOUNDATION_CFXPCBRIDGE__
#define __COREFOUNDATION_CFXPCBRIDGE__

#include <CoreFoundation/CoreFoundation.h>
#include <xpc/xpc.h>

CF_EXTERN_C_BEGIN

XPC_RETURNS_RETAINED
xpc_object_t _CFXPCCreateXPCObjectFromCFObject(CFTypeRef object);

CF_EXTERN_C_END

#endif /* __COREFOUNDATION_CFXPCBRIDGE__ */
