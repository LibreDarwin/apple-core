/*
 * <NetAuth/NetAuth.h> -- what autofs' mount_url takes from the NetAuth
 * framework.
 *
 * Apple publish no copy of this header.  Read from macOS 26.5.2 (25F84):
 * NAConnectToServerSync() in NetAuth (dyld shared cache) saves five
 * arguments before starting its logging controller; mount_url passes the
 * server URL, the mount directory string, its open and mount option
 * dictionaries and the address of a CFDictionaryRef for the mount info,
 * and keeps the result in an int.  The SDK's NetAuth.tbd exports it.  Only
 * what the tree uses is declared.
 */
#ifndef _NETAUTH_NETAUTH_H_
#define _NETAUTH_NETAUTH_H_

#include <CoreFoundation/CoreFoundation.h>

CF_EXTERN_C_BEGIN

extern int NAConnectToServerSync(CFURLRef url, CFStringRef mountpath,
    CFDictionaryRef openOptions, CFDictionaryRef mountOptions,
    CFDictionaryRef *mountInfo);

CF_EXTERN_C_END

#endif /* _NETAUTH_NETAUTH_H_ */
